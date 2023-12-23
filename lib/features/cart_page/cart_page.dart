import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greggs_sausage/core/bloc/cart_bloc/bloc.dart';
import 'package:greggs_sausage/core/bloc/cart_bloc/events.dart';
import 'package:greggs_sausage/core/services/cart_service/models/cart_model.dart';
import 'package:greggs_sausage/features/item_page/bloc/product_bloc/bloc.dart';
import 'package:greggs_sausage/models/food_item_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

@RoutePage<String>()
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = context.watch<CartBloc>();
    final ProductBloc productBloc = context.read<ProductBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      body: cartBloc
              .cartService.allCartItems.isEmpty // Check if the cart is empty
          ? _buildEmptyCartView(context) // Display empty cart view
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartBloc.cartService.allCartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartBloc.cartService.allCartItems[index];
                      final product =
                          productBloc.getProductById(cartItem.productId);

                      return _buildCartItem(
                          cartItem, product, context, cartBloc);
                    },
                  ),
                ),
                _buildTotalSection(context,cartBloc),
                _buildCheckoutButton(context),
              ],
            ),
    );
  }

  Widget _buildCartItem(CartItem cartItem, FoodItemModel? product,
      BuildContext context, CartBloc cartBloc) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if(product?.imageUri != null)
            Hero(
              tag: 'roll',
              child: CachedNetworkImage(
                imageUrl: product!.imageUri,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 75,
              ),
            )
            else
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.fastfood_rounded,color: Theme.of(context).colorScheme.secondaryContainer,),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product?.articleName ?? 'Product Name',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                      '\$${cartBloc.cartService.getTotalAmountForSingleItem(product!.articleCode).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500,color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
            _buildQuantityAdjustButtons(cartItem, cartBloc),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityAdjustButtons(CartItem cartItem, CartBloc cartBloc) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove, color: Colors.red),
          onPressed: () => cartBloc.add(DecrementQuantity(cartItem.productId)),
        ),
        Text(cartItem.quantity.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          onPressed: () => cartBloc.add(IncrementQuantity(cartItem.productId)),
        ),
      ],
    );
  }

  Widget _buildTotalSection(BuildContext context,CartBloc cartBloc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              'Total: \$${cartBloc.cartService.getTotalAmount().toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          ElevatedButton(
              onPressed: () {
                _showThanksGivingBottomSheet(context);
              },
              child: const Text('Apply Coupon')),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => _showThanksGivingBottomSheet(context),
        child: const Text('Checkout'),
      ),
    );
  }

  void _showThanksGivingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Thank you for trying out this app!",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  "Glad you tried this, I tried to deliver this challenge in the shortest time possible but there are many improvements I could still consider.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 15),
                Text(
                  "Further enhancements could include:",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "- Theme Management (better use of colors and text themes)\n- Advanced cart management using SQLite or Hive\n- Strings internationalization\n",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                Text(
                  "Interested Roles:",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text("Flutter Engineer, Associate Product Manager",
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: Text(
                    "View My Resume",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () {
                    _openResume();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyCartView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 100, color: Theme.of(context).colorScheme.onSurface),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _openResume() async {
    final ByteData data = await rootBundle.load('assets/resume.pdf');
    final Uint8List bytes = data.buffer.asUint8List();

    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/resume.pdf');

    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open(file.path);
  }
}
