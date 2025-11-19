import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue/src/features/cart/data/models/cart_item.dart';
import 'package:product_catalogue/src/features/cart/data/repositories/cart_repository.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/core/services/logger_service.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;
  final _logger = LoggerService().instance;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async{
    try{
      final items = await repository.getFullCart();
      final total = getTotalPrice(items);
      emit(CartLoaded(items: items, total: total));
    }
    catch(e, st){
      _logger.handle(e, st);
      emit(CartError(message: e.toString()));
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    try{
      repository.addToCart(event.id);
      add(LoadCartEvent());
    }
    catch(e, st){
      _logger.handle(e, st);
      emit(CartError(message: e.toString()));
    }
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    try{
      repository.removeFromCart(event.id);
      add(LoadCartEvent());
    }
    catch(e, st){
      _logger.handle(e, st);
      emit(CartError(message: e.toString()));
    }
  }

  double getTotalPrice(List<Product> cart){
    final total = cart.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );
    return total;
  }
}