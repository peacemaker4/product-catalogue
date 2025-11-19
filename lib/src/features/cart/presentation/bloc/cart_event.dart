part of 'cart_bloc.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}
class AddToCartEvent extends CartEvent {
  final int id;
  AddToCartEvent(this.id);
}
class RemoveFromCartEvent extends CartEvent {
  final int id;
  RemoveFromCartEvent(this.id);
}
