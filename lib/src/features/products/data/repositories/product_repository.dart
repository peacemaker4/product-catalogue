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
      _logger.info("Products: ${products.length}");
      return products;
    } catch(e, st) {
      _logger.handle(e, st);
      rethrow;
    }
  }

  Future<List<String>> fetchCategories() async {
    try{
      final categories = await api.getCategories();
      _logger.info("Categories: ${categories.length}");
      return categories;
    } catch(e, st) {
      _logger.handle(e, st);
      rethrow;
    }
  }
}