// خدمة الموقع والخرائط
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // التحقق من تفعيل خدمة الموقع
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // التحقق من صلاحيات الموقع
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // طلب صلاحيات الموقع
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // الحصول على الموقع الحالي
  Future<Position?> getCurrentLocation() async {
    try {
      // التحقق من تفعيل خدمة الموقع
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        // طلب تفعيل خدمة الموقع
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          return null;
        }
      }

      // التحقق من الصلاحيات
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // الصلاحيات مرفوضة بشكل دائم
        return null;
      }

      // الحصول على الموقع
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  // الحصول على عنوان من الإحداثيات
  Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
      }
      return null;
    } catch (e) {
      debugPrint('Error getting address: $e');
      return null;
    }
  }

  // الحصول على إحداثيات من عنوان
  Future<Location?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      return locations.isNotEmpty ? locations.first : null;
    } catch (e) {
      debugPrint('Error getting coordinates: $e');
      return null;
    }
  }

  // الحصول على معلومات المكان التفصيلية
  Future<Placemark?> getPlaceDetails(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (e) {
      debugPrint('Error getting place details: $e');
      return null;
    }
  }

  // حساب المسافة بين نقطتين
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // تنسيق المسافة
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} م';
    } else {
      double km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} كم';
    }
  }

  // الاستماع للتغيرات في الموقع
  Stream<Position>? getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }

  // التحقق من وجود صلاحيات
  Future<bool> hasPermission() async {
    final permission = await checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // فتح إعدادات الموقع
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // فتح إعدادات التطبيق
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}

// نموذج الموقع
class LocationData {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;
  final double? accuracy;
  final double? altitude;
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
    this.accuracy,
    this.altitude,
    required this.timestamp,
  });

  factory LocationData.fromPosition(Position position) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      timestamp: position.timestamp ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'accuracy': accuracy,
      'altitude': altitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
