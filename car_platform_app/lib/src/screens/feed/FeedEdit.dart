import 'package:car_platform_app/src/controllers/Feed_Controller.dart';
import 'package:car_platform_app/src/controllers/file_controller.dart';
import 'package:car_platform_app/src/screens/feed/FeedCreate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:car_platform_app/src/models/FeedModel.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/buttons/feed_image.dart';

class FeedEdit extends StatefulWidget {
  final FeedModel model;
  const FeedEdit(this.model, {super.key});

  @override
  State<FeedEdit> createState() => _FeedEditState();
}

class _FeedEditState extends State<FeedEdit> {
  final feedController = Get.put(FeedController());
  final fileController = Get.put(FileController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'CPU';
  int? imageId;
  final picker = ImagePicker();
  File? _image;


  _submit() async{
    final result = await feedController.feedUpdate(
        widget.model.id,
        _titleController.text,
        _priceController.text,
        _contentController.text,
        fileController.imageId.value
    );
    if(result) { Get.back(); }
  }

  @override
  void initState(){
    super.initState();
    _titleController.text = widget.model.title;
    _priceController.text = widget.model.price.toString();
    _contentController.text = widget.model.content;
    fileController.imageId.value = widget.model.imageId;
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
        appBar: AppBar(title: Text('물품 수정')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget> [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12.0),
              TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '설명'),
              maxLines: 3,
            ),
              const SizedBox(height: 12.0),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>[
                'CPU',
                'GPU',
                'RAM',
                'Mainboard',
                'Storage',
                'Power',
                'Case',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: '카테고리',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),

            // 이미지 업로드
            InkWell(
                onTap: fileController.upload,
                child: Obx(
                      () => FeedImage(fileController.imageUrl),
                )
            ),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('사진 추가'),
            ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () { Get.to(() => const FeedCreate()); },
              child: const Text('수정하기'),
              ),
            ]
          )
        ),
    );
  }
}