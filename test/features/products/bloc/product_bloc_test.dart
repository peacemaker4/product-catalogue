import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/features/products/presentation/bloc/products/products_bloc.dart';

import '../mocks/mock_product_repository.dart';

void main() {
  late MockProductRepository repository;
  late List<Product> mockProducts;

  setUp(() {
    repository = MockProductRepository();

    mockProducts = [
      Product(id: 1, title: "Laptop", description: "Description", price: 500.0, category: "electronics", image: ""),
      Product(id: 2, title: "T-Shirt", description: "Description", price: 25.5, category: "men's clothing", image: ""),
      Product(id: 3, title: "Ring", description: "Description", price: 100.0, category: "jewelery", image: ""),
    ];

    when(() => repository.fetchProducts()).thenAnswer((_) async => mockProducts);
    when(() => repository.fetchCategories()).thenAnswer((_) async => ["electronics", "men's clothing", "jewelery"]);
  });

  //Load Products
  blocTest<ProductsBloc, ProductsState>(
    "products loaded",
    build: () => ProductsBloc(repository: repository),
    act: (bloc) => bloc.add(LoadProductsEvent()),
    expect: () => [
      isA<ProductsLoading>(),
      isA<ProductsLoaded>()
        .having((s) => s.products.length, "products count", 3)
        .having((s) => s.categories.length, "categories count", 3),
    ],
  );

  //Search Products
  blocTest<ProductsBloc, ProductsState>(
    "filters by search query",
    build: () => ProductsBloc(repository: repository),
    act: (bloc) async {
      bloc.add(LoadProductsEvent());
      await Future.delayed(Duration.zero);
      bloc.add(SearchProductsEvent("lap"));
    },
    expect: () => [
      isA<ProductsLoading>(),
      isA<ProductsLoaded>(),
      isA<ProductsLoaded>().having(
        (s) => s.filteredProducts?.map((e) => e.title).toList(),
        "products search",
        ["Laptop"],
      ),
    ],
  );

  //Category filter
  blocTest<ProductsBloc, ProductsState>(
    "filter by category",
    build: () => ProductsBloc(repository: repository),
    act: (bloc) async {
      bloc.add(LoadProductsEvent());
      await Future.delayed(Duration.zero);
      bloc.add(FilterByCategoryEvent("electronics"));
    },
    expect: () => [
      isA<ProductsLoading>(),
      isA<ProductsLoaded>(),
      isA<ProductsLoaded>().having(
        (s) => s.filteredProducts?.length,
        "filtered by category",
        1,
      ),
    ],
  );

  //Sorting
  blocTest<ProductsBloc, ProductsState>(
    "sort by price ascending",
    build: () => ProductsBloc(repository: repository),
    act: (bloc) async {
      bloc.add(LoadProductsEvent());
      await Future.delayed(Duration.zero);
      bloc.add(SortProductsEvent("asc"));
    },
    expect: () => [
      isA<ProductsLoading>(),
      isA<ProductsLoaded>(),
      isA<ProductsLoaded>().having(
        (s) => s.filteredProducts?.map((p) => p.price).toList(),
        "sorted ascending",
        [25.5, 100.0, 500.0],
      ),
    ],
  );
}
