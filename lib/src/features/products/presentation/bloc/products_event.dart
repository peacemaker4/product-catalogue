part of 'products_bloc.dart';

abstract class ProductsEvent {}

class LoadProductsEvent extends ProductsEvent {}

class SearchProductsEvent extends ProductsEvent {
  final String query;
  SearchProductsEvent(this.query);
}

class RefreshProductsEvent extends ProductsEvent {}