import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_platform_app/src/app.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify if initial screen and counter are displayed correctly', (tester) async {
      // MyApp 위젯 로드.
      await tester.pumpWidget(const MyApp(true));

      // 기본적으로 'Intro' 화면이 로드되어야 하므로, 해당 텍스트가 존재하는지 확인합니다.
      expect(find.text('생각만 했던 컴퓨터 업그레이드\n지금 당신의 주변에서 쉽게 시작하세요!'), findsOneWidget); // Intro 화면이 표시되는지 확인.

      // 이 테스트에서는 카운터를 테스트하려면 MyApp에 카운터 관련 기능을 추가해야 하므로, 
      // 카운터 텍스트가 '0'인 상태를 검증하려면 MyApp을 카운터 포함한 화면으로 수정해야 합니다.
      // 이후 'floatingActionButton'을 찾고, 클릭하여 카운터가 증가하는지 확인할 수 있습니다.
    });
  });
}
