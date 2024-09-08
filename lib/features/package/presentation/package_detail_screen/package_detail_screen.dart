
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

// TO DO TUAN

@RoutePage()
class PackageDetailScreen extends StatelessWidget {
  const PackageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PackageDetailScreen Screen'),
      ),
      body: const Center(
        child: Text('Welcome to PackageDetailScreen!'),
      ),
    );
  }
}
