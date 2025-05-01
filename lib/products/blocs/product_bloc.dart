import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'product_event.dart';
import 'product_state.dart';
import '../services/product_services.dart';
import '../models/product.dart';
import '../models/pagination_response.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductServices productServices;

  ProductBloc(this.productServices) : super(ProductLoading()) {
    on<FetchProducts>(_onFetchProducts);
    on<CreateProduct>(_oncreateProduct);
  }

  Future<PaginatedResponse<Product>> fetchProductsPage({
    required int page,
    required int limit,
  }) async {
    try {
      developer.log('Fetching products page: $page, limit: $limit');
      return await productServices.getProducts(
        // Changed from fetchProducts to getProducts
        page: page,
        limit: limit,
      );
    } catch (e) {
      developer.log('Error in fetchProductsPage', error: e);
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      developer.log('Starting to fetch products');
      emit(ProductLoading());

      final response = await productServices.getProducts(
        // Changed from fetchProducts to getProducts
        page: 1,
        limit: 10,
      );

      developer.log(
        'Products fetched successfully: ${response.products.length} items',
      );
      emit(ProductLoaded(response.products));
    } catch (e) {
      developer.log('Error in _onFetchProducts', error: e);
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _oncreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      await productServices.createProduct(event.product);
      add(FetchProducts());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
