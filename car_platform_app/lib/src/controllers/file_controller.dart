import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/file_provider.dart';
import '../shared/global.dart';

class FileController extends GetxController {
  final provider = Get.put(FileProvider());
  final imageId = Rx<int?>(null);

  String? get imageUrl =>
      imageId.value != null
          ? "${Global.baseUrl}/file/${imageId.value}"
          : null;

  Future<void> upload() async {
    // 웹에서는 FilePicker로 파일을 선택
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,  // 이미지 파일만 선택 가능하도록 설정
    );

    if (result == null) return;  // 파일이 선택되지 않으면 종료

    // 선택된 파일의 경로와 이름
    PlatformFile file = result.files.first;
    String filePath = file.path ?? '';
    String fileName = file.name;

    // 업로드 요청
    Map body = await provider.imageUpload(fileName, filePath);

    // 업로드 성공 시 이미지 ID 저장
    if (body['result'] == 'ok') {
      imageId.value = body['data'] as int;
    }
  }
}
