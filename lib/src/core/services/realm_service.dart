import 'package:product_catalogue/src/features/cart/data/models/cart_item.dart';
import 'package:realm/realm.dart';

class RealmService {
  late final Realm _realm;

  RealmService._internal() {
    final config = Configuration.local([
      CartItem.schema,
    ]);
    _realm = Realm(config);
  }

  static final RealmService _instance = RealmService._internal();
  factory RealmService() => _instance;

  Realm get instance => _realm;

  void close() {
    _realm.close();
  }
}