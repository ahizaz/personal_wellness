import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class InventoryController extends GetxController{
   final RxList<Map<String, String>> products = <Map<String, String>>[].obs;
    final RxString searchTerm = ''.obs;
      @override
  void onInit() {

    super.onInit();
    // Populate with static data for now (JSON-like structure)

    
    products.addAll([
      {"image": ImagePath.product2, "title": "Vitamin C Serum \n50mg"},
      {"image": ImagePath.product3, "title": "Whitening night\ncream"},
      {"image": ImagePath.product1, "title": "Essence Sun’s\nCream SPF45"},
      {"image": ImagePath.product4, "title": "The Ordinary Anti-\n aging serum "},
    ]);
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