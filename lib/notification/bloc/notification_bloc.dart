import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

// Events
abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {}

class FetchSupplierNotificationsEvent extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

// States
abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc(this.notificationService) : super(NotificationInitial()) {
    on<FetchNotificationsEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await notificationService.fetchNotifications();
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError('Failed to fetch notifications: $e'));
      }
    });

    on<FetchSupplierNotificationsEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await notificationService.fetchSupplierNotifications();
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError('Failed to fetch supplier notifications: $e'));
      }
    });

    on<MarkNotificationAsRead>((event, emit) async {
      try {
        await notificationService.markNotificationAsRead(event.notificationId);
        
        // If we have notifications loaded, update the state with the read notification
        if (state is NotificationLoaded) {
          final currentNotifications = (state as NotificationLoaded).notifications;
          final updatedNotifications = currentNotifications.map((notification) {
            if (notification.id == event.notificationId) {
              // Create a new notification with isRead set to true
              return NotificationModel(
                id: notification.id,
                title: notification.title,
                message: notification.message,
                timestamp: notification.timestamp,
                isRead: true,
                type: notification.type,
                orderDetails: notification.orderDetails,
              );
            }
            return notification;
          }).toList();
          
          emit(NotificationLoaded(updatedNotifications));
        }
      } catch (e) {
        // We don't change the state on error to avoid disrupting the UI
        print('Error marking notification as read: $e');
      }
    });
  }
}