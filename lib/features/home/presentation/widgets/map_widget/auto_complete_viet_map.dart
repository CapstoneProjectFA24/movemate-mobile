import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';

final pickupSelectedLocationProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);
final dropoffSelectedLocationProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);

class ModifiedAutocompleteWidget extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPickUp;

  const ModifiedAutocompleteWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.isPickUp,
  });

  @override
  ConsumerState<ModifiedAutocompleteWidget> createState() =>
      _ModifiedAutocompleteWidgetState();
}

class _ModifiedAutocompleteWidgetState
    extends ConsumerState<ModifiedAutocompleteWidget> {
  List<dynamic> _suggestions = [];
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  bool _isProgrammaticallySettingText = false;

  void _controllerListener() {
    setState(() {});
    _onChanged(widget.controller.text);
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.length > 2) {
      _fetchSuggestions(value);
    } else {
      setState(() {
        _suggestions = [];
      });
      _removeOverlay();
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
        _showOverlay();
      } else {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
        _removeOverlay();
      }
    } catch (e) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
      _removeOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    double topOffset;
    double leftOffset = offset.dx;
    double width = size.width;

    // Modify the positioning to make the suggestions dropdown on top of the "Đến" label
    if (widget.isPickUp) {
      topOffset = offset.dy - (_suggestions.length * 60.0);
    } else {
      topOffset = offset.dy + size.height;
    }

    return OverlayEntry(
      builder: (context) => Positioned(
        left: leftOffset,
        width: width,
        top: topOffset,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              0.0, widget.isPickUp ? size.height + 20.0 : size.height + 20.0),
          child: Material(
            elevation: 4.0,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.red),
                      title: Text(
                        suggestion['display'],
                        style: const TextStyle(
                          color: Colors.black, // Đặt màu sắc mong muốn
                        ),
                      ),
                      onTap: () {
                        _selectSuggestion(suggestion);
                        _removeOverlay(); // Đóng dropdown ngay sau khi chọn
                      });
                },
              ),
            ),
          ),
        ),
      ),
    );
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

        final checkDistance = await calculateDistance(
          10.841416800000001,
          106.81007447258705,
          details['lat'],
          details['lng'],
        );

        // Thêm điều kiện kiểm tra khoảng cách
        if (checkDistance >= 161) {
          // Hiển thị pop-up thông báo
          // Hiển thị Snackbar thông báo
          Flushbar(
            message:
                'Dịch vụ không trong phạm vi phục vụ. Vui lòng chọn địa điểm khác.',
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.grey.withOpacity(0.8),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            flushbarPosition: FlushbarPosition.TOP, // Đặt vị trí ở trên cùng
          ).show(context);
          // Dừng việc thực thi hàm nếu khoảng cách quá xa
          return;
        }

        print("check distance: $checkDistance");
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

        // Đọc lại các giá trị từ bookingProvider
        final bookingState = ref.read(bookingProvider);
        final pickUpLocation = bookingState.pickUpLocation;
        final dropOffLocation = bookingState.dropOffLocation;

        if (pickUpLocation != null && dropOffLocation != null) {
          final distance = await calculateDistance(
            pickUpLocation.latitude,
            pickUpLocation.longitude,
            dropOffLocation.latitude,
            dropOffLocation.longitude,
          );
          bookingNotifier.updateDistance(distance.toString());
          print('Khoảng cách distance: $distance km');
        }

        _isProgrammaticallySettingText = true;
        widget.controller.text = details['display'];

        setState(() {
          _suggestions = [];
        });

        _removeOverlay();

        // Đặt lại _isProgrammaticallySettingText sau khi khung hình hiện tại đã hoàn thành
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _isProgrammaticallySettingText = false;
        });
      }
    } catch (e) {
      print('Error fetching location details: $e');
    }
  }

  Future<double> calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) async {
    const apiKey = APIConstants.apiVietMapKey;
    final url = Uri.parse(
      'https://maps.vietmap.vn/api/matrix?api-version=1.1&'
      'apikey=$apiKey&'
      'point=$lat1,$lon1&'
      'point=$lat2,$lon2&'
      'points_encoded=false&'
      'vehicle=car&'
      'sources=0&'
      'destinations=1&'
      'annotation=distance',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final distance =
            data['distances'][0][0] / 1000; // Khoảng cách tính bằng km
        print('Khoảng cách distance: $distance km');
        print('Khoảng cách data: $data km');
        return distance;
      } else {
        throw Exception('Failed to fetch distance: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Đặt màu sắc mong muốn
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.black), // Đặt màu văn bản
            decoration: InputDecoration(
              hintText: widget.isPickUp ? 'Tìm điểm đi' : 'Tìm điểm đến',
              hintStyle: TextStyle(color: Colors.grey[600]), // Màu gợi ý
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.controller.clear();
                        setState(() {
                          _suggestions = [];
                        });
                        _removeOverlay();
                        if (widget.isPickUp) {
                          ref
                              .read(bookingProvider.notifier)
                              .clearPickUpLocationInMap();
                          ref
                              .read(bookingProvider.notifier)
                              .clearPickUpLocation();
                        } else {
                          ref
                              .read(bookingProvider.notifier)
                              .clearDropOffLocationInMap();
                          ref
                              .read(bookingProvider.notifier)
                              .clearDropOffLocation();
                        }
                        _focusNode
                            .requestFocus(); // Đảm bảo TextField giữ focus
                      },
                    ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
              ),
            ),

            onChanged: (value) {
              if (!_isProgrammaticallySettingText) {
                _onChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
