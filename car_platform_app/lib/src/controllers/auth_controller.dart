import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_platform_app/src/providers/AuthProvider.dart';
import 'package:car_platform_app/src/shared/global.dart';
import 'dart:developer';

class AuthController extends GetxController {
  final RxBool isButtonEnabled = false.obs;
  final authProvider = Get.put(AuthProvider());
  final RxBool showVerifyForm = false.obs;
  final RxString buttonText = "인증문자 받기".obs;
  String? phoneNumber;
  Timer? countdownTimer;

  Future<bool> register(String password, String name, int? profile) async {
    
    Map body =
        await authProvider.register(phoneNumber!, password, name, profile);
    if (body['result'] == 'ok') {
      String token = body['access_token'];
      log("token : $token");
      Global.accessToken = token;
      return true;
    }
    Get.snackbar('회원가입 에러', body['message'],
        snackPosition: SnackPosition.BOTTOM);
    return false;

  }

  Future<void> requestVerificationCode(String phone) async {
    phoneNumber = phone;
    Map body = await authProvider.requestPhoneCode(phone);
    if (body['result'] == 'ok') {
      // 인증 받은 휴대폰 번호를 저장
      DateTime expiryTime = DateTime.parse(body['expired']);
      _startCountdown(expiryTime);
    }
  }
  // 사용자가 입력한 코드를 검증하는 함수

  Future<bool> verifyPhoneNumber(String userInputCode) async {
    Map body = await authProvider.verifyPhoneNumber(userInputCode);
    if (body['result'] == 'ok') {
      return true;
    }
    Get.snackbar('인증번호 에러', body['message'],
        snackPosition: SnackPosition.BOTTOM);
    return false;
  }

  void _startCountdown(DateTime expiryTime) {
    isButtonEnabled.value = false; // 버튼 비활성화
    showVerifyForm.value = true; // 인증 폼 활성화
    countdownTimer?.cancel(); // 기존 타이머가 있다면 취소
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Duration timeDiff = expiryTime.difference(DateTime.now());
      if (timeDiff.isNegative) {
        buttonText.value = "인증문자 다시 받기";
        isButtonEnabled.value = true;
        timer.cancel(); // 타이머 종료
      } else {
        // 남은 시간을 mm:ss 포맷으로 업데이트
        String minutes = timeDiff.inMinutes.toString().padLeft(2, '0');
        String seconds = (timeDiff.inSeconds % 60).toString().padLeft(2, '0');
        buttonText.value = "인증문자 다시 받기 $minutes:$seconds";
      }
    });
  }

  void updateButtonState(TextEditingController phoneController) {
    String text = phoneController.text.replaceAll('-', ''); // 하이픈 제거
    if (text.length <= 3 && !text.startsWith('010')) {
      text = '010';
    } else if (!text.startsWith('010')) {
      text = '010$text';
    }
    if (text.length > 11) {
      text = text.substring(0, 11);
    }
    String formattedText = _formatPhoneNumber(text);
    int cursorPosition = phoneController.selection.baseOffset +
        (formattedText.length - phoneController.text.length);
    phoneController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
          offset: cursorPosition.clamp(0, formattedText.length)),
    );

    isButtonEnabled.value = text.length == 11;
  }

  String _formatPhoneNumber(String text) {
    if (text.length > 7) {
      return '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}';
    } else if (text.length > 3) {
      return '${text.substring(0, 3)}-${text.substring(3)}';
    }
    return text;
  }

  Future<bool> login(String phone, String password) async {
    phone = phone;
    Map body = await authProvider.login(phone, password);
    if (body['result'] == 'ok') {
      String token = body['access_token'];
      log("token : $token");
      Global.accessToken = token;
      return true;
    }
    Get.snackbar('로그인 에러', body['message'],
        snackPosition: SnackPosition.BOTTOM);
    return false;
  }
}
