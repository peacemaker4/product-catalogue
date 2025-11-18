part of 'products_bloc.dart';

abstract class ProductsEvent {}

class LoadProductsEvent extends ProductsEvent {}

class RefreshProductsEvent extends ProductsEvent {}

class SearchProductsEvent extends ProductsEvent {
  final String query;
  SearchProductsEvent(this.query);
}

class FilterByCategoryEvent extends ProductsEvent {
  final String category;
  FilterByCategoryEvent(this.category);
}

class SortProductsEvent extends ProductsEvent {
  final String? sortOrder;
  SortProductsEvent(this.sortOrder);
}