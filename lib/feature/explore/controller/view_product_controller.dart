
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ViewProductController extends GetxController{
    final RxInt currentIndex = 0.obs;
      final List<String> imagePath = [
    "assets/images/produt_details_1.png",
    "assets/images/product_details_2.png",
    "assets/images/product_details_3.png",
  ];
   void nextImage() {
    currentIndex.value = (currentIndex.value + 1) % imagePath.length;
  }
  void prevImage() {
  currentIndex.value = (currentIndex.value - 1 + imagePath.length) % imagePath.length;
}
  final RxMap<String, dynamic> productDataview = {
    "productName": "Essence Sun’s Cream SPF45",
    "ingredients": "Consists of pimples, blackheads, and cysts,\noften caused by blocked pores, bacteria, and\nexcess oil production. Hyperpigmentation\nappear as dark spots ",
  }.obs;
    final RxList<String> howToUseIt = [
    "Apply generously 15–20 minutes before sun exposure to allow proper absorption and maximum protection.",
    "Use as the final step in your morning skincare routine, after moisturizer and any treatment products.",
    "Reapply every 2 hours, especially after sweating, swimming, or towel drying.",
    "Use daily, even on cloudy days, to help prevent sun damage and reduce the risk of hyperpigmentation and premature aging",
  ].obs;



}