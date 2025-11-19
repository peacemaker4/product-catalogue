import 'package:product_catalogue/src/core/services/logger_service.dart';
import 'package:product_catalogue/src/features/cart/data/models/cart_item.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';
import 'package:realm/realm.dart';

class CartRepository {
  final Realm realm;
  final ProductRepository productRepository;
  final _logger = LoggerService().instance;

  CartRepository({required this.realm, required this.productRepository});

  List<CartItem> getCartItems() {
    return realm.all<CartItem>().toList();
  }

  Future<Product?> getProduct(int productId) async {
    try {
      return await productRepository.fetchProductById(productId);
    } catch (e, st) {
      _logger.handle(e, st);
      return null;
    }
  }

  void addToCart(int productId) {
    realm.write(() {
      final existing = realm.find<CartItem>(productId);
      if (existing != null) {
        existing.quantity += 1;
      } else {
        realm.add(CartItem(productId, quantity: 1));
      }
    });
  }

  void removeFromCart(int productId) {
    realm.write(() {
      final existing = realm.find<CartItem>(productId);
      if (existing != null) realm.delete(existing);
    });
  }
  
  Future<List<Product>> getFullCart() async {
    try{
      final List<Product> result = [];

      for (final item in realm.all<CartItem>()) {
        final product = await productRepository.fetchProductById(item.id);
        result.add(product);
      }

      return result;
    }
    catch(e, st){
      _logger.handle(e, st);
      rethrow;
    }
    
  }
}