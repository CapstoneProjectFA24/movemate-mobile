import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/commons/widgets/form_input/search_time_box.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// chú ý code import ở 2 đây flow đấy
import 'package:movemate/utils/resources/string_enum_convert.dart';
import 'package:movemate/utils/enums/enums_export.dart';

// lấy datetime từ trên tầng screen
// import '../../../features/order/presentation/order_list/order_screen.dart';

import 'package:movemate/features/test/presentation/screens/test_screen/test_screen.dart';

final optionsSystemStatus = [
  OrderSystemStatusType.instore,
  OrderSystemStatusType.readydelivery,
  OrderSystemStatusType.completed,
  OrderSystemStatusType.cancelled
];

final filterSystemStatus = StateProvider.autoDispose<OrderSystemStatusType>(
  (ref) => OrderSystemStatusType.instore,
);

final optionsPartnerStatus = [
  OrderPartnerStatusType.upcoming,
  OrderPartnerStatusType.preparing,
  OrderPartnerStatusType.ready,
  OrderPartnerStatusType.completed,
  OrderPartnerStatusType.cancelled,
];

final filterPartnerStatus = StateProvider.autoDispose<OrderPartnerStatusType>(
  (ref) => OrderPartnerStatusType.preparing,
);

showCustomBottomSheet({
  required BuildContext context,
  required Size size,
  required VoidCallback onCallback,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AssetsConstants.defaultPadding - 10.0,
        ),
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          color: AssetsConstants.scaffoldColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AssetsConstants.defaultBorder + 10.0),
            topRight: Radius.circular(AssetsConstants.defaultBorder + 10.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.filter_alt_rounded,
                        color: AssetsConstants.blackColor,
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      const LabelText(
                        content: 'Lọc',
                        size: AssetsConstants.defaultFontSize - 10.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.router.pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AssetsConstants.blackColor,
                    ),
                  )
                ],
              ),
              Consumer(
                builder: (_, ref, __) => SearchTimeBox(
                  searchType: SearchDateType.ordersearch,
                  dateFrom: ref.watch(testDateFrom),
                  dateTo: ref.watch(testDateTo),
                  borderColor: AssetsConstants.borderColor,
                  title: 'Tra cứu đơn hàng',
                  icon: Icons.shopping_bag_rounded,
                  contentColor: AssetsConstants.blackColor,
                  backGroundColor: AssetsConstants.whiteColor,
                  onCallBack: () {
                    onCallback();
                    context.router.pop();
                  },
                ),
              ),
              SizedBox(height: size.height * 0.01),
              const LabelText(
                content: 'Trạng thái hệ thống',
                fontWeight: FontWeight.w600,
                size: AssetsConstants.defaultFontSize - 10.0,
              ),
              SizedBox(height: size.height * 0.01),
              Consumer(
                builder: (_, ref, __) => Container(
                  decoration: BoxDecoration(
                    color: AssetsConstants.revenueBackground,
                    border: Border.all(
                      color: AssetsConstants.mainColor,
                    ),
                    borderRadius: BorderRadius.circular(
                      AssetsConstants.defaultBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      RadioListTile(
                        title: LabelText(
                          content: getTitleSystemStatus(
                            OrderSystemStatusType.instore,
                          ),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsSystemStatus[0],
                        groupValue: ref.watch(filterSystemStatus),
                        onChanged: (val) {
                          ref
                              .read(filterSystemStatus.notifier)
                              .update((state) => optionsSystemStatus[0]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                      RadioListTile(
                        title: LabelText(
                          content: getTitleSystemStatus(
                            OrderSystemStatusType.readydelivery,
                          ),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsSystemStatus[1],
                        groupValue: ref.watch(filterSystemStatus),
                        onChanged: (val) {
                          ref
                              .read(filterSystemStatus.notifier)
                              .update((state) => optionsSystemStatus[1]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                      RadioListTile(
                        title: LabelText(
                          content: getTitleSystemStatus(
                              OrderSystemStatusType.completed),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsSystemStatus[2],
                        groupValue: ref.watch(filterSystemStatus),
                        onChanged: (val) {
                          ref
                              .read(filterSystemStatus.notifier)
                              .update((state) => optionsSystemStatus[2]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                      RadioListTile(
                        title: LabelText(
                          content: getTitleSystemStatus(
                              OrderSystemStatusType.cancelled),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsSystemStatus[3],
                        groupValue: ref.watch(filterSystemStatus),
                        onChanged: (val) {
                          ref
                              .read(filterSystemStatus.notifier)
                              .update((state) => optionsSystemStatus[3]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              const LabelText(
                content: 'Trạng thái đối tác',
                fontWeight: FontWeight.w600,
                size: AssetsConstants.defaultFontSize - 10.0,
              ),
              SizedBox(height: size.height * 0.01),
              Consumer(
                builder: (_, ref, __) => Container(
                  decoration: BoxDecoration(
                    color: AssetsConstants.revenueBackground,
                    border: Border.all(
                      color: AssetsConstants.mainColor,
                    ),
                    borderRadius: BorderRadius.circular(
                      AssetsConstants.defaultBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      RadioListTile(
                        title: LabelText(
                          content: getTitlePartnerStatus(
                            OrderPartnerStatusType.upcoming,
                          ),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsPartnerStatus[0],
                        groupValue: ref.watch(filterPartnerStatus),
                        onChanged: (val) {
                          ref
                              .read(filterPartnerStatus.notifier)
                              .update((state) => optionsPartnerStatus[0]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                      RadioListTile(
                        title: LabelText(
                          content: getTitlePartnerStatus(
                            OrderPartnerStatusType.preparing,
                          ),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsPartnerStatus[1],
                        groupValue: ref.watch(filterPartnerStatus),
                        onChanged: (val) {
                          ref
                              .read(filterPartnerStatus.notifier)
                              .update((state) => optionsPartnerStatus[1]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                      RadioListTile(
                        title: LabelText(
                          content: getTitlePartnerStatus(
                            OrderPartnerStatusType.ready,
                          ),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsPartnerStatus[2],
                        groupValue: ref.watch(filterPartnerStatus),
                        onChanged: (val) {
                          ref
                              .read(filterPartnerStatus.notifier)
                              .update((state) => optionsPartnerStatus[2]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                      RadioListTile(
                        title: LabelText(
                          content: getTitlePartnerStatus(
                            OrderPartnerStatusType.completed,
                          ),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsPartnerStatus[3],
                        groupValue: ref.watch(filterPartnerStatus),
                        onChanged: (val) {
                          ref
                              .read(filterPartnerStatus.notifier)
                              .update((state) => optionsPartnerStatus[3]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                      RadioListTile(
                        title: LabelText(
                          content: getTitlePartnerStatus(
                            OrderPartnerStatusType.cancelled,
                          ),
                          size: AssetsConstants.defaultFontSize - 10.0,
                        ),
                        value: optionsPartnerStatus[4],
                        groupValue: ref.watch(filterPartnerStatus),
                        onChanged: (val) {
                          ref
                              .read(filterPartnerStatus.notifier)
                              .update((state) => optionsPartnerStatus[4]);
                        },
                        activeColor: AssetsConstants.mainColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      );
    },
  );
}
