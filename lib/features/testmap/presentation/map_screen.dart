import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();

@RoutePage()
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  static const LatLng sourceLocation =
      LatLng(11.304291372889852, 106.61750636576055);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const LabelText(
            content: 'Màn hình bản đồ',
            color: AssetsConstants.whiteColor,
            size: 25,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: AssetsConstants.mainColor,
          centerTitle: true,
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(11.304291372889852, 106.61750636576055),
            zoom: 14.5,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            print("Map created");
          },
        ));
  }
}
