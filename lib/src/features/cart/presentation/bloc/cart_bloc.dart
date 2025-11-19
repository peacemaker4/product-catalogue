import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue/src/features/cart/data/models/cart_item.dart';
import 'package:product_catalogue/src/features/cart/data/repositories/cart_repository.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async{
    final items = await repository.getFullCart();
    final total = getTotalPrice(items);
    emit(CartLoaded(items: items, total: total));
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    repository.addToCart(event.id);
    add(LoadCartEvent());
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    repository.removeFromCart(event.id);
    add(LoadCartEvent());
  }

  double getTotalPrice(List<Product> cart){
    final total = cart.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );
    return total;
  }
}