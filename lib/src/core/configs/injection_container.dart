

import 'package:get_it/get_it.dart';
import 'package:product_catalogue/src/core/services/dio_service.dart';
import 'package:product_catalogue/src/features/products/data/datasources/product_api.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';

final getIt = GetIt.I;

void configureDepedencies() {
  getIt.registerSingleton<DioService>(DioService());
  getIt.registerSingleton(ProductApi(getIt<DioService>().instance));
  getIt.registerSingleton(ProductRepository(getIt<ProductApi>()));
}