import 'dart:math';
import 'package:car_platform_app/src/screens/feed/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_platform_app/src/screens/feed/FeedCreate.dart';
import 'package:car_platform_app/src/providers/feedProvider.dart';
import 'package:car_platform_app/src/models/FeedModel.dart';
import 'package:car_platform_app/src/screens/feed/FeedCreate.dart';
import 'dart:io';

class FeedController extends GetxController{
  //RxList<Map> feedList = <Map>[].obs;
  final feedProvider = Get.put(FeedProvider());
  final RxList<FeedModel> feedList = <FeedModel>[].obs;
  final Rx<FeedModel?> currentFeed = Rx<FeedModel?>(null);

  feedUpdate(int id, String title, String priceString, String content, int? image) async {
    int price = int.tryParse(priceString) ?? 0;

    Map body = await feedProvider.update(id, title, priceString, content, image);
    if(body['result'] == 'ok') {
      int index = feedList.indexWhere((feed) => feed.id == id);
      if(index != -1) {
        FeedModel updateFeed = feedList[index].copyWith(
          title : title,
          price: price,
          content: content,
          imageId : image,
        );
        feedList[index] = updateFeed;
      }
      return false;
    }
    Get.snackbar('수정 에러', body['message'], snackPosition: SnackPosition.BOTTOM);
    return false;
  }



 Future<void> feedIndex({int page = 1, int size = 10, String? keyword}) async {
  // query 파라미터를 명명된 인수로 전달
  Map json = await feedProvider.index(page: page, size: size, keyword: keyword);
  
  List<FeedModel> tmp = 
    json['data'].map<FeedModel>((m) => FeedModel.parse(m)).toList();
  
  (page == 1) ? feedList.assignAll(tmp) : feedList.addAll(tmp);
}



  Future<bool> feedCreate(
      String title, String price, String content, int? image) async{
        
        Map body = await feedProvider.store(title, price, content, image);

        if(body['result'] == 'ok') {
          await feedIndex();
          return true;
        }
        Get.snackbar('생성 에러', body['message'], snackPosition: 
        SnackPosition.BOTTOM);
        return false;
    } 
    
Future<void> feedShow(int id) async{
  Map body = await feedProvider.show(id);
  if(body['result'] == 'ok'){
    currentFeed.value = FeedModel.parse(body['data']);
  }else {
    Get.snackbar('피드 에러', body['message'],
    snackPosition: SnackPosition.BOTTOM);
    currentFeed.value = null;
  }
}

Future<bool> feedDelete(int id) async {
  Map body = await feedProvider.destroy(id);
  if (body['result'] == 'ok'){
    feedList.removeWhere((feed) => feed.id == id);
    return true;
  }
  Get.snackbar('삭제 에러',body['message'], snackPosition: SnackPosition.BOTTOM);
  return false;
}

  /*
  @override
  void onInit(){
    super.onInit();
    //_initialData();
  }

  /*_initialData(){
    List<Map> sample  = [
      {'id': 1, 'title': '텀블러', 'content': '팝니다', 'price': 500 , 'category' : 'rom', 'image' : Image.asset('assets/images/logo.png')},
      {'id': 2, 'title': '머그잔',  'content': '교환가능', 'price': 300 , 'category': 'rom', 'image' : Image.asset('assets/images/logo.png')}
    ];
    feedList.assignAll(sample);
  }
  */
 
  void addData(title, description, price, category, image){
    final random = Random();
    final newItem = {
      'id': random.nextInt(100),
      'title': title,
      'description' : description,
      'price' : price,
      'category' : category,
      'image' : image,
    };
  }

  void updateData(Map newData){
    final id = newData['id'];
    final index = feedList.indexWhere((item) => item['id'] == id);
    if( index != -1) { feedList[index] = newData; }
  }*/

}