// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:personal_wellness/core/utils/constants/image_path.dart';

// class ExploreController extends GetxController {
//   final RxList<Map<String, String>> skinConditions = <Map<String, String>>[].obs;
//   final RxList<Map<String, String>> skinTypes = <Map<String, String>>[].obs;
//   final RxList<Map<String, String>> products = <Map<String, String>>[].obs;
//   final RxString searchTerm = ''.obs;
//   final RxMap<String, dynamic> skinDetails = <String, dynamic>{
//     "symptoms": "Consists of pimples, blackheads, and cysts,\n"
//         "often caused by blocked pores, bacteria, and\n"
//         "excess oil production. Hyperpigmentation\nappear as dark spots.",
//     "treatments": [
//       "Use topical treatments with salicylic\nacid or benzoyl peroxide to reduce acne\nbreakouts",
//       "Incorporate gentle exfoliation to\npromote skin cell turnover and fade \ndark spots",
//       "Consider treatments like chemical peels\nor laser therapy for stubborn\nhyperpigmentation"
//     ]
//   }.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     // Populate with static data for now (JSON-like structure)
//     skinConditions.addAll([
//       {"image": "assets/images/skincondition1.png", "title": "Hyperpigmentation"},
//       {"image": "assets/images/skincondition2.png", "title": "Aging graceful skin"},
//       {"image": "assets/images/skincondition3.png", "title": "Acne"},
//       // Future API can add more items here, e.g., up to 5
//       // {"image": "assets/images/skincondition4.png", "title": "Dry Skin"},
//       // {"image": "assets/images/skincondition5.png", "title": "Eczema"},
//     ]);

//     skinTypes.addAll([
//       {"image": "assets/images/skincondtion4.png", "title": "Dry skin"},
//       {"image": "assets/images/skincondtion5.png", "title": "Combination skin"},
//       {"image": "assets/images/skincondtion6.png", "title": "Oily"},
//       // Add more if needed in the future
//     ]);

//     products.addAll([
//       {"image": ImagePath.product2, "title": "Vitamin C Serum \n50mg"},
//       {"image": ImagePath.product3, "title": "Whitening night\ncream"},
//       {"image": ImagePath.product1, "title": "Essence Sun’s\nCream SPF45"},
//       {"image": ImagePath.product4, "title": "The Ordinary Anti-\n aging serum "},
//     ]);
//   }

//   List<Map<String, String>> get sortedSkinConditions {
//     if (searchTerm.value.isEmpty) return skinConditions;
    
//     final String firstWord = searchTerm.value.trim().split(' ').first.toLowerCase();
//     final List<Map<String, String>> matching = [];
//     final List<Map<String, String>> others = [];
    
//     for (var condition in skinConditions) {
//       final String titleFirstWord = condition['title']!.trim().split(' ').first.toLowerCase();
//       if (titleFirstWord.startsWith(firstWord)) {
//         matching.add(condition);
//       } else {
//         others.add(condition);
//       }
//     }
    
//     return [...matching, ...others];
//   }

//   List<Map<String, String>> get sortedSkinTypes {
//     if (searchTerm.value.isEmpty) return skinTypes;
    
//     final String firstWord = searchTerm.value.trim().split(' ').first.toLowerCase();
//     final List<Map<String, String>> matching = [];
//     final List<Map<String, String>> others = [];
    
//     for (var type in skinTypes) {
//       final String titleFirstWord = type['title']!.trim().split(' ').first.toLowerCase();
//       if (titleFirstWord.startsWith(firstWord)) {
//         matching.add(type);
//       } else {
//         others.add(type);
//       }
//     }
    
//     return [...matching, ...others];
//   }

//   List<Map<String, String>> get sortedProducts {
//     if (searchTerm.value.isEmpty) return products;
    
//     final String firstWord = searchTerm.value.trim().split(' ').first.toLowerCase();
//     final List<Map<String, String>> matching = [];
//     final List<Map<String, String>> others = [];
    
//     for (var product in products) {
//       final String titleFirstWord = product['title']!.trim().split(' ').first.toLowerCase();
//       if (titleFirstWord.startsWith(firstWord)) {
//         matching.add(product);
//       } else {
//         others.add(product);
//       }
//     }
    
//     return [...matching, ...others];
//   }

//   // Future method for API integration
//   Future<void> fetchSkinConditionsFromApi() async {
//     // TODO: Implement API call here
//     // Example: final response = await http.get(...);
//     // skinConditions.value = parsedJsonList;
//   }

//   // Future method for skin types API integration
//   Future<void> fetchSkinTypesFromApi() async {
//     // TODO: Implement API call here
//     // Example: final response = await http.get(...);
//     // skinTypes.value = parsedJsonList;
//   }

//   // Future method for products API integration
//   Future<void> fetchProductsFromApi() async {
//     // TODO: Implement API call here
//     // Example: final response = await http.get(...);
//     // products.value = parsedJsonList;
//   }
// }
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class ExploreController extends GetxController {
  final RxList<Map<String, String>> skinConditions = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> skinTypes = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> products = <Map<String, String>>[].obs;
  final RxString searchTerm = ''.obs;
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
    // Populate with static data for now (JSON-like structure)
    skinConditions.addAll([
      {"image": "assets/images/skincondition1.png", "title": "Hyperpigmentation"},
      {"image": "assets/images/skincondition2.png", "title": "Aging graceful skin"},
      {"image": "assets/images/skincondition3.png", "title": "Acne"},
      // Future API can add more items here, e.g., up to 5
      // {"image": "assets/images/skincondition4.png", "title": "Dry Skin"},
      // {"image": "assets/images/skincondition5.png", "title": "Eczema"},
    ]);

    skinTypes.addAll([
      {"image": "assets/images/skincondtion4.png", "title": "Dry skin"},
      {"image": "assets/images/skincondtion5.png", "title": "Combination skin"},
      {"image": "assets/images/skincondtion6.png", "title": "Oily"},
      // Add more if needed in the future
    ]);

    products.addAll([
      {"image": ImagePath.product2, "title": "Vitamin C Serum \n50mg"},
      {"image": ImagePath.product3, "title": "Whitening night\ncream"},
      {"image": ImagePath.product1, "title": "Essence Sun’s\nCream SPF45"},
      {"image": ImagePath.product4, "title": "The Ordinary Anti-\n aging serum "},
    ]);
  }

  List<Map<String, String>> get sortedSkinConditions {
    if (searchTerm.value.isEmpty) return skinConditions;
    
    final String firstWord = searchTerm.value.trim().split(' ').first.toLowerCase();
    final List<Map<String, String>> matching = [];
    final List<Map<String, String>> others = [];
    
    for (var condition in skinConditions) {
      final String titleFirstWord = condition['title']!.trim().split(' ').first.toLowerCase();
      if (titleFirstWord.startsWith(firstWord)) {
        matching.add(condition);
      } else {
        others.add(condition);
      }
    }
    
    return [...matching, ...others];
  }

  List<Map<String, String>> get sortedSkinTypes {
    if (searchTerm.value.isEmpty) return skinTypes;
    
    final String firstWord = searchTerm.value.trim().split(' ').first.toLowerCase();
    final List<Map<String, String>> matching = [];
    final List<Map<String, String>> others = [];
    
    for (var type in skinTypes) {
      final String titleFirstWord = type['title']!.trim().split(' ').first.toLowerCase();
      if (titleFirstWord.startsWith(firstWord)) {
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