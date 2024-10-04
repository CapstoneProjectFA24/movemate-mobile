import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemate/features/test_booking/domain/entities/booking_entities.dart';

class BookingItemWidget extends StatelessWidget {
  final BookingEntities booking;

  const BookingItemWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Format date and currency
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ExpansionTile(
        title: Text(
          'Booking ID: ${booking.id}',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(
          'Status: ${booking.status ?? 'N/A'}',
          style: const TextStyle(color: Colors.grey),
        ),
        leading: Icon(
          Icons.bookmark,
          color: Theme.of(context).primaryColor,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Booking Details
                const SizedBox(height: 8),
                _buildSectionTitle('Booking Details'),
                _buildDetailRow('User ID', booking.userId.toString()),
                _buildDetailRow('Type Booking', booking.typeBooking ?? 'N/A'),
                _buildDetailRow(
                    'Total Fee',
                    booking.totalFee != null
                        ? currencyFormat.format(booking.totalFee)
                        : 'N/A'),
                _buildDetailRow(
                    'Deposit',
                    booking.deposit != null
                        ? currencyFormat.format(booking.deposit)
                        : 'N/A'),
                _buildDetailRow(
                    'Booking At',
                    booking.createdAt != null
                        ? dateFormat.format(booking.createdAt!)
                        : 'N/A'),
                const Divider(),
                // Section: Pickup Information
                _buildSectionTitle('Pickup Information'),
                _buildDetailRow(
                    'Pickup Address', booking.pickupAddress ?? 'N/A'),
                _buildDetailRow('Pickup Point', booking.pickupPoint ?? 'N/A'),
                const Divider(),
                // Section: Delivery Information
                _buildSectionTitle('Delivery Information'),
                _buildDetailRow(
                    'Delivery Address', booking.deliveryAddress ?? 'N/A'),
                _buildDetailRow(
                    'Delivery Point', booking.deliveryPoint ?? 'N/A'),
                const Divider(),
                // Section: Additional Information
                _buildSectionTitle('Additional Information'),
                _buildDetailRow(
                    'Is Porter', booking.isPorter == true ? 'Yes' : 'No'),
                _buildDetailRow('Is Round Trip',
                    booking.isRoundTrip == true ? 'Yes' : 'No'),
                _buildDetailRow('Note', booking.note ?? 'None'),
                const Divider(),
                // Section: Status Information
                _buildSectionTitle('Status Information'),
                _buildDetailRow(
                    'Is Deposited', booking.isDeposited == true ? 'Yes' : 'No'),
                _buildDetailRow(
                    'Is Cancelled', booking.isCancel == true ? 'Yes' : 'No'),
                if (booking.isCancel == true)
                  _buildDetailRow(
                      'Cancel Reason', booking.cancelReason ?? 'N/A'),
                _buildDetailRow(
                    'Is Reported', booking.isReported == true ? 'Yes' : 'No'),
                if (booking.isReported == true)
                  _buildDetailRow(
                      'Reported Reason', booking.reportedReason ?? 'N/A'),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, top: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
