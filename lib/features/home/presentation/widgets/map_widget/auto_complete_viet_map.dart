import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';

class AutocompleteWidget extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPickUp;

  const AutocompleteWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.isPickUp,
  });

  @override
  ConsumerState<AutocompleteWidget> createState() => _AutocompleteWidgetState();
}

class _AutocompleteWidgetState extends ConsumerState<AutocompleteWidget> {
  List<dynamic> _suggestions = [];
  bool _isLoading = false;

  void _onChanged(String value) {
    if (value.length > 2) {
      _fetchSuggestions(value);
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() {
      _isLoading = true;
    });

    const apiKey = APIConstants.apiVietMapKey;
    const circleCenter = "10.841416800000001,106.81007447258705";
    const circleRadius = 80000;

    final url = Uri.parse(
        'https://maps.vietmap.vn/api/autocomplete/v3?apikey=$apiKey&text=$query&circle_center=$circleCenter&circle_radius=$circleRadius');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final results = json.decode(response.body);
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });
      } else {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
        print('Error fetching autocomplete results: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
      print('Error fetching autocomplete results: $e');
    }
  }

  Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
    const apiKey = APIConstants.apiVietMapKey;
    final refId = suggestion['ref_id'];
    final url = Uri.parse(
        'https://maps.vietmap.vn/api/place/v3?apikey=$apiKey&refid=$refId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final details = json.decode(response.body);
        final location = LocationModel(
          label: details['name'],
          address: details['display'],
          latitude: details['lat'],
          longitude: details['lng'],
          distance: '',
        );

        final bookingNotifier = ref.read(bookingProvider.notifier);
        if (widget.isPickUp) {
          bookingNotifier.updatePickUpLocation(location);
        } else {
          bookingNotifier.updateDropOffLocation(location);
        }

        // Cập nhật vị trí trên bản đồ
        if (ref.read(bookingProvider).pickUpLocation != null &&
            ref.read(bookingProvider).dropOffLocation != null) {
          // Nếu cả hai địa điểm đã chọn, vẽ tuyến đường
          // Bạn có thể gọi hàm vẽ tuyến đường ở đây hoặc nơi cần thiết
        }

        setState(() {
          _suggestions = [];
        });

        // Cập nhật TextField
        widget.controller.text = details['display'];
      } else {
        print('Error fetching location details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching location details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.isPickUp ? 'Tìm điểm đi' : 'Tìm điểm đến',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: _isLoading ? const CircularProgressIndicator() : null,
          ),
          onChanged: _onChanged,
        ),
        if (_suggestions.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.red),
                  title: Text(
                    suggestion['display'],
                    selectionColor: Colors.blue,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => _selectSuggestion(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}
