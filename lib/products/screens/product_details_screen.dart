import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../../cart/blocs/cart_bloc.dart';
import '../../cart/blocs/cart_events.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Product Name
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Product Image
              SliverToBoxAdapter(
                child: Hero(
                  tag: widget.product.id,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    color: Colors.white,
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 100),
                          ),
                    ),
                  ),
                ),
              ),
              // Product Details
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Product Name and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AED ${widget.product.price.toStringAsFixed(2)}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Category: ${widget.product.category}', style: TextStyle()),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.description,
                          maxLines: _isExpanded ? null : 3,
                          overflow: _isExpanded ? null : TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (widget.product.description.length > 100)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Text(
                              _isExpanded ? 'Show less' : 'Read more',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Stock Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            widget.product.stock > 0
                                ? Colors.green[50]
                                : Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.product.stock > 0
                                ? Icons.check_circle
                                : Icons.remove_circle,
                            color:
                                widget.product.stock > 0
                                    ? Colors.green[700]
                                    : Colors.red[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.product.stock > 0
                                ? 'In Stock (${widget.product.stock})'
                                : 'Out of Stock',
                            style: TextStyle(
                              color:
                                  widget.product.stock > 0
                                      ? Colors.green[700]
                                      : Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80), // Space for bottom button
                  ]),
                ),
              ),
            ],
          ),
          // Add to Cart Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed:
                    widget.product.stock > 0
                        ? () {
                          context.read<CartBloc>().add(
                            AddToCart(widget.product),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFF097969),
                ),
                child: Text(
                  widget.product.stock > 0
                      ? 'Add to Cart - AED ${widget.product.price.toStringAsFixed(2)}'
                      : 'Out of Stock',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
