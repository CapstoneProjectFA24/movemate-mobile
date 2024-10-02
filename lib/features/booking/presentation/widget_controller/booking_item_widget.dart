import 'package:flutter/material.dart';
import 'package:movemate/features/booking/domain/entities/booking_entities.dart';

class BookingItemWidget extends StatelessWidget {
  final BookingEntities booking;

  const BookingItemWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking ID: ${booking.id}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('User ID: ${booking.userId}'),
            Text('House Type ID: ${booking.houseTypeId}'),
            Text('Deposit: ${booking.deposit}'),
            Text('Status: ${booking.status}'),
            Text('Pickup Address: ${booking.pickupAddress}'),
            Text('Pickup Point: ${booking.pickupPoint}'),
            Text('Delivery Address: ${booking.deliveryAddress}'),
            Text('Delivery Point: ${booking.deliveryPoint}'),
            Text('Estimated Distance: ${booking.estimatedDistance}'),
            Text('Total: ${booking.total}'),
            Text('Total Real: ${booking.totalReal}'),
            Text('Estimated Delivery Time: ${booking.estimatedDeliveryTime}'),
            Text('Is Deposited: ${booking.isDeposited}'),
            Text('Is Bonus: ${booking.isBonus}'),
            Text('Is Reported: ${booking.isReported}'),
            Text('Reported Reason: ${booking.reportedReason}'),
            Text('Is Deleted: ${booking.isDeleted}'),
            Text('Review: ${booking.review}'),
            Text('Bonus: ${booking.bonus}'),
            Text('Type Booking: ${booking.typeBooking}'),
            Text('Room Number: ${booking.roomNumber}'),
            Text('Floors Number: ${booking.floorsNumber}'),
            Text('Is Many Items: ${booking.isManyItems}'),
            Text('Is Cancel: ${booking.isCancel}'),
            Text('Cancel Reason: ${booking.cancelReason}'),
            Text('Is Porter: ${booking.isPorter}'),
            Text('Is Round Trip: ${booking.isRoundTrip}'),
            Text('Note: ${booking.note}'),
            Text('Total Fee: ${booking.totalFee}'),
            Text('Booking At: ${booking.bookingAt}'),
            Text('Is Review Online: ${booking.isReviewOnline}'),
          ],
        ),
      ),
    );
  }
}
