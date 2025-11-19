import 'package:product_catalogue/src/features/cart/presentation/pages/cart_page.dart';
import 'package:product_catalogue/src/features/products/presentation/pages/product_detail_page.dart';
import 'package:product_catalogue/src/features/products/presentation/pages/product_list_page.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: "/products", page: ProductListRoute.page, initial: true),
    AutoRoute(path: "/products/:id", page: ProductDetailRoute.page),
    AutoRoute(path: "/cart", page: CartRoute.page),
  ];
}