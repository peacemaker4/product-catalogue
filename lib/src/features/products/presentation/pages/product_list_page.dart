import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_catalogue/src/core/routes/app_router.dart';
import 'package:product_catalogue/src/features/products/data/models/product.dart';
import 'package:product_catalogue/src/features/products/presentation/bloc/products/products_bloc.dart';

@RoutePage()
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.router.pushPath("/cart");
            },
          )
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            final products = state.filteredProducts ?? state.products;
            return Column(
              children: [
                buildFilterContainer(context),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductsBloc>().add(RefreshProductsEvent());
                    },
                    child: buildProductsGrid(context, products),
                  ),
                ),
              ],
            );
          } else if (state is ProductsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildFilterContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: buildSearchField(context)),
          const SizedBox(width: 8),
          buildCategoryDropdown(context),
          const SizedBox(width: 8),
          buildSortDropdown(context),
        ],
      ),
    );
  }

  Widget buildSearchField(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search products',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (value) {
        context.read<ProductsBloc>().add(SearchProductsEvent(value));
      },
    );
  }

  Widget buildCategoryDropdown(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is! ProductsLoaded) return const SizedBox.shrink();
        final categories = state.categories;
        return DropdownButton<String>(
          hint: const Text('Category'),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Category'),
            ),
            ...categories.map(
              (cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              ),
            ),
          ],
          onChanged: (value) {
            context
                .read<ProductsBloc>()
                .add(FilterByCategoryEvent(value ?? ''));
          },
        );
      },
    );
  }

  Widget buildSortDropdown(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is! ProductsLoaded) return const SizedBox.shrink();

        return DropdownButton<String>(
          hint: const Text('Sort (by price)'),
          value: state.sortOrder,
          items: const [
            DropdownMenuItem(value: "", child: Text('None')),
            DropdownMenuItem(value: "asc", child: Text('Low -> High')),
            DropdownMenuItem(value: "desc", child: Text('High -> Low')),
          ],
          onChanged: (value) {
            context.read<ProductsBloc>().add(SortProductsEvent(value));
          },
        );
      },
    );
  }


  Widget buildProductsGrid(BuildContext context, List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 280,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => buildProductItem(context, products[index]),
    );
  }

  Widget buildProductItem(BuildContext context, Product product) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200,
            child: buildProductImage(product.image),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildProductInfo(product),
          ),
        ],
      ),
      onTap: () {
        context.router.pushPath("/products/${product.id}");
      }
    ); 
  }

  Widget buildProductImage(String url) {
    return Card(
      clipBehavior: Clip.antiAlias,
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
    );
  }

  Widget buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          "\$${product.price}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

}