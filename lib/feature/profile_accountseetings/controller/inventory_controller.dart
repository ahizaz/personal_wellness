
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class InventoryController extends GetxController{
   final RxList<Map<String, String>> products = <Map<String, String>>[].obs;
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
    // Populate with static data for now (JSON-like structure)

    
    products.addAll([
      {"image": ImagePath.product2, "title": "Vitamin C Serum \n50mg", "brand": "Clinique", "category": "Anti-Aging Serums"},
      {"image": ImagePath.product3, "title": "Whitening night\ncream", "brand": "L'Oréal Paris", "category": "Anti-Aging Serums"},
      {"image": ImagePath.product1, "title": "Essence Sun’s\nCream SPF45", "brand": "Estée Lauder", "category": "Foundation"},
      {"image": ImagePath.product4, "title": "The Ordinary Anti-\n aging serum ", "brand": "The Ordinary", "category": "Anti-Aging Serums"},
    ]);
  }

  void applyFilters() {
    isFilterActive.value = selectedBrands.isNotEmpty || selectedCategories.isNotEmpty;
  }

  void resetFilters() {
    selectedBrands.clear();
    selectedCategories.clear();
    isFilterActive.value = false;
  }

   List<Map<String, String>> get sortedProducts {
    var filtered = products.where((p) {
      bool brandMatch = selectedBrands.isEmpty || selectedBrands.contains(p["brand"]);
      bool catMatch = selectedCategories.isEmpty || selectedCategories.contains(p["category"]);
      return brandMatch && catMatch;
    }).toList();

    if (searchTerm.value.isEmpty) return filtered;
    
    final String firstWord = searchTerm.value.trim().split(' ').first.toLowerCase();
    final List<Map<String, String>> matching = [];
    final List<Map<String, String>> others = [];
    
    for (var product in filtered) {
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