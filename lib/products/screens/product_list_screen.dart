import 'package:ecommerce_app/products/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/product_grid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  static const _pageSize = 10;
  bool _isGridView = false;
  final _searchController = TextEditingController();
  final PagingController<int, Product> _pageingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pageingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }


Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await context.read<ProductBloc>().fetchProductsPage(
        page: pageKey,
        limit: _pageSize,
      );
      
      final isLastPage = response.currentPage >= response.totalPages;
      if (isLastPage) {
        _pageingController.appendLastPage(response.products);
      } else {
        _pageingController.appendPage(response.products, pageKey + 1);
      }
    } catch (error) {
      _pageingController.error = error;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            ProductSearchBar(
              controller: _searchController,
              onChanged: (value) {},
              isGridView: _isGridView,
              onViewToggle: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh:
                    () => Future.sync(() => _pageingController.refresh()),
                child:
                    _isGridView
                        ? PagedGridView<int, Product>(
                          pagingController: _pageingController,
                          padding: EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                          builderDelegate: PagedChildBuilderDelegate<Product>(
                            itemBuilder:
                                (context, product, index) =>
                                    ProductGridItem(product: product),
                            firstPageProgressIndicatorBuilder:
                                (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            noItemsFoundIndicatorBuilder:
                                (_) => const Center(
                                  child: Text('No products found.'),
                                ),
                          ),
                        )
                        : PagedListView(
                          pagingController: _pageingController,
                          builderDelegate: PagedChildBuilderDelegate<Product>(
                            itemBuilder:
                                (context, product, index) =>
                                    ProductCard(product: product),
                            firstPageProgressIndicatorBuilder:
                                (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            noItemsFoundIndicatorBuilder:
                                (_) => const Center(
                                  child: Text('No products found'),
                                ),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
