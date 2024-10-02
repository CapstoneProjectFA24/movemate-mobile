import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/commons/functions/datetime_utils.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/enums_export.dart';


// Ở đây là lấy date time từ tầng presentation
// import '../../../features/money_exchange/presentation/money_exchange_list/money_exchange_screen.dart';
// import '../../../features/order/presentation/order_list/order_screen.dart';

class SearchTimeBox extends StatelessWidget {
  const SearchTimeBox({
    super.key,
    required this.title,
    required this.icon,
    required this.contentColor,
    required this.backGroundColor,
    required this.borderColor,
    required this.onCallBack,
    required this.dateFrom,
    required this.dateTo,
    required this.searchType,
  });
  final String title;
  final Color contentColor;
  final Color backGroundColor;
  final Color borderColor;
  final IconData icon;
  final VoidCallback onCallBack;
  final String dateFrom;
  final String dateTo;
  final SearchDateType searchType;

  // pick dateTime
  void pickDateFrom({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    var time = await dateTimePicker(context);
    if (time == '') {
      return;
    }

    if (searchType == SearchDateType.ordersearch) {
      // ref.read(orderDateFrom.notifier).update((state) => time);
    } else {
      // ref.read(transactionDateFrom.notifier).update((state) => time);
    }
  }

  // pick dateTime
  void pickDateTo({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    var time = await dateTimePicker(context);
    if (time == '') {
      return;
    }

    if (searchType == SearchDateType.ordersearch) {
      // ref.read(orderDateTo.notifier).update((state) => time);
    } else {
      // ref.read(transactionDateTo.notifier).update((state) => time);
    }
  }

  @override
  Widget build(BuildContext context) {
    // init
    final size = MediaQuery.sizeOf(context);

    return Container(
      width: size.width * 1,
      height: size.height * 0.15,
      padding: const EdgeInsets.symmetric(
        horizontal: AssetsConstants.defaultPadding - 6.0,
        vertical: AssetsConstants.defaultPadding - 15.0,
      ),
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: contentColor),
              SizedBox(width: size.width * 0.05),
              LabelText(
                content: title,
                size: AssetsConstants.defaultFontSize - 10.0,
                color: contentColor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: contentColor,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Consumer(
            builder: (_, ref, __) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => pickDateFrom(ref: ref, context: context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelText(
                        content: 'Từ ngày',
                        size: AssetsConstants.defaultFontSize - 10.0,
                        color: contentColor,
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        children: [
                          LabelText(
                            content: dateFrom,
                            size: AssetsConstants.defaultFontSize - 10.0,
                            color: contentColor,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AssetsConstants.blackColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => pickDateTo(ref: ref, context: context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelText(
                        content: 'Đến ngày',
                        size: AssetsConstants.defaultFontSize - 10.0,
                        color: contentColor,
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        children: [
                          LabelText(
                            content: dateTo,
                            size: AssetsConstants.defaultFontSize - 10.0,
                            color: contentColor,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AssetsConstants.blackColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => onCallBack(),
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: contentColor,
                    size: AssetsConstants.defaultFontSize - 6.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
