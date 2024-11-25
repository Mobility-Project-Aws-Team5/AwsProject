import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class FileProvider extends GetxService {
  // 이미지 업로드
  Future<Map> imageUpload(String name, String path) async {
    try {
      // 선택된 파일을 MultipartFile로 변환 (웹에서는 file.bytes 사용)
      PlatformFile file = await FilePicker.platform.pickFiles(
        type: FileType.image,  // 이미지 파일만 선택 가능하도록 설정
      ).then((result) => result!.files.first);

      if (file.bytes == null) {
        throw Exception('파일을 선택하지 않았습니다');
      }

      // 서버로 전송할 데이터 준비
      var uri = Uri.parse('localhost/file'); // 파일 업로드 API URL
      var request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes(
          'file', // 필드 이름 (서버에서 사용하는 이름)
          file.bytes!, // 파일의 바이트 데이터
          filename: name,
        ));

      // 요청 보내기
      var response = await request.send();

      // 응답 처리
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);
        return responseData;
      } else {
        return {'result': 'error', 'message': '업로드 실패'};
      }
    } catch (e) {
      print('파일 업로드 중 오류 발생: $e');
      return {'result': 'error', 'message': e.toString()};
    }
  }
}
