import 'package:bloc/bloc.dart';
import 'package:product_catalogue/src/core/services/logger_service.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository;
  final _logger = LoggerService().instance;

  ProductDetailBloc({required this.repository}) : super(ProductDetailInitial()) {
    on<LoadProductDetailEvent>(_onLoadProductDetail);
  }

  Future<void> _onLoadProductDetail(LoadProductDetailEvent event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      final product = await repository.fetchProductById(event.id);
      print(product);
      emit(ProductDetailLoaded(product));
    } catch (e, st) {
      _logger.handle(e, st);
      emit(ProductDetailError(e.toString()));
    }
  }
}
