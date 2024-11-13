import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';

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

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });

    widget.controller.addListener(() {
      setState(() {});
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
    _overlayEntry?.remove();
    _overlayEntry = null;
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
                        color: Colors.black,
                      ),
                    ),
                    onTap: () => _selectSuggestion(suggestion),
                  );
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

        widget.controller.text = details['display'];

        setState(() {
          _suggestions = [];
        });

        _removeOverlay();
      }
    } catch (e) {
      print('Error fetching location details: $e');
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
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.isPickUp ? 'Tìm điểm đi' : 'Tìm điểm đến',
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
                              .updatePickUpLocation(null);
                        } else {
                          ref
                              .read(bookingProvider.notifier)
                              .updateDropOffLocation(null);
                        }
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
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }
}
