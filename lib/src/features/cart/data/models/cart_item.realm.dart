// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class CartItem extends _CartItem
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  CartItem(int id, {int quantity = 1}) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<CartItem>({'quantity': 1});
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'quantity', quantity);
  }

  CartItem._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get quantity => RealmObjectBase.get<int>(this, 'quantity') as int;
  @override
  set quantity(int value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  Stream<RealmObjectChanges<CartItem>> get changes =>
      RealmObjectBase.getChanges<CartItem>(this);

  @override
  Stream<RealmObjectChanges<CartItem>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CartItem>(this, keyPaths);

  @override
  CartItem freeze() => RealmObjectBase.freezeObject<CartItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'quantity': quantity.toEJson(),
    };
  }

  static EJsonValue _toEJson(CartItem value) => value.toEJson();
  static CartItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id} => CartItem(
        fromEJson(id),
        quantity: fromEJson(ejson['quantity'], defaultValue: 1),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CartItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, CartItem, 'CartItem', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('quantity', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
