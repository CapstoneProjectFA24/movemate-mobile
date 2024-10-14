import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceSuggestionScreen extends StatelessWidget {
  const ServiceSuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 375,
            height: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
                SizedBox(height: 20),
                AppointmentTime(),
                SizedBox(height: 10),
                Description(),
                SizedBox(height: 20),
                ContactSection(),
                SizedBox(height: 20),
                Buttons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(FontAwesomeIcons.chevronLeft, size: 20),
        Text(
          'Gợi ý dịch vụ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 20), // Placeholder for space on the right
      ],
    );
  }
}

class AppointmentTime extends StatelessWidget {
  const AppointmentTime({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Lịch hẹn với người đánh giá',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFF6600),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '8:00am',
          style: TextStyle(
            color: Color(0xFFFF6600),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Nhằm nâng cao tính chính xác của dịch vụ chúng tôi đề cử nhân viên đến xem xét',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF666666),
        fontSize: 14,
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Liên hệ với nhân viên',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ContactInfo(),
      ],
    );
  }
}

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              'https://storage.googleapis.com/a1aa/image/p5OKRdzupwITHJRADxe2zVw1ETxmkRfWfQZKa5mhRMjVmAMnA.jpg'),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoàng Văn Huy',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(FontAwesomeIcons.solidStar, color: Colors.amber, size: 12),
                SizedBox(width: 5),
                Text(
                  '5.0 • 61-N1 162.32',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 10),
        Icon(FontAwesomeIcons.phone, size: 18, color: Color(0xFF666666)),
        SizedBox(width: 10),
        Icon(FontAwesomeIcons.comment, size: 18, color: Color(0xFF666666)),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ActionButton(
          text: 'Thay đổi lịch hẹn',
          color: Colors.white,
          borderColor: Color(0xFFFF6600),
          textColor: Color(0xFFFF6600),
        ),
        ActionButton(
          text: 'Xác nhận',
          color: Color(0xFFFF6600),
          textColor: Colors.white,
        ),
        ActionButton(
          text: 'Hủy',
          color: Colors.white,
          borderColor: Color(0xFF666666),
          textColor: Color(0xFF666666),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Color? borderColor;

  const ActionButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          iconColor: textColor,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () {
          // Handle button press here
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
