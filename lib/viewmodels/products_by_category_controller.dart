import 'package:chavan_brothers/repositories/products_by_category_repository.dart';
import 'package:get/get.dart';
import '../models/responses/products_by_category_response.dart' hide Category;
import 'category_controller.dart';

class ProductsByCategoryController extends GetxController {
  final ProductsByCategoryRepository _productsByCategoryRepository =
      ProductsByCategoryRepository();
  final CategoryController categoryController = Get.find<CategoryController>();

  var selectedCategoryIndex = 0.obs;
  var products = <Product>[].obs;
  var isLoadingProducts = false.obs;

  @override
  void onInit() {
    super.onInit();
    // When categories are loaded, fetch products for selected category
    ever(categoryController.categoryList, (_) {
      if (categoryController.categoryList.isNotEmpty) {
        fetchProductsForSelectedCategory();
      }
    });
  }

  void setInitialCategory(int categoryId) {
    final index = categoryController.categoryList.indexWhere(
      (c) => c.id == categoryId,
    );
    if (index != -1) selectedCategoryIndex.value = index;
    fetchProductsForSelectedCategory();
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    fetchProductsForSelectedCategory();
  }

  Future<void> fetchProductsForSelectedCategory() async {
    if (categoryController.categoryList.isEmpty) return;

    try {
      isLoadingProducts.value = true;
      final selectedCategory =
          categoryController.categoryList[selectedCategoryIndex.value];
      final response = await _productsByCategoryRepository.productByCategory(
        selectedCategory.id!,
      );
      if (response.success == true && response.products != null) {
        products.value = response.products!;
      } else {
        products.clear();
      }
    } catch (e) {
      print("Error fetching products: $e");
      products.clear();
    } finally {
      isLoadingProducts.value = false;
    }
  }
}
