import 'package:greggs_sausage/models/food_item_model.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<FoodItemModel> foodItems;

  ProductsLoaded(this.foodItems);
}

class ProductError extends ProductState {
  final String error;

  ProductError(this.error);
}
