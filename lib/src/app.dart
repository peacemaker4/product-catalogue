import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';
import 'package:product_catalogue/src/features/products/presentation/bloc/products_bloc.dart';
import 'package:product_catalogue/src/features/products/presentation/pages/product_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductsBloc(repository: GetIt.instance<ProductRepository>())..add(LoadProductsEvent())),
      ],
      child: MaterialApp(
        title: 'Product Catalog',
        home: ProductListPage(),
      )
    );
  }
}
