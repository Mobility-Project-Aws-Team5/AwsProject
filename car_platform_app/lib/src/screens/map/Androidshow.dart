import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:flutter/foundation.dart'; // kIsWeb을 사용하기 위한 import

import '../../home.dart';

class Androidshow extends StatefulWidget {
  const Androidshow({Key? key}) : super(key: key);

  @override
  _AndroidshowState createState() => _AndroidshowState();
}

class _AndroidshowState extends State<Androidshow> {
  late GoogleMapController mapController;
  LatLng _selectedPosition = const LatLng(37.7749, 128.4194); // 초기 위치
  bool _isLoading = true;
  String _currentAddress = '';
  String _currentCity = '';
  String _currentState = '';

  // Google Maps Geocoding API 키
  final geocoding = GoogleMapsGeocoding(apiKey: 'AIzaSyCs7na910dJnCwOxPE1dOO-EnLoMV3ivkw');

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
    _getAddressFromLatLng(position);
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // 위치 서비스 활성화 확인
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      // 위치 권한 확인
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return;
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      print('Initial position: $_selectedPosition'); // 초기 위치를 출력
      _getAddressFromLatLng(_selectedPosition);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _updateCurrentLocation() async {
    try {
      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
      });
      print('Updated position: $_selectedPosition'); // 업데이트된 위치를 출력
      _getAddressFromLatLng(_selectedPosition);
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final response = await geocoding.searchByLocation(
        Location(lat: position.latitude, lng: position.longitude),
        language: 'ko',
      );

      if (response.status == 'OK' && response.results.isNotEmpty) {
        final result = response.results.first;
        setState(() {
          _currentAddress = result.formattedAddress ?? 'Unknown address';
          _currentCity = result.addressComponents
              .firstWhere(
                  (c) => c.types.contains('locality'),
              orElse: () => AddressComponent(
                  longName: '', shortName: '', types: []))
              .longName;
          _currentState = result.addressComponents
              .firstWhere(
                  (c) => c.types.contains('administrative_area_level_1'),
              orElse: () => AddressComponent(
                  longName: '', shortName: '', types: []))
              .longName;
        });
        print('Current address: $_currentAddress'); // 주소를 출력
      } else {
        print('Error getting address: ${response.errorMessage}');
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {'city': _currentCity, 'state': _currentState},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구글 맵 위치 설정'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: GoogleMap( // 웹에서만 사용할 GoogleMap
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _selectedPosition,
                zoom: 12.0,
              ),
              onTap: _onMapTap,
              myLocationEnabled: true, // 사용자 위치 표시
              myLocationButtonEnabled: true, // 사용자 위치로 이동 버튼 활성화
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _updateCurrentLocation();
          _navigateToHome(context);
        },
        label: const Text('위치 설정 완료'),
        icon: const Icon(Icons.map),
        heroTag: 'location_button', // 고유한 heroTag 지정
      ),
    );
  }
}
