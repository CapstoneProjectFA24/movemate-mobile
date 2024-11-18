import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:movemate/utils/constants/api_constant.dart';
import 'dart:convert';

import 'package:movemate/utils/providers/common_provider.dart';

class Header extends HookConsumerWidget {
  const Header({super.key});

  // Hàm để lấy vị trí hiện tại
  Future<Position> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Không có quyền truy cập vị trí");
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Hàm để gọi Reverse Geocoding API của VietMap
  Future<String> _getAddressFromLatLng(Position position) async {
    const apiKey = APIConstants.apiVietMapKey;
    final double latitude = position.latitude;
    final double longitude = position.longitude;

    final String url =
        'https://maps.vietmap.vn/api/reverse/v3?apikey=$apiKey&lat=$latitude&lng=$longitude';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          // Lấy thông tin từ boundaries
          List<dynamic> boundaries = data[0]['boundaries'];
          String district = "";
          String city = "";

          for (var boundary in boundaries) {
            if (boundary['type'] == 1) {
              district = boundary['name']; // Lấy tên Quận/Huyện
            } else if (boundary['type'] == 0) {
              city = boundary['name']; // Lấy tên Thành Phố
            }
          }

          return "$district, $city";
        } else {
          return "Không tìm thấy địa chỉ";
        }
      } else {
        return "Lỗi khi gọi API: ${response.statusCode}";
      }
    } catch (e) {
      return "Không thể lấy địa chỉ: $e";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
      child: FutureBuilder<String>(
        future: _getCurrentPosition()
            .then((position) => _getAddressFromLatLng(position)),
        builder: (context, snapshot) {
          String currentAddress = "Đang lấy vị trí...";

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              currentAddress = snapshot.data!;
            } else if (snapshot.hasError) {
              currentAddress = "Không thể lấy địa chỉ";
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeInUp(
                    child: Text(
                      'Chào mừng ${user?.name ?? "PI"}!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          FadeInLeft(
                              child: const Icon(Icons.location_on,
                                  color: Colors.white, size: 16)),
                          const SizedBox(width: 4),
                          FadeInRight(
                            child: const Text(
                              'Vị trí hiện tại',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      FadeInUp(
                        child: Text(
                          currentAddress,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
