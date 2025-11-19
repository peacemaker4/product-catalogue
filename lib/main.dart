import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_catalogue/src/app.dart';
import 'package:product_catalogue/src/core/configs/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );

  configureDepedencies();

  runApp(const App());
}