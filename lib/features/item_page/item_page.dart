import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greggs_sausage/core/bloc/cart_bloc/bloc.dart';
import 'package:greggs_sausage/core/bloc/cart_bloc/events.dart';
import 'package:greggs_sausage/core/bloc/cart_bloc/states.dart';
import 'package:greggs_sausage/core/services/cart_service/cart_service.dart';
import 'package:greggs_sausage/core/widgets/add_to_cart_button.dart';
import 'package:greggs_sausage/core/widgets/cart_bottom_bar.dart';
import 'package:greggs_sausage/features/item_page/bloc/product_bloc/bloc.dart';
import 'package:greggs_sausage/features/item_page/bloc/product_bloc/event.dart';
import 'package:greggs_sausage/features/item_page/bloc/product_bloc/states.dart';
import 'package:greggs_sausage/models/food_item_model.dart';
import 'package:greggs_sausage/routes/routes.gr.dart';

@RoutePage<String>()
class ItemPage extends StatelessWidget {
  ItemPage({super.key});
  final ValueNotifier<bool> _isProductsLoaded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final CartService cartService = CartService();

    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitialState) {
            context.read<ProductBloc>().add(LoadProducts());
            return Center(
              child: Image.asset('assets/images/loading_gif.gif'),
            );
          } else if (state is ProductsLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _isProductsLoaded.value = true;
            });
            final sausageRoll = state.foodItems.first;
            return _buildSausageRollView(context, sausageRoll);
          } else if (state is ProductError) {
            return Text('Error: ${state.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: _isProductsLoaded,
        builder: (context, isLoaded, child) {
          if (!isLoaded) return const SizedBox.shrink();

          return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            if (cartService.getRawCartItemCount() > 0) {
              return CartBottomBar(
                  numCartItems: cartService.getRawCartItemCount(),
                  onViewCartPressed: () {
                    context.router.push(const CartPageRoute());
                  }
              );
            } else {
              return const SizedBox.shrink();
            }
          });
        },
      ),
    );
  }

  Widget _buildSausageRollView(
      BuildContext context, FoodItemModel sausageRoll) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 55,
          ),
          Image.asset(
            'assets/images/greggs_horizontal.jpeg',
            scale: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    child: Hero(
                      tag: 'roll',
                      child: CachedNetworkImage(
                        imageUrl: sausageRoll.imageUri,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sausageRoll.articleName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price: \$${sausageRoll.eatOutPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            AddToCartButton(
                              onIncrement: () {

                                if (context
                                        .read<CartBloc>()
                                        .cartService
                                        .getTotalQuantityForSingleItem(
                                            sausageRoll.articleCode) !=
                                    0) {
                                  context.read<CartBloc>().add(
                                      IncrementQuantity(
                                          sausageRoll.articleCode));
                                } else {
                                  context.read<CartBloc>().add(
                                        AddProductToCart(
                                            productId: sausageRoll.articleCode,
                                            unitPrice: sausageRoll.eatOutPrice,
                                            productName:
                                                sausageRoll.articleName,
                                            quantity: context
                                                    .read<CartBloc>()
                                                    .cartService
                                                    .getTotalQuantityForSingleItem(
                                                        sausageRoll
                                                            .articleCode) +
                                                1),
                                      );
                                }
                              },
                              onDecrement: () {
                                context.read<CartBloc>().add(
                                      DecrementQuantity(
                                          sausageRoll.articleCode),
                                    );
                              },
                              itemCount: context
                                  .watch<CartBloc>()
                                  .cartService
                                  .getRawCartItemCount(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          sausageRoll.customerDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
