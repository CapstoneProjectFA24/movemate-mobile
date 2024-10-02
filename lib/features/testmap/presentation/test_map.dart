import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

@RoutePage()
class TestMap extends StatefulWidget {
  const TestMap({super.key});

  @override
  _TestMapState createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  VietmapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LabelText(
          content: 'VietMap Example',
          size: 25,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      body: VietmapGL(
        styleString:
            'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=YOUR_API_KEY_HERE',
        initialCameraPosition:
            const CameraPosition(target: LatLng(10.762317, 106.654551)),
        onMapCreated: (VietmapController controller) {
          setState(() {
            // mapController = controller;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
