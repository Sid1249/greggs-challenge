import 'package:greggs_sausage/features/item_page/repository/food_item_repository.dart';
import 'package:greggs_sausage/models/food_item_model.dart';

class FoodItemUseCaseUseCase {
  final FoodItemRepository repository;

  FoodItemUseCaseUseCase(this.repository);

  Future<FoodItemModel> getFoodItems() async {
    return await repository.fetchFoodItems();
  }
}
