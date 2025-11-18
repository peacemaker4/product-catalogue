import 'package:product_catalogue/src/core/utils/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';

part 'product_api.g.dart';

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class ProductApi{
  factory ProductApi(Dio dio, {String? baseUrl}) = _ProductApi;

  @GET("/products")
  Future<List<Product>> getProducts();

  @GET("/products/categories")
  Future<List<String>> getCategories();
}