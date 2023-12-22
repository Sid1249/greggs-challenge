abstract class CartEvent {}

class AddProductToCart extends CartEvent {
  final dynamic productId;
  final dynamic unitPrice;
  final String? productName;
  final int quantity;
  final dynamic uniqueCheck;
  final dynamic productDetailsObject;

  AddProductToCart({
    required this.productId,
    required this.unitPrice,
    this.productName,
    this.quantity = 1,
    this.uniqueCheck,
    this.productDetailsObject,
  });
}

class IncrementQuantity extends CartEvent {
  final String productID;

  IncrementQuantity(this.productID);
}

class DecrementQuantity extends CartEvent {
  final String productID;

  DecrementQuantity(this.productID);
}

class RemoveProductFromCart extends CartEvent {
  final String productID;

  RemoveProductFromCart(this.productID);
}

class RefreshCart extends CartEvent {}

class ClearCart extends CartEvent {}
