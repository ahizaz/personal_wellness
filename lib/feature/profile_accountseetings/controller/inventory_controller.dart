import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryController extends GetxController{
  void applyFilters() {
    isFilterActive.value = selectedBrands.isNotEmpty || selectedCategories.isNotEmpty;
    update(); // To trigger rebuild if needed
  }

  void resetFilters() {
    selectedBrands.clear();
    selectedCategories.clear();
    isFilterActive.value = false;
    update(); // To trigger rebuild if needed
  }
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxString searchTerm = ''.obs;
  final RxList<String> selectedBrands = <String>[].obs;
  final RxList<String> selectedCategories = <String>[].obs;
  final RxBool isFilterActive = false.obs;

  final RxList<String> brands = <String>[].obs;

  final List<String> categories = [
    "Foundation",
    "Mascara",
    "Hair Color",
    "Blush",
    "Anti-Aging Serums",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

Future<void> fetchProducts() async {
  try {
    EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black);

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      EasyLoading.showError("Please login again");
      return;
    }

    final response = await http.get(
      Uri.parse(Urls.getallproduct),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["success"] == true && data["data"] != null) {
        final List<dynamic> result = data["data"]["result"] ?? [];
        products.clear();
        Set<String> uniqueBrands = {};

        for (var item in result) {
          final String productName = item['productName'] ?? '';
          products.add({
            'title': productName,
            'image': List<String>.from(
              (item['image'] ?? []).map((img) => "${Urls.imageurl}$img"),
            ),
          });
          uniqueBrands.add(productName);
        }

        brands.assignAll(uniqueBrands.toList());

        EasyLoading.dismiss();
      } else {
        EasyLoading.showError("Failed to load products");
      }
    } else {
      EasyLoading.showError("Server error: ${response.statusCode}");
    }
  } catch (e) {
    EasyLoading.showError("Error loading products");
    debugPrint("Error fetching products: $e");
  } finally {
    EasyLoading.dismiss();
  }
}

  List<Map<String, dynamic>> get sortedProducts {
    var filtered = products.toList();

    if (selectedBrands.isNotEmpty) {
      filtered = filtered.where((product) => selectedBrands.contains(product['title'])).toList();
    }

    // For categories, since no category data in products, skipping filtering for now.
    // If category is available in API, add it to products map and filter similarly.

    if (searchTerm.value.isNotEmpty) {
      final String firstWord = searchTerm.value.trim().split(' ').first.toLowerCase();
      final List<Map<String, dynamic>> matching = [];
      final List<Map<String, dynamic>> others = [];
      for (var product in filtered) {
        final String titleFirstWord = (product['title'] ?? '').toString().trim().split(' ').first.toLowerCase();
        if (titleFirstWord.startsWith(firstWord)) {
          matching.add(product);
        } else {
          others.add(product);
        }
      }
      return [...matching, ...others];
    }
    return filtered;
  }
}