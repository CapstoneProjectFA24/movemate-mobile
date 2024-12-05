import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// Dữ liệu mô phỏng cho các phòng và đặt chỗ
final reservationsProvider = Provider<List<Reservation>>((ref) {
  return [
    Reservation(
      exceptionName: 'Vỡ hàng',
      reason: 'checsk ing ',
      date: '22 Mon 16:00',
      imageUrl:
          'https://storage.googleapis.com/a1aa/image/7eEf2vIAxag5ukBswRZdsz82YK5CEON6WXkWfMBpjS7PQTvnA.jpg',
      icons: [
        FontAwesomeIcons.wifi,
        FontAwesomeIcons.video,
        FontAwesomeIcons.microphoneSlash,
      ],
    ),
    Reservation(
      exceptionName: 'Vỡ hàng',
      reason: '20 chakcis kings',
      date: '25 Thu 10:00',
      imageUrl:
          'https://storage.googleapis.com/a1aa/image/SWsCKXB2pt52HV4LsLZmWMTjisBDxS2eIjLds3ARuVsC007JA.jpg',
      icons: [
        FontAwesomeIcons.wifi,
        FontAwesomeIcons.desktop,
      ],
    ),
    // Thêm các phòng khác ở đây...
  ];
});

// Model để lưu thông tin một phòng và đặt chỗ
class Reservation {
  final String exceptionName;
  final String reason;
  final String date;
  final String imageUrl;
  final List<IconData> icons;

  Reservation({
    required this.exceptionName,
    required this.reason,
    required this.date,
    required this.imageUrl,
    required this.icons,
  });
}

@RoutePage()
// Widget chính
class IncidentsListScreen extends HookConsumerWidget {
  const IncidentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = ref.watch(reservationsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AssetsConstants.primaryMain,
        backButtonColor: AssetsConstants.whiteColor,
        title: "Danh sách sự cố",
        iconSecond: Icons.home_outlined,
        onCallBackSecond: () {
          final tabsRouter = context.router.root
              .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
          if (tabsRouter != null) {
            tabsRouter.setActiveIndex(0);
            context.router.popUntilRouteWithName(TabViewScreenRoute.name);
          } else {
            context.router.pushAndPopUntil(
              const TabViewScreenRoute(children: [
                HomeScreenRoute(),
              ]),
              predicate: (route) => false,
            );
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return ReservationCard(reservation: reservation);
          },
        ),
      ),
    );
  }
}

// Widget cho mỗi card đặt chỗ
class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              reservation.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reservation.exceptionName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text("${reservation.reason} reason"),
                  const SizedBox(height: 8),
                  Row(
                    children: reservation.icons
                        .map((icon) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                icon,
                                size: 14,
                                color: Colors.orangeAccent,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDDDDDD)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
                children: [
                  Text(
                    reservation.date.split(' ')[0],
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(reservation.date.split(' ')[1]),
                  Text(reservation.date.split(' ')[2]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
