import 'package:product_catalogue/src/core/services/logger_service.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';
import 'package:bloc/bloc.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState>{
  final ProductRepository repository;
  final _logger = LoggerService().instance;

  ProductsBloc({required this.repository}) : super(ProductsInitial()){
    on<LoadProductsEvent>(_onLoadProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(LoadProductsEvent event, Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    try{
      final products = await repository.fetchProducts();
      final categories = await repository.fetchCategories();
      emit(ProductsLoaded(products: products, categories: categories));
    }
    catch(e, st){
      _logger.handle(e, st);
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshProducts(RefreshProductsEvent event, Emitter<ProductsState> emit) async {
    add(LoadProductsEvent());
  }
}