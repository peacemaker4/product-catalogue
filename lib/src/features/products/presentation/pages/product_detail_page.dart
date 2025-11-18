import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';
import 'package:product_catalogue/src/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';

@RoutePage()
class ProductDetailPage extends StatelessWidget {
  final int id;
  const ProductDetailPage({
    super.key, 
    @PathParam("id") required this.id
  });

  @override
  Widget build(BuildContext context) {
    context.read<ProductDetailBloc>().add(LoadProductDetailEvent(id));

    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailLoaded) {
            final product = state.product;
            return buildProductDetail(product);
          } else if (state is ProductDetailError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        }
      )
    );
  }

  Widget buildProductDetail(Product product){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProductImage(product.image),
          buildProductInfo(product),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductImage(String url) {
    return Center(
      child: SizedBox(
        height: 250,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) { 
            return const Icon(
              Icons.image_not_supported,
              size: 64,
            ); 
          }
        ),
      ),
    );
  }

  Widget buildProductInfo(Product product){
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("\$${product.price}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Category: ${product.category}"),
          const SizedBox(height: 16),
          Text(product.description),
        ],
      ),
    );
  }
}
