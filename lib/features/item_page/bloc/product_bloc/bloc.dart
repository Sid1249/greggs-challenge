import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greggs_sausage/features/item_page/bloc/product_bloc/event.dart';
import 'package:greggs_sausage/features/item_page/bloc/product_bloc/states.dart';
import 'package:greggs_sausage/features/item_page/repository/food_item_repository.dart';
import 'package:greggs_sausage/models/food_item_model.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FoodItemRepository foodItemRepository;

  ProductBloc(this.foodItemRepository) : super(ProductInitialState()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    try {
      final items = await foodItemRepository.fetchFoodItems();
      emit(ProductsLoaded(items));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  FoodItemModel? getProductById(String productId) {
    if (state is ProductsLoaded) {
      return (state as ProductsLoaded).foodItems.firstWhere(
            (item) => item.articleCode == productId,
      );
    }
    return null;
  }
}
