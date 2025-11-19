import 'package:product_catalogue/src/core/services/logger_service.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState>{
  final ProductRepository repository;
  final _logger = LoggerService().instance;

  ProductsBloc({required this.repository}) : super(ProductsInitial()){
    on<LoadProductsEvent>(_onLoadProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
    on<SearchProductsEvent>(_onSearchProducts, transformer: _debounce());
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<SortProductsEvent>(_onSortProducts);
  }

  Future<void> _onLoadProducts(LoadProductsEvent event, Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    try{
      final products = await repository.fetchProducts();
      final categories = await repository.fetchCategories();
      emit(ProductsLoaded(products: products, categories: categories, searchQuery: "", selectedCategory: "", sortOrder: ""));
    }
    catch(e, st){
      _logger.handle(e, st);
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshProducts(RefreshProductsEvent event, Emitter<ProductsState> emit) async {
    add(LoadProductsEvent());
  }

  Future<void> _onSearchProducts(SearchProductsEvent event, Emitter<ProductsState> emit) async {
    try{
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;

        final filteredProducts = _applyFilters(
          products: currentState.products,
          searchQuery: event.query,
          category: currentState.selectedCategory,
          sortOrder: currentState.sortOrder,
        );

        emit(currentState.copyWith(searchQuery: event.query, filteredProducts: filteredProducts));
      }
    }
    catch(e, st){
      _logger.handle(e, st);
      emit(ProductsError(message: e.toString()));
    }
  }

  EventTransformer<T> _debounce<T>() {
    return (events, mapper) => events.debounceTime(const Duration(milliseconds: 400)).switchMap(mapper);
  }

  Future<void> _onFilterByCategory(FilterByCategoryEvent event, Emitter<ProductsState> emit) async {
    try{
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;

        final filteredProducts = _applyFilters(
          products: currentState.products,
          searchQuery: currentState.searchQuery,
          category: event.category,
          sortOrder: currentState.sortOrder,
        );

        emit(currentState.copyWith(selectedCategory: event.category, filteredProducts: filteredProducts));
      }
    }
    catch(e, st){
      _logger.handle(e, st);
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onSortProducts(SortProductsEvent event, Emitter<ProductsState> emit) async {
    try{
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;

        final filteredProducts = _applyFilters(
          products: currentState.products,
          searchQuery: currentState.searchQuery,
          category: currentState.selectedCategory,
          sortOrder: event.sortOrder,
        );

        emit(currentState.copyWith(
          filteredProducts: filteredProducts,
          sortOrder: event.sortOrder,
        ));
      }
    }
    catch(e, st){
      _logger.handle(e, st);
      emit(ProductsError(message: e.toString()));
    }
  }

  List<Product> _applyFilters({
    required List<Product> products,
    required String searchQuery,
    String? category,
    String? sortOrder,
  }){
    final filteredProducts = products.where((p) {
      final matchesCategory = category == null || category.isEmpty || p.category == category;
      final matchesSearch = p.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    _sortList(products: filteredProducts, sortOrder: sortOrder);

    return filteredProducts;
  }

  void _sortList({
    required List<Product> products, String? sortOrder
  }){
    switch (sortOrder) {
      case "asc":
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "desc":
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        products.sort((a, b) => a.id.compareTo(b.id));
    }
  }
}