import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/services_package_entity.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/features/booking/presentation/screens/controller/service_package_controller.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/booking_package/sub_service_tile.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/service_trailing_widget.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class ServicePackageTile extends StatefulWidget {
  final ServicesPackageEntity servicePackage;

  const ServicePackageTile({
    super.key,
    required this.servicePackage,
  });

  @override
  _ServicePackageTileState createState() => _ServicePackageTileState();
}

class _ServicePackageTileState extends State<ServicePackageTile> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    //phần dịch vụ lớn => có dịch vụ con
    if (widget.servicePackage.inverseParentService.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: _isExpanded
            ? null
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: const Border(
                  bottom:
                      BorderSide(color: AssetsConstants.primaryDark, width: 2),
                ),
              ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() => _isExpanded = expanded);
            },
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            title: Text(
              widget.servicePackage.name.trim(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
            // subtitle: Text(
            //   widget.servicePackage.description,
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey[600],
            //   ),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (widget.servicePackage.discountRate > 0)
                //   Container(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                //     decoration: BoxDecoration(
                //       color: Colors.redAccent,
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: Text(
                //       '-${widget.servicePackage.discountRate}%',
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 13,
                //       ),
                //     ),
                //   ),
                // const SizedBox(width: 12),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: FaIcon(
                    _isExpanded
                        ? FontAwesomeIcons.circleChevronDown
                        : FontAwesomeIcons.circleChevronUp,
                    color: _isExpanded
                        ? AssetsConstants.greyColor
                        : AssetsConstants.primaryDark,
                    size: 20,
                  ),
                ),
              ],
            ),
            children:
                widget.servicePackage.inverseParentService.map((subService) {
              return SubServiceTile(subService: subService);
            }).toList(),
          ),
        ),
      );
    }
// phần dịch vụ nhỏ => không có dịch vụ con
    else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
          // border: const Border(
          //   bottom: BorderSide(color: AssetsConstants.primaryLighter, width: 1),
          // ),
        ),
        child: Consumer(builder: (context, ref, _) {
          final bookingNotifier = ref.read(bookingProvider.notifier);
          final bookingState = ref.watch(bookingProvider);

          final currentPackage = bookingState.selectedPackages.firstWhere(
            (p) => p.id == widget.servicePackage.id,
            orElse: () => widget.servicePackage.copyWith(quantity: 0),
          );

          final int quantity = currentPackage.quantity ?? 0;

          return ListTile(
            // contentPadding:
            //     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              widget.servicePackage.name.trim(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Text(
                widget.servicePackage.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: ServiceTrailingWidget(
              quantity: quantity,
              addService: true,
              onQuantityChanged: (newQuantity) async {
                bookingNotifier.updateServicePackageQuantity(
                    widget.servicePackage, newQuantity);
                bookingNotifier.calculateAndUpdateTotalPrice();

                final bookingResponse = await ref
                    .read(servicePackageControllerProvider.notifier)
                    .postValuationBooking(
                      context: context,
                    );

                // bookingNotifier.calculateAndUpdateTotalPrice();
                if (bookingResponse != null) {
                  try {
                    // Chuyển đổi BookingResponseEntity thành Booking
                    final bookingtotal = bookingResponse.total;
                    final bookingdeposit = bookingResponse.deposit;
                    bookingNotifier.updateBookingResponse(bookingResponse);
                    print('tuan bookingEntity  total : $bookingtotal');
                    print('tuan bookingEntity  deposit : $bookingdeposit');
                    print(
                        'tuan bookingResponse: ${bookingResponse.bookingDetails.toString()}');
                    print(
                        'tuan bookingResponse: ${bookingResponse.feeDetails.toString()}');

                    // Xóa bookingState sau khi đã đăng ký thành công
                    // bookingNotifier.reset();
                  } catch (e) {
                    // Xử lý ngoại lệ nếu chuyển đổi thất bại

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã xảy ra lỗi: $e')),
                    );
                  }
                } else {
                  // Xử lý khi bookingResponse là null
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Đặt hàng thất bại. Vui lòng thử lại.')),
                  );
                }
              },
            ),
          );
        }),
      );
    }
  }
}
