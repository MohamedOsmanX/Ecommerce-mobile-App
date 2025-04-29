import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_state.dart';
import '../blocs/cart_events.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is CartUpdated) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'AED ${item.product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: item.quantity > 1
                                                    ? () {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(DecreaseQuantity(
                                                                item.product));
                                                      }
                                                    : null,
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                              Container(
                                                constraints: const BoxConstraints(
                                                    minWidth: 40),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: item.quantity <
                                                        item.product.stock
                                                    ? () {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(IncreaseQuantity(
                                                                item.product));
                                                      }
                                                    : null,
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          color: Colors.red,
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                                RemoveFromCart(item.product));
                                          },
                                        ),
                                      ],
                                    ),
                                    if (item.quantity >= item.product.stock)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Maximum stock reached',
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Cart Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'AED ${_calculateTotal(state.items).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  context.read<CartBloc>().add(ClearCart());
                                },
                                child: const Text('Clear Cart'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  // Checkout functionality will be added later
                                },
                                child: const Text('Checkout'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }
}