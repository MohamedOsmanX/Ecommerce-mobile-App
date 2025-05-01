import 'package:ecommerce_app/products/models/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final Product product;

  const CreateProduct({required this.product});
}
