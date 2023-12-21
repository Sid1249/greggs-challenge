import 'cart_model.dart';

class CartResponseWrapper {
  final bool status;
  final String message;
  List<CartItem> cartItemList;

  CartResponseWrapper(this.status, this.message, this.cartItemList);

}