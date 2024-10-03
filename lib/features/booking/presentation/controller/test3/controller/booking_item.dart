import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/booking_entities.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class BookingItem extends HookConsumerWidget {
  const BookingItem({
    super.key,
    required this.booking,
    required this.onCallback,
  });

  final BookingEntities booking;
  final VoidCallback onCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.all(AssetsConstants.defaultPadding - 12.0),
      margin: const EdgeInsets.only(bottom: AssetsConstants.defaultMargin),
      decoration: BoxDecoration(
        color: AssetsConstants.whiteColor,
        border: Border.all(color: AssetsConstants.subtitleColor),
        borderRadius: BorderRadius.circular(AssetsConstants.defaultBorder),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // Điều hướng đến màn hình chi tiết nếu cần
              // context.router.push(BookingDetailScreenRoute(bookingId: booking.id));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelText(
                            content: booking.id.toString(),
                            size: AssetsConstants.defaultFontSize - 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                          LabelText(
                            content: booking.status.toString(),
                            size: AssetsConstants.defaultFontSize - 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  width: size.width,
                  height: 1,
                  color: AssetsConstants.subtitleColor,
                ),
                SizedBox(height: size.height * 0.01),
                // Thêm thông tin chi tiết về booking ở đây
              ],
            ),
          ),
          CustomButton(
            isOutline: true,
            size: AssetsConstants.defaultFontSize - 14.0,
            content: 'Details'.toUpperCase(),
            onCallback: onCallback,
            isActive: true,
            width: size.width,
            height: size.height * 0.04,
            backgroundColor: AssetsConstants.whiteColor,
            contentColor: AssetsConstants.mainColor,
          ),
          SizedBox(height: size.height * 0.005),
        ],
      ),
    );
  }
}
