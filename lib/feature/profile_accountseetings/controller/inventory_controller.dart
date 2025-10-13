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
  }

  void resetFilters() {
    selectedBrands.clear();
    selectedCategories.clear();
    isFilterActive.value = false;
  }
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
    final RxString searchTerm = ''.obs;
    final RxList<String> selectedBrands = <String>[].obs;
    final RxList<String> selectedCategories = <String>[].obs;
    final RxBool isFilterActive = false.obs;

    final List<String> brands = [
      "L'Oréal Paris",
      "Estée Lauder",
      "MAC Cosmetics",
      "Fenty Beauty",
      "Clinique",
      "NARS",
      "The Ordinary",
    ];

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

        for (var item in result) {
          products.add({
            'title': item['productName'] ?? '',
            'image': List<String>.from(
              (item['image'] ?? []).map((img) => "${Urls.imageurl}$img"),
            ),
          });
        }

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

  // Removed duplicate/invalid code

  List<Map<String, dynamic>> get sortedProducts {
    var filtered = products;
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