import 'dart:io';

import 'package:car_platform_app/src/controllers/file_controller.dart';
import 'package:car_platform_app/src/widgets/buttons/feed_image.dart';
import 'package:car_platform_app/src/widgets/forms/label_textfield.dart';
import 'package:car_platform_app/src/widgets/listitems/feed_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:car_platform_app/src/controllers/Feed_Controller.dart';
import 'dart:math';

class FeedCreate extends StatefulWidget {
  const FeedCreate({Key? key}) : super(key: key);

  @override
  State<FeedCreate> createState() => _FeedCreateState();
}

class _FeedCreateState extends State<FeedCreate> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final feedController = Get.put(FeedController());
  final fileController = Get.put(FileController());
  String _selectedCategory = 'CPU';
  File? _image;
  int? imageId;

  final picker = ImagePicker();

  _submit() async{
    final result = await feedController.feedCreate(
      _titleController.text,
      _priceController.text,
      _contentController.text,
      fileController.imageId.value//imageId
      );
      if(result){
        Get.back();
      }
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('부품 팔기')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: const Icon(Icons.camera_alt_outlined,
                        color: Colors.grey,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 이미지 업로드
                  InkWell(
                    onTap: fileController.upload,
                    child: Obx(
                          () => FeedImage(fileController.imageUrl),
                    ),
                  ),

                  //제목
                  LabelTextfield(label: '제목', hintText: '제목', controller: _titleController),
                  LabelTextfield(label: '가격', hintText: '가격을 입력해주세요', controller: _priceController),
                  LabelTextfield(label: '자세한 설명', hintText: '자세한 설명을 입력하세요', controller: _contentController),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('작성 완료'),
              ),
            ),
          ],
        ),
      ),
      );
  }
}

