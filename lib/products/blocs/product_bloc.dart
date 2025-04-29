import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../services/product_services.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductServices productServices;

  ProductBloc(this.productServices) : super(ProductLoading()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productServices.fetchProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
