import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue/src/features/cart/data/repositories/cart_repository.dart';
import 'package:product_catalogue/src/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:product_catalogue/src/features/cart/data/models/cart_item.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        elevation: 0,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final items = state.items;

            if (items.isEmpty){
              return const Center(
                child: Text(
                  "Cart is empty",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold
                  ),
                ),
              );
            }
            final total = state.total;

            return Column(
              children: [
                buildCartTotal(total),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildCartItem(context, item);
                    },
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Product item) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: SizedBox(
          width: 60,
          child: Image.network(
            item.image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) { 
              return const Icon(
                Icons.image_not_supported,
              ); 
            }
          ),
        ),
        title: Text(
          item.title.isEmpty ? "No title" : item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "\$${item.price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<CartBloc>().add(RemoveFromCartEvent(item.id));
          },
        ),
        onTap:() {
          context.router.pushPath("/products/${item.id}");
        },
      ),
    );
  }

  Widget buildCartTotal(double total) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "\$${total.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

}