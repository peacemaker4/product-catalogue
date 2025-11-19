import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:product_catalogue/src/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';

import '../mocks/mock_cart_repository.dart';

void main() {
  late MockCartRepository mockRepo;

  final mockProducts = [
    Product(id: 1, title: "Laptop", description: "Description", price: 500.0, category: "electronics", image: ""),
    Product(id: 2, title: "T-Shirt", description: "Description", price: 25.5, category: "men's clothing", image: ""),
    Product(id: 3, title: "Ring", description: "Description", price: 100.0, category: "jewelery", image: ""),
  ];

  setUp(() {
    mockRepo = MockCartRepository();
  });

  setUpAll(() {
    registerFallbackValue(Product(
      id: 0,
      title: "",
      price: 0,
      description: "",
      category: "",
      image: "",
    ));
  });

  group("CartBloc Tests", () {
    //LoadCartEvent
    blocTest<CartBloc, CartState>(
      "check cart is loaded",
      build: () {
        when(() => mockRepo.getFullCart()).thenAnswer((_) async => mockProducts);
        return CartBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(LoadCartEvent()),
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.items.length, "cart count", 3)
            .having((s) => s.total, "total", 625.5),
      ],
    );

    //AddToCartEvent
    blocTest<CartBloc, CartState>(
      "check addToCart",
      build: () {
        when(() => mockRepo.addToCart(1)).thenReturn(null);
        when(() => mockRepo.getFullCart()).thenAnswer((_) async => mockProducts);
        return CartBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(AddToCartEvent(1)),
      verify: (_) {
        verify(() => mockRepo.addToCart(1)).called(1);
        verify(() => mockRepo.getFullCart()).called(1);
      },
    );

    //RemoveFromCartEvent
    blocTest<CartBloc, CartState>(
      "check removeFromCart",
      build: () {
        when(() => mockRepo.removeFromCart(1)).thenReturn(null);
        when(() => mockRepo.getFullCart()).thenAnswer((_) async => mockProducts);
        return CartBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(RemoveFromCartEvent(1)),
      verify: (_) {
        verify(() => mockRepo.removeFromCart(1)).called(1);
        verify(() => mockRepo.getFullCart()).called(1);
      },
    );
  });
}
