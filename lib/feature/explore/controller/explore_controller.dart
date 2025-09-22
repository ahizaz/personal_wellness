import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ExploreController extends GetxController {
  final RxList<Map<String, dynamic>> skinConditions = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> skinTypes = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> products = <Map<String, String>>[].obs;
  final RxList<Map<String, dynamic>> recommendedProducts = <Map<String, dynamic>>[].obs;
  final RxString currentSkinId = ''.obs;
  final RxString searchTerm = ''.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> skinDetails = <String, dynamic>{
    "symptoms": "Consists of pimples, blackheads, and cysts,\n"
        "often caused by blocked pores, bacteria, and\n"
        "excess oil production. Hyperpigmentation\nappear as dark spots.",
    "treatments": [
      "Use topical treatments with salicylic\nacid or benzoyl peroxide to reduce acne\nbreakouts",
      "Incorporate gentle exfoliation to\npromote skin cell turnover and fade \ndark spots",
      "Consider treatments like chemical peels\nor laser therapy for stubborn\nhyperpigmentation"
    ]
  }.obs;
  @override
  void onInit() {
    super.onInit();
    fetchSkinData();
    fetchProducts();
  }
  
  Future<void> fetchProducts() async {
    try {
      EasyLoading.show(status: "Loading products...", maskType: EasyLoadingMaskType.black);

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
        final data = jsonDecode(response.body);

        if (data["success"] == true && data["data"]["result"] != null) {
          products.clear();

          for (var item in data["data"]["result"]) {
            // Save product id to shared preferences
            prefs.setString('lastProductId', item["_id"] ?? "");

            products.add({
              "id": item["_id"] ?? "",
              "title": item["productName"] ?? "Unknown Product",
              "image": (item["image"] != null && item["image"].isNotEmpty)
                  ? "${Urls.imageurl}${item["image"][0]}"
                  : "",
            });
          }

          EasyLoading.showSuccess("Products loaded");
        } else {
          EasyLoading.showError("Failed to load products");
        }
      } else {
        EasyLoading.showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      EasyLoading.showError("Error loading products");
      print("Error fetching products: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> fetchRecommendedProducts(String id) async {
    try {
      EasyLoading.show(status: "Loading recommended products...", maskType: EasyLoadingMaskType.black);

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        EasyLoading.showError("Please login again");
        return;
      }

      final response = await http.get(
        Uri.parse("${Urls.baseUrl}/product/get-recommended/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true && data["data"]["result"] != null) {
          recommendedProducts.clear();

          for (var item in data["data"]["result"]) {
            recommendedProducts.add({
              "id": item["_id"] ?? "",
              "title": item["productName"] ?? "Unknown Product",
              "image": item["image"].isNotEmpty
                  ? "${Urls.imageurl}${item["image"][0]}"
                  : "",
            });
          }

          EasyLoading.showSuccess("Recommended products loaded");
        } else {
          EasyLoading.showError("Failed to load recommended products");
        }
      } else {
        EasyLoading.showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      EasyLoading.showError("Error loading recommended products");
      print("Error fetching recommended products: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }


  Future<Map<String, dynamic>?> fetchSkinConditionDetails(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      
      if (accessToken == null) {
        print('No access token found');
        return null;
      }

      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/skin-condition/details/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      } else {
        print('Failed to fetch skin condition details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching skin condition details: $e');
    }
    return null;
  }

  Future<void> fetchSkinData() async {
    try {
      isLoading.value = true;
      EasyLoading.show(
        status: 'Loading skin data...',
        maskType: EasyLoadingMaskType.black,
      );
      
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      
      if (accessToken == null) {
        print('No access token found');
        EasyLoading.showError('Please login again');
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.getallskinconditon),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['data']['result'] != null) {
          skinConditions.clear();
          skinTypes.clear();
          
          for (var item in data['data']['result']) {
            final skinData = {
              'id': item['_id'],
              'image': '${Urls.imageurl}${item['image']}',
              'title': item['skinType'],
              'symptoms': item['symptmos'],
              'treatment': item['treatment'],
            };
            
            skinConditions.add(skinData);
            skinTypes.add(skinData);
          }
          
          print('Loaded ${skinConditions.length} skin items from API');
          EasyLoading.showSuccess('Skin data loaded successfully!');
        } else {
          EasyLoading.showError('Failed to load skin data');
        }
      } else if (response.statusCode == 401) {
        EasyLoading.showError('Session expired. Please login again');
      } else {
        print('Failed to fetch skin data: ${response.statusCode}');
        EasyLoading.showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching skin data: $e');
      EasyLoading.showError('Network error. Please check your connection');
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get sortedSkinConditions {
    if (isLoading.value || skinConditions.isEmpty) {
      return searchTerm.value.isEmpty ? skinConditions : [];
    }
    
    if (searchTerm.value.isEmpty) return skinConditions;
    
    final String searchQuery = searchTerm.value.trim().toLowerCase();
    final List<Map<String, dynamic>> matching = [];
    final List<Map<String, dynamic>> others = [];
    
    for (var condition in skinConditions) {
      final String title = condition['title']?.toString().toLowerCase() ?? '';
      final String symptoms = condition['symptoms']?.toString().toLowerCase() ?? '';
      if (title.contains(searchQuery) || symptoms.contains(searchQuery)) {
        matching.add(condition);
      } else {
        others.add(condition);
      }
    }
    
    return [...matching, ...others];
  }

  List<Map<String, dynamic>> get sortedSkinTypes {
    if (isLoading.value || skinTypes.isEmpty) {
      return searchTerm.value.isEmpty ? skinTypes : [];
    }
    if (searchTerm.value.isEmpty) return skinTypes;
    final String searchQuery = searchTerm.value.trim().toLowerCase();
    final List<Map<String, dynamic>> matching = [];
    final List<Map<String, dynamic>> others = [];
    for (var type in skinTypes) {
      final String title = type['title']?.toString().toLowerCase() ?? '';
      final String symptoms = type['symptoms']?.toString().toLowerCase() ?? '';
      if (title.contains(searchQuery) || symptoms.contains(searchQuery)) {
        matching.add(type);
      } else {
        others.add(type);
      }
    }
    return [...matching, ...others];
  }

  List<Map<String, String>> get sortedProducts {
    if (searchTerm.value.isEmpty) return products;
    final String firstWord = searchTerm.value.trim().split(' ').first.toLowerCase();
    final List<Map<String, String>> matching = [];
    final List<Map<String, String>> others = [];
    for (var product in products) {
      final String titleFirstWord = product['title']!.trim().split(' ').first.toLowerCase();
      if (titleFirstWord.startsWith(firstWord)) {
        matching.add(product);
      } else {
        others.add(product);
      }
    }
    return [...matching, ...others];
  }
}