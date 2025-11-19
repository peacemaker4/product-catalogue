part of 'cart_bloc.dart';

abstract class CartState {}

class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {
  final List<Product> items;
  final double total;
  CartLoaded({required this.items, required this.total});
}
class CartError extends CartState {
  final String message;
  CartError({required this.message});
}