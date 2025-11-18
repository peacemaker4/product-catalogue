part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent {}

class LoadProductDetailEvent extends ProductDetailEvent {
  final int id;
  LoadProductDetailEvent(this.id);
}