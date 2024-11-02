// components/timeline_steps.dart

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/features/order/presentation/widgets/details/timeLine_title.dart';

class TimelineSteps extends HookWidget {
  final List<Map<String, dynamic>> steps;
  final ValueNotifier<int> expandedIndex;

  const TimelineSteps({
    super.key,
    required this.steps,
    required this.expandedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Column(
        children: [
          SizedBox(
            height: 35,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  MyTimelineTitle(isFirst: true, isLast: false, isPast: true),
                  MyTimelineTitle(isFirst: false, isLast: false, isPast: true),
                  MyTimelineTitle(isFirst: false, isLast: false, isPast: false),
                  MyTimelineTitle(isFirst: false, isLast: true, isPast: false),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(steps.length, (index) {
                    final step = steps[index];
                    return GestureDetector(
                      onTap: () {
                        expandedIndex.value =
                            expandedIndex.value == index ? -1 : index;
                      },
                      child: Column(
                        children: [
                          Text(
                            step['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                ...List.generate(steps.length, (index) {
                  final step = steps[index];
                  return Visibility(
                    visible: expandedIndex.value == index,
                    child: Container(
                      width: 350,
                      height: 300,
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: List.generate(step['details'].length,
                            (detailIndex) {
                          return TimelineTile(
                            alignment: TimelineAlign.start,
                            isFirst: detailIndex == 0,
                            isLast: detailIndex == step['details'].length - 1,
                            indicatorStyle: IndicatorStyle(
                              color: detailIndex <= index
                                  ? AssetsConstants.primaryMain
                                  : Colors.grey,
                              iconStyle: IconStyle(
                                iconData: Icons.circle,
                                color: Colors.white,
                              ),
                            ),
                            endChild: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                step['details'][detailIndex],
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            beforeLineStyle: LineStyle(
                              color: detailIndex <= index
                                  ? AssetsConstants.primaryMain
                                  : Colors.grey,
                              thickness: 4,
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
