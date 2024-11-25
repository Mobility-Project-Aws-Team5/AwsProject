import 'package:car_platform_app/src/screens/feed/FeedEdit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';
import 'screens/intro.dart';
import 'screens/register.dart';
import 'screens/map/Androidshow.dart'; // Androidshow 화면을 import

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp(this.isLogin, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          // input 테마
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
          floatingLabelStyle: TextStyle(fontSize: 10),
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        textTheme: const TextTheme(
          labelLarge: TextStyle(
            fontSize: 16,
            fontFamily: 'Noto Sans',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 22, 70, 141),
            padding: const EdgeInsets.symmetric(vertical: 22),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 22, 70, 141),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      routes: {
        '/': (context) => Intro(),
        '/intro': (context) => Intro(),
        '/register': (context) => Register(),
        // '/map': (context) => Androidshow(), // Androidshow 화면 추가
      },
      initialRoute: isLogin ? '/' : '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return Home(args['state'], args['city']);
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
