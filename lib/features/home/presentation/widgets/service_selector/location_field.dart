import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/features/home/domain/entities/location_model_entities.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class LocationField extends StatefulWidget {
  final String title;
  final LocationModel? location;
  final VoidCallback onTap;
  final bool hasError;
  final String errorMessage;
  final VoidCallback? onClear;
  final TextEditingController locationController;

  const LocationField({
    required this.title,
    required this.location,
    required this.onTap,
    required this.hasError,
    required this.errorMessage,
    required this.locationController,
    this.onClear,
    super.key,
  });

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  bool _showClearButton = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _showClearButton = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _showClearButton = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _showClearButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Label
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FadeInUp(
            child: LabelText(
              content: widget.title,
              size: 16,
              fontFamily: 'bold',
              color: AssetsConstants.blackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Location Selection Container
        GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          child: Stack(
            children: [
              FadeInRight(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.hasError
                          ? Colors.red
                          : AssetsConstants.primaryMain,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_location_outlined,
                        color: widget.hasError
                            ? Colors.red
                            : AssetsConstants.primaryMain,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.location?.address ?? 'Chọn địa điểm',
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.hasError
                                ? Colors.red
                                : AssetsConstants.blackColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      // Spacer for the Clear (X) button
                      if (widget.location != null) const SizedBox(width: 26),
                    ],
                  ),
                ),
              ),

              // Clear (X) Button Positioned on Top
              if (_showClearButton && widget.location != null)
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Prevent the onTap of the parent GestureDetector from triggering
                          if (widget.onClear != null) {
                            widget.onClear!();
                            setState(() {
                              _showClearButton = false;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Semantics(
                            label: 'Clear location',
                            button: true,
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: widget.hasError
                                  ? Colors.red
                                  : AssetsConstants.blackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Error Message
        if (widget.hasError)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: LabelText(
              content: widget.errorMessage,
              size: 12,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }
}
