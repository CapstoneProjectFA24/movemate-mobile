import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';

import '../../screens/review_screen/review_at_home/review_at_home.dart';
import '../../screens/review_screen/review_online/review_online.dart';

class DailyUIChallengeCard extends ConsumerStatefulWidget {
  const DailyUIChallengeCard({super.key});

  @override
  DailyUIChallengeCardState createState() => DailyUIChallengeCardState();
}

enum AssessmentType { none, home, online }

class DailyUIChallengeCardState extends ConsumerState<DailyUIChallengeCard> {
  AssessmentType assessmentType = AssessmentType.none;
  bool isLoading = false; // Thêm biến trạng thái isLoading

  void selectAssessment(AssessmentType type) {
    setState(() {
      isLoading = true; // Bắt đầu loading
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        assessmentType = type;
        isLoading = false; // Kết thúc loading
      });
    });
  }

  void resetAssessment() {
    setState(() {
      isLoading = true; // Bắt đầu loading
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        assessmentType = AssessmentType.none;
        isLoading = false; // Kết thúc loading
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isInitial = assessmentType == AssessmentType.none;
    final isHome = assessmentType == AssessmentType.home;
    final isOnline = assessmentType == AssessmentType.online;

    String title = 'Thẩm định';
    String description = 'Chọn phương thức thẩm định nhé ?';
    Widget note = const Text(
      'Movemate khuyến nghị bạn nên chọn phương thức thẩm định tại nhà để có thể đảm bảo chất lượng dịch vụ tốt nhất.',
      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
      textAlign: TextAlign.center,
    );
    List<Widget> actionButtons = [];

    if (isHome) {
      title = 'Đánh giá tại nhà';
      description =
          'Hệ thống sẽ lên lịch để nhân viên đến đánh giá tại nhà của bạn nhằm tăng độ chính xác khi chọn dịch vụ chuyển nhà';
      note = const SizedBox.shrink();
      actionButtons = buildConfirmationButtons();
    } else if (isOnline) {
      title = 'Đánh giá trực tuyến';
      description =
          'Để tiết kiệm thời gian hệ thống sẽ\nđánh giá qua hình ảnh và video\nmà bạn cung cấp.\n\nHãy đảm bảo rằng hình ảnh và video\nbạn cung cấp là chính xác';
      note = const SizedBox.shrink();
      actionButtons = buildConfirmationButtons();
    } else {
      actionButtons = buildSelectionButtons();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: containerDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30), // Space for the badge
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: actionButtons,
              ),
              if (isInitial) ...[
                const SizedBox(height: 10),
                note,
              ],
            ],
          ),
        ),
        buildBadge(),
        if (isLoading)
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  List<Widget> buildSelectionButtons() {
    return [
      Expanded(
        child: ElevatedButton(
          onPressed: () => selectAssessment(AssessmentType.home),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text('Tại nhà', style: TextStyle(fontSize: 16)),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: ElevatedButton(
          onPressed: () => selectAssessment(AssessmentType.online),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text('Trực tuyến', style: TextStyle(fontSize: 16)),
        ),
      ),
    ];
  }

  List<Widget> buildConfirmationButtons() {
    return [
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            final bookingNotifier = ref.read(bookingProvider.notifier);
            if (assessmentType == AssessmentType.home) {
              bookingNotifier.updateIsReviewOnline(false);
            } else if (assessmentType == AssessmentType.online) {
              bookingNotifier.updateIsReviewOnline(true);
            }

            // Điều hướng đến màn hình tương ứng
            if (assessmentType == AssessmentType.home) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewAtHome()),
              );
            } else if (assessmentType == AssessmentType.online) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewOnline()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text('Xác nhận', style: TextStyle(fontSize: 16)),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: ElevatedButton(
          onPressed: resetAssessment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.orange),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text('Hủy', style: TextStyle(fontSize: 16)),
        ),
      ),
    ];
  }

  BoxDecoration containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  Positioned buildBadge() {
    return Positioned(
      top: -40,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.orange.shade700,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'MoveMate',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}