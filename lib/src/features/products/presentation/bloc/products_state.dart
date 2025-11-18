part of 'products_bloc.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<String> categories;
  final List<Product>? filteredProducts;

  ProductsLoaded({
    required this.products,
    required this.categories,
    this.filteredProducts,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    List<String>? categories,
    List<Product>? filteredProducts,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      filteredProducts: filteredProducts ?? this.filteredProducts,
    );
  }
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError({required this.message});
}