import 'package:dio/dio.dart';

class DioService {
  late final Dio _dio;

  DioService._internal(){
    _dio = Dio();
  }

  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;

  Dio get instance => _dio;
}