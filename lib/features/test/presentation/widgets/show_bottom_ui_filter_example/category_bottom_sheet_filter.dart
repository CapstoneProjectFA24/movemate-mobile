import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../utils/enums/enums_export.dart';


import 'package:movemate/utils/commons/functions/functions_common_export.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

// 2 đoạn import này coi kĩ flow đấy
import 'package:movemate/utils/enums/enums_export.dart';
import 'package:movemate/utils/resources/string_enum_convert.dart';


final options = [
  CategoryType.normal,
  CategoryType.extra,
];

final categoryFilterProvider = StateProvider.autoDispose<CategoryType>(
  (ref) => CategoryType.normal,
);

categoryBottomSheetFilter({
  required BuildContext context,
  required Size size,
  required VoidCallback onCallback,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AssetsConstants.defaultPadding - 10.0,
        ),
        height: size.height * 0.6,
        width: size.width * 1,
        decoration: const BoxDecoration(
          color: AssetsConstants.scaffoldColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AssetsConstants.defaultBorder + 10.0),
            topRight: Radius.circular(AssetsConstants.defaultBorder + 10.0),
          ),
        ),
        child: Consumer(
          builder: (_, ref, __) => Column(
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
              Container(
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
                        content: getTitleCategoryType(CategoryType.normal),
                        size: AssetsConstants.defaultFontSize - 10.0,
                      ),
                      value: options[0],
                      groupValue: ref.watch(categoryFilterProvider),
                      onChanged: (val) {
                        ref
                            .read(categoryFilterProvider.notifier)
                            .update((state) => options[0]);
                        onCallback();
                        context.router.pop();
                      },
                      activeColor: AssetsConstants.mainColor,
                    ),
                    RadioListTile(
                      title: LabelText(
                        content: getTitleCategoryType(CategoryType.extra),
                        size: AssetsConstants.defaultFontSize - 10.0,
                      ),
                      value: options[1],
                      groupValue: ref.watch(categoryFilterProvider),
                      onChanged: (val) {
                        ref
                            .read(categoryFilterProvider.notifier)
                            .update((state) => options[1]);
                        onCallback();
                        context.router.pop();
                      },
                      activeColor: AssetsConstants.mainColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      );
    },
  );
}
