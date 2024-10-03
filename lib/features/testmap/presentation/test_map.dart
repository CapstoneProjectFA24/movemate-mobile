import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';

@RoutePage()
class TestMap extends StatefulWidget {
  const TestMap({super.key});

  @override
  _TestMapState createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
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
        body: Container(
          child: const Text("data"),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
