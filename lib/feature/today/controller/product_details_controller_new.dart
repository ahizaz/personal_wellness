import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/urls/urls.dart';

class ProductDetailsController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool isLoading = false.obs;

  // Product details
  RxList<String> productImages = <String>[].obs;
  RxString productName = ''.obs;
  RxString ingredients = ''.obs;
  RxList<String> howToUse = <String>[].obs;

  // New: Relevant product list
  RxList<Map<String, dynamic>> relevantProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final productId = Get.arguments as String?;
    if (productId != null && productId.isNotEmpty) {
      fetchProductDetails(productId);
    }
  }

  Future<void> fetchProductDetails(String productId) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading product details...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/product/details/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['data'];

        productName.value = result['productName'] ?? '';
        ingredients.value = result['ingredients'] ?? '';
        howToUse.assignAll(List<String>.from(result['howToUse'] ?? []));
        // Handle images - check if image exists and is a list
        if (result['image'] != null && result['image'] is List) {
          final imageList = result['image'] as List;
          if (imageList.isNotEmpty) {
            productImages.assignAll(
              imageList.map((e) => '${Urls.imageurl}$e').toList(),
            );
          } else {
            productImages.clear();
          }
        } else {
          productImages.clear();
        }

        // Fetch relevant products after loading this one
        await fetchRelevantProducts(ingredients.value);

        EasyLoading.dismiss();
      } else {
        EasyLoading.showError('Failed to load product details');
      }
    } catch (e) {
      EasyLoading.showError('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRelevantProducts(String searchTerm) async {
    try {
      EasyLoading.show(status: 'Loading relevant products...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/product/get-relevant?searchTerm=$searchTerm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data']['result'] as List;
        relevantProducts.assignAll(results.map((e) => {
          'productName': e['productName'],
          'image': e['image'][0],
        }).toList());
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError('Failed to load relevant products');
      }
    } catch (e) {
      EasyLoading.showError('Error loading relevant products: $e');
    }
  }

  void nextImage() {
    if (productImages.isNotEmpty) {
      currentIndex.value = (currentIndex.value + 1) % productImages.length;
    }
  }
}
