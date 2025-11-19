import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue/src/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/features/products/data/repositories/product_repository.dart';
import 'package:product_catalogue/src/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';

@RoutePage()
class ProductDetailPage extends StatefulWidget {
  final int id;
  const ProductDetailPage({
    super.key, 
    @PathParam("id") required this.id
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> 
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late Animation<double> _imageOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _imageAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _imageOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_imageAnimController);
  }

  void _animateImage() {
    _imageAnimController.forward(from: 0);
  }

  @override
  void dispose() {
    _imageAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProductDetailBloc>().add(LoadProductDetailEvent(widget.id));

    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.router.pushPath("/cart");
            },
          )
        ],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailLoaded) {
            final product = state.product;
            return buildProductDetail(context, product);
          } else if (state is ProductDetailError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        }
      )
    );
  }

  Widget buildProductDetail(BuildContext context, Product product){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _imageOpacityAnimation,
            child: Column(
              children: [
                buildProductImage(product.image),
                buildProductInfo(product),
              ],
            ),
          ),
          
          const Spacer(),
          buildAddToCartButton(context, product.id)
        ],
      ),
    );
  }

   Widget buildAddToCartButton(BuildContext context, int productId) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is! CartLoaded) return SizedBox.shrink();
        
        final isInCart = state.items.any((item) => item.id == productId);
        
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: SizedBox(
            key: ValueKey<bool>(isInCart),
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(
                isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                size: 20,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart 
                  ? const Color.fromARGB(255, 151, 151, 151) 
                  : Color.fromARGB(255, 73, 143, 248),
              ),
              onPressed: () {
                if (isInCart) {
                  context.read<CartBloc>().add(RemoveFromCartEvent(productId));
                } else {
                  context.read<CartBloc>().add(AddToCartEvent(productId));
                }
                _animateImage();
              },
              label: Text(isInCart ? 'Remove from Cart' : 'Add to Cart'),
            ),
          ),
        );
      },
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
          Text(
            product.title.isEmpty ? "No title" : product.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 8),
          Text("\$${product.price}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Chip(
            label: Text(product.category.isEmpty ? 'Unknown' : product.category.toUpperCase()),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(color: Colors.black54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                width: 0.5,
                color: Colors.grey
              )
            ),
          ),
          const SizedBox(height: 16),
          Text(product.description.isEmpty ? "No description" : product.description,),
        ],
      ),
    );
  }
}
