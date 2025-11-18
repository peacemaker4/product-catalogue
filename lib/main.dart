import 'package:flutter/material.dart';
import 'package:product_catalogue/src/app.dart';
import 'package:product_catalogue/src/core/configs/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configureDepedencies();

  runApp(const App());
}