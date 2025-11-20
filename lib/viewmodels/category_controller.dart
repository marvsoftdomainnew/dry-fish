import 'package:dry_fish/repositories/category_repository.dart';
import 'package:get/get.dart';
import '../models/responses/category_response.dart';
import '../utils/snackbar_util.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository = CategoryRepository();
  var isLoading = false.obs;
  var categoryList = <Category>[].obs;

  Future<void> getCategory() async {
    try {
      isLoading.value = true;
      final response = await _repository.category();
      if (response.status == true) {
        if(response.categories != null &&
            response.categories!.isNotEmpty){
          categoryList.value = response.categories!;
        }
      } else {
        SnackbarUtil.showError(
          "Error",
          response.message ?? "Unknown error",
        );
      }
    } catch (e) {
      SnackbarUtil.showError(
        "Error",
        "Something went wrong while logging out.",
      );
    }finally{
      isLoading.value = false;
    }
  }
}
