import 'package:car_platform_app/src/models/FeedModel.dart';
import 'package:car_platform_app/src/widgets/modal/more_bottom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/feed/FeedEdit.dart';
import 'package:car_platform_app/src/screens/feed/FeedCreate.dart';
import 'package:car_platform_app/src/screens/feed/show.dart';
import 'package:car_platform_app/src/widgets/modal/confirm_modal.dart';
import 'package:car_platform_app/src/controllers/Feed_Controller.dart';

const double _imageSize = 110;

class FeedListItem extends StatelessWidget {
  final FeedModel item;
  const FeedListItem(this.item, {super.key});
  

  @override
Widget build(BuildContext context) {
  final FeedController feedController = Get.put(FeedController());

  return InkWell(
    onTap: () {
      Get.to(() => FeedShow(item.id));
    },
    child: Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.file(
                model.image,
                width: _imageSize,
                height: _imageSize,
                fit: BoxFit.cover,
              ),
            ),
            */

            // 정보 영역
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          '카테고리',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      item.price.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return MoreBottomModal(
                      cancleTap: () {
                        Get.back();
                      },
                      hideTap: () {},
                      delete: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmModal(
                              title: '삭제하기',
                              message: '이 글을 삭제하시겠습니까?',
                              confirmText: '삭제하기',
                              confirmAction: () async {
                                bool result = await feedController.feedDelete(item.id);
                                if (result) {
                                  Get.back();
                                  Get.back();
                                }
                              },
                              cancel: () {
                                Get.back();
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
                size: 16,
              ),
            ),
          ],
        ),

         Positioned(
                right: 10, bottom: 0,
                child: Row(
                    children:[
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey, size: 16),
                      SizedBox(width: 2),
                      Text(
                        '1', style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 4),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.grey, size: 16),
                          SizedBox(width:2),
                          Text('1', style: TextStyle(color: Colors.grey)),
                      ],
                      ),
                    ),
      ],

    ),
  );
}
}