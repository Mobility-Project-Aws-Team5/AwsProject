import 'package:flutter/material.dart';

class ComponentsScreen extends StatefulWidget {
  @override
  _ComponentsScreenState createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends State<ComponentsScreen> {
  // 현재 선택된 부품 카테고리 (기본값은 CPU로 설정)
  String _selectedCategory = 'CPU';

  // 각 부품 카테고리와 그에 해당하는 부품 정보
  final Map<String, List<Map<String, String>>> _categories = {
    'CPU': [
      {'title': 'Intel i9', 'price': '500,000원', 'image': 'assets/images/cpu/intel core i9.jpg'},
      {'title': 'AMD Ryzen 9', 'price': '450,000원', 'image': 'assets/images/cpu/AMD ryzen 9.jpg'},
      {'title': 'Intel i7', 'price': '400,000원', 'image': 'assets/images/cpu/intel i7.jpg'},
      {'title': 'AMD Ryzen 7', 'price': '350,000원', 'image': 'assets/images/cpu/amd ryzen 7.png'},
      {'title': 'Intel i5', 'price': '300,000원', 'image': 'assets/images/cpu/intel i5.jpg'},
      {'title': 'AMD Ryzen 5', 'price': '250,000원', 'image': 'assets/images/cpu/amd ryzen 5.jpg'},
      {'title': 'Intel i3', 'price': '200,000원', 'image': 'assets/images/cpu/intel i3.jpg'},
      {'title': 'AMD Ryzen 3', 'price': '150,000원', 'image': 'assets/images/cpu/amd ryzen 3.jpg'},
      {'title': 'Intel Xeon', 'price': '600,000원', 'image': 'assets/images/cpu/intel xeon.jpg'},
      {'title': 'AMD Threadripper', 'price': '700,000원', 'image': 'assets/images/cpu/threadripper.jpg'},
    ],
    'GPU': [
      {'title': 'NVIDIA RTX 3080', 'price': '1,200,000원', 'image': 'assets/images/gpu/rtx 3080.jpg'},
      {'title': 'AMD RX 6800 XT', 'price': '1,100,000원', 'image': 'assets/images/gpu/amd 6800.jpg'},
      {'title': 'NVIDIA RTX 3070', 'price': '900,000원', 'image': 'assets/images/gpu/rtx3070.jpg'},
      {'title': 'AMD RX 6700 XT', 'price': '800,000원', 'image': 'assets/images/gpu/amd 6700.jpg'},
      {'title': 'NVIDIA RTX 3060', 'price': '600,000원', 'image': 'assets/images/gpu/rtx3060.jpg'},
      {'title': 'AMD RX 6600 XT', 'price': '500,000원', 'image': 'assets/images/gpu/6600.jpg'},
      {'title': 'NVIDIA GTX 1660', 'price': '400,000원', 'image': 'assets/images/gpu/gtx1660.jpg'},
      {'title': 'AMD RX 590', 'price': '350,000원', 'image': 'assets/images/gpu/amd 590.jpg'},
      {'title': 'NVIDIA GTX 1080', 'price': '300,000원', 'image': 'assets/images/gpu/gtx1080.jpg'},
      {'title': 'AMD RX 580', 'price': '250,000원', 'image': 'assets/images/gpu/amd580.jpg'},
    ],
    'RAM': [
      {'title': 'Corsair Vengeance 16GB', 'price': '150,000원', 'image': 'assets/images/Ram/consair 16.jpg'},
      {'title': 'G.SKILL Trident Z 16GB', 'price': '160,000원', 'image': 'assets/images/Ram/gskill z 16.jpg'},
      {'title': 'Kingston HyperX 16GB', 'price': '140,000원', 'image': 'assets/images/Ram/kingston hyper 16.jpg'},
      {'title': 'Samsung DDR4 16GB', 'price': '130,000원', 'image': 'assets/images/Ram/samsung 16.jpg'},
      {'title': 'Crucial Ballistix 16GB', 'price': '120,000원', 'image': 'assets/images/Ram/crucial ballistix.jpg'},
    ],
    'Power': [
      {'title': 'Corsair RM750', 'price': '120,000원', 'image': 'assets/images/power/consair rm 750.jpg'},
      {'title': 'EVGA SuperNOVA 750', 'price': '130,000원', 'image': 'assets/images/power/evga supernova 750.jpg'},
      {'title': 'Seasonic Focus 750', 'price': '140,000원', 'image': 'assets/images/power/seasonic focus.jpg'},
      {'title': 'Cooler Master MWE 750', 'price': '110,000원', 'image': 'assets/images/power/Cooler Master MWE 850.jpg'},
      {'title': 'Corsair RM850', 'price': '150,000원', 'image': 'assets/images/power/consair rm 850.jpg'},
      {'title': 'EVGA SuperNOVA 850', 'price': '160,000원', 'image': 'assets/images/power/850.jpg'},
      {'title': 'Seasonic Focus 850', 'price': '170,000원', 'image': 'assets/images/power/seasonic focus.jpg'},
      {'title': 'Cooler Master MWE 850', 'price': '140,000원', 'image': 'assets/images/power/coolermaster mwe 750.jpg'},
      {'title': 'Corsair RM1000', 'price': '200,000원', 'image': 'assets/images/power/Corsair RM1000.jpg'},
      {'title': 'EVGA SuperNOVA 1000', 'price': '210,000원', 'image': 'assets/images/power/EVGA SuperNOVA 1000.jpg'},
    ],
    'Monitor': [
      {'title': 'Samsung Odyssey G7', 'price': '700,000원', 'image': 'assets/images/monitor/Samsung Odyssey G7.jpg'},
      {'title': 'LG UltraGear 27GL850', 'price': '600,000원', 'image': 'assets/images/monitor/LG UltraGear 27GL850.jpg'},
      {'title': 'Dell Alienware AW2720HF', 'price': '550,000원', 'image': 'assets/images/monitor/Dell Alienware AW2720HF.jpg'},
      {'title': 'Acer Predator XB273K', 'price': '800,000원', 'image': 'assets/images/monitor/Acer Predator XB273K.jpg'},
      {'title': 'ASUS ROG Swift PG27UQ', 'price': '900,000원', 'image': 'assets/images/monitor/ASUS ROG Swift PG27UQ.jpg'},
      {'title': 'Samsung Odyssey G9', 'price': '1,200,000원', 'image': 'assets/images/monitor/Samsung Odyssey G9.jpg'},
      {'title': 'LG UltraGear 34GN850', 'price': '1,000,000원', 'image': 'assets/images/monitor/LG UltraGear 34GN850.jpg'},
      {'title': 'Dell UltraSharp U2720Q', 'price': '700,000원', 'image': 'assets/images/monitor/Dell UltraSharp U2720Q.jpg'},
      {'title': 'Acer Nitro XV272U', 'price': '500,000원', 'image': 'assets/images/monitor/Acer Nitro XV272U.jpg'},
      {'title': 'ASUS TUF Gaming VG27AQ', 'price': '650,000원', 'image': 'assets/images/monitor/ASUS TUF Gaming VG27AQ.jpg'},
    ],
    'Mouse': [
      {'title': 'Logitech G502', 'price': '70,000원', 'image': 'assets/images/mouse/Logitech G502.jpg'},
      {'title': 'Razer DeathAdder V2', 'price': '80,000원', 'image': 'assets/images/mouse/Razer DeathAdder V2.jpg'},
      {'title': 'SteelSeries Rival 600', 'price': '90,000원', 'image': 'assets/images/mouse/steelSeries Sensei 310.jpg'},
      {'title': 'Logitech G903', 'price': '150,000원', 'image': 'assets/images/mouse/Logitech G903.jpg'},
      {'title': 'Razer Viper Ultimate', 'price': '200,000원', 'image': 'assets/images/mouse/Razer Viper Ultimate.jpg'},
      {'title': 'SteelSeries Sensei 310', 'price': '60,000원', 'image': 'assets/images/mouse/steelSeries Sensei 310.jpg'},
      {'title': 'Logitech G Pro', 'price': '120,000원', 'image': 'assets/images/mouse/Logitech G Pro.jpg'},
      {'title': 'Razer Naga Trinity', 'price': '130,000원', 'image': 'assets/images/mouse/Razer Naga Trinity.jpg'},
      {'title': 'SteelSeries Aerox 3', 'price': '100,000원', 'image': 'assets/images/mouse/SteelSeries Aerox 3.jpg'},
      {'title': 'Logitech MX Master 3', 'price': '130,000원', 'image': 'assets/images/mouse/Logitech MX Master 3.jpg'},
    ],
    'Keyboard': [
      {'title': 'Corsair K95 RGB', 'price': '200,000원', 'image': 'assets/images/keyboard/Corsair K95 RGB.jpg'},
      {'title': 'Razer BlackWidow Elite', 'price': '180,000원', 'image': 'assets/images/keyboard/Razer BlackWidow Elite.jpg'},
      {'title': 'Logitech G915', 'price': '250,000원', 'image': 'assets/images/keyboard/Logitech G915.jpg'},
      {'title': 'SteelSeries Apex Pro', 'price': '220,000원', 'image': 'assets/images/keyboard/SteelSeries Apex Pro.jpg'},
      {'title': 'Corsair K70 RGB', 'price': '170,000원', 'image': 'assets/images/keyboard/Corsair K70 RGB.jpg'},
      {'title': 'Razer Huntsman Elite', 'price': '210,000원', 'image': 'assets/images/keyboard/Razer Huntsman Elite.jpg'},
      {'title': 'Logitech G513', 'price': '160,000원', 'image': 'assets/images/keyboard/Logitech G513.jpg'},
      {'title': 'SteelSeries Apex 7', 'price': '190,000원', 'image': 'assets/images/keyboard/SteelSeries Apex 7.jpg'},
      {'title': 'Corsair K65 RGB', 'price': '150,000원', 'image': 'assets/images/keyboard/Corsair K65 RGB.jpg'},
      {'title': 'Razer Cynosa V2', 'price': '100,000원', 'image': 'assets/images/keyboard/Razer Cynosa V2.jpg'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // 선택된 부품 카테고리의 부품 정보 리스트를 가져옴
    final components = _categories[_selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('부품 시세 보기'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[100]!, Colors.blueGrey[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: <Widget>[
            // 부품 카테고리 선택 버튼들
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    title: Text(
                      '부품 카테고리',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: _categories.keys.map((category) {
                      return ListTile(
                        title: Text(
                          category,
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // 부품 리스트
            Expanded(
              child: ListView.builder(
                itemCount: components.length,
                itemBuilder: (context, index) {
                  final component = components[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          component['image']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(component['title']!),
                      subtitle: Text(component['price']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
