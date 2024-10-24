import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';

class MyTimelineTitle extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
 
  const MyTimelineTitle({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,

  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isPast ? Colors.orange : Colors.grey,
        thickness: 2,
      ),
      indicatorStyle: IndicatorStyle(
        width: 25,
        color: isPast ? Colors.orange : Colors.grey,
        iconStyle: IconStyle(
          color: Colors.white,
          iconData: Icons.check,
        ),
       
      ),

    );
  }
}
