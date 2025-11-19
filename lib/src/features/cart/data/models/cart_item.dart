import 'package:realm/realm.dart';

part 'cart_item.realm.dart';

@RealmModel()
class _CartItem {
  @PrimaryKey()
  late int id;
  int quantity = 1;
}