import 'package:car_platform_app/src/screens/feed/index.dart';
import 'package:car_platform_app/src/screens/nowPrice/ComponentScreen.dart';
import 'package:flutter/material.dart';
import 'package:car_platform_app/src/screens/my/mypage.dart';
import 'package:car_platform_app/src/screens/map/Androidshow.dart';
import 'package:car_platform_app/src/database/my_database.dart';
import 'package:car_platform_app/src/controllers/User_Controller.dart';
import 'package:get/get.dart';

import 'database/mysql_db.dart';

final List<BottomNavigationBarItem> myTabs  = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: '홈',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.feed),
    label: '동네',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.chat_bubble_outline_rounded),
    label: '최근 시세',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline),
    label: '마이',
  ),
];

class Home extends StatefulWidget {
  final String? country;
  final String? city;

  const Home(this.country, this.city, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userController = Get.put(UserController());
  int _selectedIndex = 0;
  late MyDatabase _database;
  var _bConnection = false;
  var _name = 'Database';

  String _currentCity = '내 동네';
  String _currentState = '';

  @override
  void initState() {
    super.initState();
    userController.myInfo();
    
    MysqlDb.initializeDB().then((value) => {
      _database = value,
      _name = _database.getName(),
      _bConnection = true,
      print('Connection Success!!'),
      setState(() {})
    });

    if (widget.city != null && widget.country != null) {
      _currentCity = widget.city!;
      _currentState = widget.country!;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> myTabItems = [
      FeedIndex(_currentCity, _currentState),
      Androidshow(),
      ComponentsScreen(),
      MyPage(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: myTabs,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: myTabItems,
      ),
    );
  }
}
