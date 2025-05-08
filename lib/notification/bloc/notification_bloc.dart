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
  }
}