import 'package:flutter/material.dart';
import 'package:product_catalogue/src/app.dart';
import 'package:product_catalogue/src/core/services/dio_service.dart';
import 'package:product_catalogue/src/core/services/logger_service.dart';
import 'package:product_catalogue/src/features/products/data/datasources/product_api.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final dio = DioService().instance;
  final api = ProductApi(dio);
  final repository = ProductRepository(api);
  final logger = LoggerService().instance;

  try {
    final products = await repository.fetchProducts();
    final categories = await repository.fetchCategories();

    logger.info(products);
    logger.info(categories);
  } catch (e, st) {
    logger.handle(e, st);
  }

  runApp(const App());
}