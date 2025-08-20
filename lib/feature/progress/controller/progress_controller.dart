import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class ProgressController extends GetxController{
  var progressItems = <Map<String,dynamic>>[].obs;
   var janData = <FlSpot>[].obs;
  var febData = <FlSpot>[].obs;
  var showAll = false.obs;
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
}