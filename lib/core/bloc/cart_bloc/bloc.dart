import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greggs_sausage/core/bloc/cart_bloc/events.dart';
import 'package:greggs_sausage/core/bloc/cart_bloc/states.dart';
import 'package:greggs_sausage/core/services/cart_service/cart_service.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService cartService;

  CartBloc(this.cartService) : super(CartStateInitial()) {
    on<AddProductToCart>(_onAddProductToCart);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
    on<ClearCart>(_onClearCart);
    on<RefreshCart>(_onRefreshCart);

  }

  void _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) {
    cartService.addToCart(
      productId: event.productId,
      unitPrice: event.unitPrice,
      productName: event.productName,
      quantity: event.quantity,
      uniqueCheck: event.uniqueCheck,
      productDetailsObject: event.productDetailsObject,
    );
    emit(CartUpdated(cartService.allCartItems, cartService.getTotalAmount()));
  }

  FutureOr<void> _onClearCart(ClearCart event, Emitter<CartState> emit) {
    cartService.deleteAllCart();
    emit(CartUpdated(cartService.allCartItems, cartService.getTotalAmount()));
  }

  void _onIncrementQuantity(IncrementQuantity event, Emitter<CartState> emit) {
    cartService.incrementItemToCart(event.productID);
    emit(CartUpdated(cartService.allCartItems, cartService.getTotalAmount()));
  }

  void _onDecrementQuantity(DecrementQuantity event, Emitter<CartState> emit) {
     cartService.decrementItemFromCart(event.productID);
      emit(CartUpdated(cartService.allCartItems, cartService.getTotalAmount()));
  }

  void _onRefreshCart(RefreshCart event, Emitter<CartState> emit) {
    emit(CartRefreshed());
  }
}

