import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import 'order_details_screen.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderError) {
            return Center(child: Text(state.message));
          }

          if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders yest.'));
            }

            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Order #${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total: AED ${order.total.toStringAsFixed(2)}'),
                        Text(
                          'Status: ${order.status.toString().split('.').last}',
                        ),
                        Text(
                          'Date:  ${order.createdAt.toString().split(' ')[0]}',
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => OrderDetailsScreen(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No orders found'));
        },
      ),
    );
  }
}
