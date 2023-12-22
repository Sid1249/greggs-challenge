import 'package:greggs_sausage/core/services/cart_service/models/cart_model.dart';

abstract class CartState {}

class CartStateInitial extends CartState {}


class CartUpdated extends CartState {
  final List<CartItem> cartItems;
  final double totalAmount;

  CartUpdated(this.cartItems, this.totalAmount);
}

class CartRefreshed extends CartState {}

class CartErrorState extends CartState {
  final String message;

  CartErrorState(this.message);
}
