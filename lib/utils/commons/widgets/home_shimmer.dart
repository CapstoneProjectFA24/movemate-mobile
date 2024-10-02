import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants/asset_constant.dart';

List<Widget> _generateWidget(int amount, Size size) {
  // <<<<< Note this change for the return type
  List<Widget> listings = [];
  int i = 0;
  for (i = 0; i < amount; i++) {
    listings.add(
      Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: size.height * 0.15,
          width: size.width * 0.9,
          margin: EdgeInsets.only(
            top: size.height * 0.02,
            bottom: size.height * 0.005,
          ),
          decoration: BoxDecoration(
            color: AssetsConstants.whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
  return listings;
}

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({
    super.key,
    required this.amount,
  });
  final int amount;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Column(
        children: [
          ..._generateWidget(amount, size),
        ],
      ),
    );
  }
}
