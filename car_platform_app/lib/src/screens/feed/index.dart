import 'dart:math';
import 'package:car_platform_app/src/shared/data.dart';
import 'package:get/get.dart';

import 'package:car_platform_app/src/controllers/Feed_Controller.dart';
import 'package:car_platform_app/src/widgets/buttons/category_button.dart';
import 'package:car_platform_app/src/widgets/listitems/feed_list_item.dart';
import 'package:flutter/material.dart';
import 'package:car_platform_app/src/screens/feed/FeedCreate.dart';

class FeedIndex extends StatefulWidget {
  final String? city;
  final String? state;

  const FeedIndex(this.city, this.state, {super.key});

  @override
  State<FeedIndex> createState() => _FeedIndexState();
}

class _FeedIndexState extends State<FeedIndex> {
  final feedController = Get.put(FeedController());
  int _currentPage = 1;

  bool _onNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.extentAfter == 0) {
      feedController.feedIndex(page: ++_currentPage);
      return true;
    }
    return false;
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    await feedController.feedIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () { Get.to(() => FeedCreate()); },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.state == null ? '내 동네' : '${widget.state} ${widget.city}'),
        actions: [
          IconButton(
            onPressed: () {}, // 검색 버튼 처리
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {}, // 알림 버튼 처리
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Expanded(
            child: Obx(
                  () => NotificationListener<ScrollNotification>(
                onNotification: _onNotification,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: feedController.feedList.length,
                    itemBuilder: (context, index) {
                      final item = feedController.feedList[index];
                      return FeedListItem(item);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
