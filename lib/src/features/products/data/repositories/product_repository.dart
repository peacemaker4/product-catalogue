import 'package:product_catalogue/src/core/services/logger_service.dart';
import 'package:product_catalogue/src/features/products/data/datasources/product_api.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';

class ProductRepository {
  final ProductApi api;
  final _logger = LoggerService().instance;

  ProductRepository(this.api);

  Future<List<Product>> fetchProducts() async {
    try{
      final products = await api.getProducts();
      return products;
    } catch(e, st) {
      _logger.handle(e, st);
      rethrow;
    }
  }

  Future<List<String>> fetchCategories() async {
    try{
      final categories = await api.getCategories();
      return categories;
    } catch(e, st) {
      _logger.handle(e, st);
      rethrow;
    }
  }

  Future<Product> fetchProductById(int id) async {
    try{
      final products = await fetchProducts();
      return products.firstWhere((p) => p.id == id);
    } catch(e, st) {
      _logger.handle(e, st);
      rethrow;
    }
  }
}