import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/core/services/api_service.dart';
import 'package:personal_wellness/core/models/product_details_model.dart';
import 'package:personal_wellness/core/urls/urls.dart';

class ProductDetailsController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final Rx<ProductDetails?> productDetails = Rx<ProductDetails?>(null);
  final RxBool isLoading = false.obs;

  // Product images from API
  RxList<String> productImages = <String>[].obs;
  
  // Product data from API
  RxString productName = ''.obs;
  RxString ingredients = ''.obs;
  RxString description = ''.obs;
  RxString note = ''.obs;
  RxList<String> howToUse = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Get product ID from arguments if passed
    final productId = Get.arguments as String?;
    if (productId != null && productId.isNotEmpty) {
      fetchProductDetails(productId);
    }
  }

  void nextImage() {
    if (productImages.isNotEmpty) {
      currentIndex.value = (currentIndex.value + 1) % productImages.length;
    }
  }

  void previousImage() {
    if (productImages.isNotEmpty) {
      currentIndex.value = (currentIndex.value - 1 + productImages.length) % productImages.length;
    }
  }

  Future<void> fetchProductDetails(String productId) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading product details...');

      final result = await ApiService.getProductDetails(productId);
      
      if (result != null && result.success) {
        productDetails.value = result.data;
        
        // Update reactive variables
        productName.value = result.data.productName;
        ingredients.value = result.data.ingredients;
        description.value = result.data.description;
        note.value = result.data.note;
        howToUse.assignAll(result.data.howToUse);
        
        // Process images with full URL
        productImages.assignAll(
          result.data.image.map((imagePath) => '${Urls.imageurl}$imagePath').toList()
        );
        
        // Reset current index if images are available
        if (productImages.isNotEmpty) {
          currentIndex.value = 0;
        }
        
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError('Failed to load product details');
      }
    } catch (e) {
      EasyLoading.showError('Error loading product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get full image URL
  String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return '${Urls.imageurl}$imagePath';
  }

  // Method to call API with product ID
  void loadProductDetails(String productId) {
    fetchProductDetails(productId);
  }
}