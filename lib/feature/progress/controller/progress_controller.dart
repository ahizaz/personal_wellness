import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class ProgressController extends GetxController{
  var progressItems = <Map<String,dynamic>>[].obs;
   var janData = <FlSpot>[].obs;
  var febData = <FlSpot>[].obs;
  var showAll = false.obs;
  
  // Store captured progress images
  var leftProgressImages = <String>[].obs;  // Left side images
  var rightProgressImages = <String>[].obs; // Right side images  
  var frontProgressImages = <String>[].obs; // Front images
  @override
  void onInit() {
   
    super.onInit();
    loadData();
    loadGraphData();
  }
  void loadData(){
    progressItems.value=[
     {
        'title':'Day 1 Starting point',
         'date':'15 Jan,2025',
         'week': 'Week 1',
         'image':"assets/icons/progresshistory.png",
     },
       {
        'title':'Week 2 Progress',
         'date':'29 Jan, 2025',
         'week': 'Week 2',
         'image':"assets/icons/progresshistory.png",
     },
       {
        'title':'Month 1 Milestone',
         'date':'15 Feb, 2025',
         'week': 'Week 4',
         'image':"assets/icons/progresshistory.png",
     },
    ];
  }
      void loadGraphData() {
     janData.value = [
       FlSpot(0, 3),
       FlSpot(1, 4),
       FlSpot(2, 2),
       FlSpot(3, 5),
       FlSpot(4, 3.5),
       FlSpot(5, 4.5),
       FlSpot(6, 3.8),
       FlSpot(7, 4.2),
       FlSpot(8, 3.9),
       FlSpot(9, 4.7),
       FlSpot(10, 3.6),
       FlSpot(11, 4.1),
     ];

     febData.value = [
       FlSpot(0, 2.5),
       FlSpot(1, 3.5),
       FlSpot(2, 4.5),
       FlSpot(3, 3),
       FlSpot(4, 4.8),
       FlSpot(5, 3.8),
       FlSpot(6, 4.3),
       FlSpot(7, 3.7),
       FlSpot(8, 4.6),
       FlSpot(9, 3.4),
       FlSpot(10, 4.9),
       FlSpot(11, 3.2),
     ];
   }
  void toggleShowAll(){
    showAll.value = !showAll.value;
  }
  
  // Method to save captured progress images from GoPicture
  void saveCapturedImages(List<String> imagePaths) {
    if (imagePaths.length >= 3) {
      // Add new images to the beginning (first position) of each list
      leftProgressImages.insert(0, imagePaths[0]);   // Left image first
      rightProgressImages.insert(0, imagePaths[1]);  // Right image first  
      frontProgressImages.insert(0, imagePaths[2]);  // Front image first
      
      print('Progress images saved:');
      print('Left: ${imagePaths[0]}');
      print('Right: ${imagePaths[1]}');
      print('Front: ${imagePaths[2]}');
      
      // Keep only last 5 images for each angle to avoid memory issues
      if (leftProgressImages.length > 5) leftProgressImages.removeLast();
      if (rightProgressImages.length > 5) rightProgressImages.removeLast();
      if (frontProgressImages.length > 5) frontProgressImages.removeLast();
    }
  }
  
  // Method to get the first (latest) image for each angle
  String? getLatestLeftImage() => leftProgressImages.isEmpty ? null : leftProgressImages.first;
  String? getLatestRightImage() => rightProgressImages.isEmpty ? null : rightProgressImages.first;
  String? getLatestFrontImage() => frontProgressImages.isEmpty ? null : frontProgressImages.first;
  
  // Methods to get images by index for displaying in different positions
  String? getLeftImageAtIndex(int index) {
    return index < leftProgressImages.length ? leftProgressImages[index] : null;
  }
  
  String? getRightImageAtIndex(int index) {
    return index < rightProgressImages.length ? rightProgressImages[index] : null;
  }
  
  String? getFrontImageAtIndex(int index) {
    return index < frontProgressImages.length ? frontProgressImages[index] : null;
  }
  
  // Get total count of captured images for each angle
  int get leftImagesCount => leftProgressImages.length;
  int get rightImagesCount => rightProgressImages.length;
  int get frontImagesCount => frontProgressImages.length;
}