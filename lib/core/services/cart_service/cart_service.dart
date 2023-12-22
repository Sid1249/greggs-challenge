import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:greggs_sausage/core/services/cart_service/models/cart_model.dart';
import 'package:greggs_sausage/core/services/cart_service/models/cart_response_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  late CartItem _cartItem;
  late List<CartItem> _cartItemList;
  List<CartItem> get allCartItems => _cartItemList;
  late List<String> _uuid;
  bool _filterItemFound = false;
  late CartResponseWrapper message;
  static const String _cartKey = "cartItems";

  factory CartService() {
    return _instance;
  }
  CartService._internal() {
    _cartItemList = <CartItem>[];
    _uuid = [];
    loadCartItems();
  }

  void loadCartItems()  {
    final SharedPreferences prefs = GetIt.I<SharedPreferences>();
    final String? cartJson = prefs.getString(_cartKey);
    print('Loading cart items from SharedPreferences'); // Debug print
    if (cartJson != null) {
      print('Found cart items in SharedPreferences'); // Debug print
      List<dynamic> jsonList = json.decode(cartJson);
      _cartItemList = jsonList.map((e) => CartItem.fromJson(e)).toList();
      print('Loaded ${_cartItemList.length} items'); // Debug print
    } else {
      print('No cart items found in SharedPreferences'); // Debug print
    }
  }


  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonList = json.encode(_cartItemList.map((e) => e.toJson()).toList());
    await prefs.setString(_cartKey, jsonList);
  }

  /// This method is called when we have to add [productTemp] into cart
  addToCart(
      {@required dynamic productId,
        @required dynamic unitPrice,
        String? productName,
        int quantity = 1,
        dynamic uniqueCheck,
        dynamic productDetailsObject}) {
    _cartItem = CartItem();
    _setProductValues(productId, unitPrice, productName, quantity, uniqueCheck,
        productDetailsObject);
    if (_cartItemList.isEmpty) {
      _cartItem.subTotal =
          double.parse((quantity * unitPrice).toStringAsFixed(2));
      _uuid.add(_cartItem.uuid);
      _cartItemList.add(_cartItem);

      message = CartResponseWrapper(true, _successMessage, _cartItemList);
      saveCartItems();
      return message;
    } else {
      _cartItemList.forEach((x) {
        if (x.productId == productId) {
          /// If item [UniqueCheck] is not null then we update the item in cart
          if (uniqueCheck != null) {
            if (x.uniqueCheck == uniqueCheck) {
              _filterItemFound = true;
              _updateProductDetails(x, quantity, unitPrice);
              /* message = {
                "status": true,
                "message": _updateMessage,
                "data": _cartItemList,
                "length": _cartItemList.length
              }; */
              message =
                  CartResponseWrapper(true, _updateMessage, _cartItemList);
            }
          }

          /// if uniqueCheck is null then we update the [product] in our cart in against of [PRODUCT ID]
          else {
            _filterItemFound = true;
            _updateProductDetails(x, quantity, unitPrice);
            message = CartResponseWrapper(true, _successMessage, _cartItemList);
          }
        }
      });

      /// if _filterItemFound is [false] then we directly add the product in our cart
      if (!_filterItemFound) {
        _uuid.add(_cartItem.uuid);
        _updateProductDetails(_cartItem, quantity, unitPrice);
        _cartItemList.add(_cartItem);
        message = CartResponseWrapper(true, _successMessage, _cartItemList);
      }
      _filterItemFound = false;
      saveCartItems();
      return message;
    }
  }


  /// This function is used to increment the item quantity into cart
  decrementItemFromCart(String productId) {
    int index = _findItemIndex(productId);

    if (index != -1) {
      if (_cartItemList[index].quantity > 1) {
        _cartItemList[index].quantity--;
        _cartItemList[index].subTotal =
            (_cartItemList[index].quantity * _cartItemList[index].unitPrice);
      } else {
        _cartItemList.removeAt(index);
      }
      saveCartItems();
    }
  }

  incrementItemToCart(String productId) {
    int index = _findItemIndex(productId);

    if (index != -1) {
        _cartItemList[index].quantity++;
        _cartItemList[index].subTotal =
            (_cartItemList[index].quantity * _cartItemList[index].unitPrice);

      saveCartItems();
    }
  }

  deleteItemFromCart(String productId) {
    int index = _findItemIndex(productId);

    if (index != -1) {
      int quantity = _cartItemList[index].quantity;
      for (int i = quantity; i > 0; i--) {
        decrementItemFromCart(productId);
      }
      saveCartItems();
    }
  }

  int _findItemIndex(String productId) {
    for (int index = 0; index < _cartItemList.length; index++) {
      if (_cartItemList[index].productId == productId) {
        return index;
      }
    }
    return -1; // Product not found in cart
  }

  deleteAllCart() {
    _cartItemList = <CartItem>[];
    _uuid = <String>[];
    saveCartItems();
  }

  int? findItemIndexFromCart(cartId) {
    for (int i = 0; i < _cartItemList.length; i++) {
      if (_cartItemList[i].productId == cartId) {
        return i;
      }
    }
    return null;
  }

  CartItem? getSpecificItemFromCart(cartId) {
    for (int i = 0; i < _cartItemList.length; i++) {
      if (_cartItemList[i].productId == cartId) {
        _cartItemList[i].itemCartIndex = i;
        return _cartItemList[i];
      }
    }
    return null;
  }


  /// This method is called when we have to [initialize the values in our cart object]
  void _setProductValues(productId, unitPrice, productName, int quantity,
      uniqueCheck, productDetailsObject) {
    _cartItem.uuid =
        productId.toString() + "-" + DateTime.now().toIso8601String();
    _cartItem.productId = productId;
    _cartItem.unitPrice = unitPrice;
    _cartItem.productName = productName;
    _cartItem.quantity = quantity;
    _cartItem.uniqueCheck = uniqueCheck;
    _cartItem.productDetails = productDetailsObject;
  }

  /// This method is called when we have to update the [product details in  our cart]
  void _updateProductDetails(cartObject, int quantity, dynamic unitPrice) {
    cartObject.quantity = quantity;
    cartObject.subTotal =
        double.parse((quantity * unitPrice).toStringAsFixed(2));
    saveCartItems();
  }

  /// This method is called when we have to get the [cart lenght]
  getCartItemCount() {
    return _cartItemList.length;
  }

  int getRawCartItemCount() {
    int itemCount = 0;
    for (var item in _cartItemList) {
      itemCount += item.quantity;
    }
    return itemCount;
  }


  int getTotalQuantityForSingleItem(String productId) {
    int totalQuantity = 0;
    for (var item in _cartItemList) {
      if (item.productId == productId) {
        totalQuantity += item.quantity;
      }
    }
    return totalQuantity;
  }


  /// This method is called when we have to get the [Total amount]
  getTotalAmount() {
    double totalAmount = 0.0;
    for (var e in _cartItemList) {
      totalAmount += e.subTotal;
    }
    return totalAmount;
  }

  double getTotalAmountForSingleItem(String productId) {
    double totalAmount = 0.0;
    for (var item in _cartItemList) {
      if (item.productId == productId) {
        totalAmount += item.subTotal;
      }
    }
    return totalAmount;
  }


  static const String _successMessage = "Item added to cart successfully.";
  static const String _updateMessage = "Item updated successfully.";
  static const String _removedMessage = "Item removed from cart successfully.";
}