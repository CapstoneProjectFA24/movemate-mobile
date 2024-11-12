// booking_screen_service.dart
//route
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/configs/routes/app_router.dart';
//entity
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/service_package_tile.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/check_list_section.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/notes_section.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/round_trip_checkbox.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/summary_section.dart';
//hook & extentions
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

import '../widgets/booking_screen_2th/review_options.dart';

@RoutePage()
class BookingScreenService extends HookConsumerWidget {
  const BookingScreenService({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final bookingState = ref.watch(bookingProvider);
    final bookingStatePrice = ref.watch(bookingResponseProviderPrice);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final state = ref.watch(servicePackageControllerProvider);
    final double? price = bookingState.totalPrice;

    final fetchResult = useFetch<ServicesPackageEntity>(
      function: (model, context) async {
        final result = await ref
            .read(servicePackageControllerProvider.notifier)
            .servicePackage(model, context);
        return result; // Ensure this returns data
      },
      initialPagingModel: PagingModel(
        sortColumn: '1',
      ),
      context: context,
    );
    // Shared method to show the confirmation dialog
    void showConfirmationDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: DailyUIChallengeCard(
                isReviewOnline: bookingState.isReviewOnline),
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chọn các dịch vụ',
        backgroundColor: AssetsConstants.primaryMain,
        backButtonColor: AssetsConstants.whiteColor,
        centerTitle: true,
        showBackButton: true,
        onCallBackFirst: () {
          // context.router.pop();
          bookingNotifier.resetAllQuantities();
          // context.router.pushAndPopUntil(const BookingScreenRoute(),
          //     predicate: (Route<dynamic> route) => false);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // SizedBox(height: size.height * 0.01),
                  if (state.isLoading && fetchResult.items.isEmpty)
                    const Center(
                      child: HomeShimmer(amount: 4),
                    )
                  else if (fetchResult.items.isEmpty)
                    const Align(
                      alignment: Alignment.topCenter,
                      child: EmptyBox(title: 'Không có dịch vụ hiện tại'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: fetchResult.items.length + 1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AssetsConstants.defaultPadding - 15.0,
                      ),
                      itemBuilder: (_, index) {
                        if (index == fetchResult.items.length) {
                          if (fetchResult.isFetchingData) {
                            return const CustomCircular();
                          }
                          return fetchResult.isLastPage
                              ? const SizedBox.shrink()
                              : Container();
                        }
                        final package = fetchResult.items[index];
                        return ServicePackageTile(servicePackage: package);
                        // return ServicePackageList(servicePackages: servicePackages);
                      },
                    ),
                  const SizedBox(height: 16),

                  RoundTripCheckbox(
                    isRoundTrip: bookingState.isRoundTrip,
                    onChanged: (value) async {
                      bookingNotifier.updateRoundTrip(value ?? false);
                      // bookingNotifier.calculateAndUpdateTotalPrice();
                      final bookingResponse = await ref
                          .read(servicePackageControllerProvider.notifier)
                          .postValuationBooking(
                            context: context,
                          );

                      if (bookingResponse != null) {
                        try {
                          // Chuyển đổi BookingResponseEntity thành Booking
                          final bookingtotal = bookingResponse.total;
                          final bookingdeposit = bookingResponse.deposit;
                          bookingNotifier
                              .updateBookingResponse(bookingResponse);
                          bookingNotifier.calculateAndUpdateTotalPrice();
                          print(
                              'tuan bookingEntity  total rouchip : $bookingtotal');
                          print(
                              'tuan bookingEntity  deposit : $bookingdeposit');
                          print(
                              'tuan bookingResponse: ${bookingResponse.bookingDetails.toString()}');
                          print(
                              'tuan bookingResponse: ${bookingResponse.feeDetails.toString()}');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã xảy ra lỗi: $e')),
                          );
                        }
                      } else {
                        // Xử lý khi bookingResponse là null
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Đặt hàng thất bại. Vui lòng thử lại.')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const ChecklistSection(),
                  const SizedBox(height: 16),
                  const NotesSection(),
                  // const DailyUIChallengeCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SummarySection(
        buttonIcon: true,
        totalPrice: bookingStatePrice?.total ?? 0,
        isButtonEnabled: true,
        onPlacePress: () {
          print("check review ${bookingState.isReviewOnline}");
          showConfirmationDialog();
        },
        buttonText: 'Đặt đơn',
        priceLabel: 'Tổng giá',
        onConfirm: () {
          print("check review ${bookingState.isReviewOnline}");
          Navigator.pop(context);
          showConfirmationDialog();
        },
      ),
    );
  }
}
