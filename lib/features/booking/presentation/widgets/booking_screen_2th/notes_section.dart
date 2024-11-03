import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/booking/presentation/providers/booking_provider.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class NotesSection extends StatefulHookConsumerWidget {
  const NotesSection({super.key});

  @override
  NotesSectionState createState() => NotesSectionState();
}

class NotesSectionState extends ConsumerState<NotesSection> {
  final FocusNode focusNode = FocusNode();
  final Duration inactiveDuration = const Duration(seconds: 5);
  Timer? timer;
  bool isSaved = false;
  bool isActive = false;
  Color borderColor = Colors.orange;

  @override
  void dispose() {
    timer?.cancel();
    focusNode.dispose();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer(inactiveDuration, () {
      setState(() {
        isSaved = true;
        isActive = false;
        borderColor = Colors.grey;
        focusNode.unfocus();
      });
    });
  }

  void onTextChanged(String value) {
    setState(() {
      isSaved = false;
      isActive = true;
      borderColor = Colors.orange;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final textController = TextEditingController(text: bookingState.notes);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInUp(
              child: const LabelText(
                content: 'Ghi chú cho nhân viên',
                size: AssetsConstants.labelFontSize + 6.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FadeInDown(
                child: TextField(
                  controller: textController,
                  focusNode: focusNode,
                  enabled: !isSaved,
                  maxLines: 3,
                  onChanged: (value) {
                    bookingNotifier.updateNotes(value);
                    onTextChanged(value);
                  },
                  decoration: InputDecoration(
                    hintText: isSaved ? 'Đã lưu ghi chú' : 'Nhập ghi chú...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: borderColor,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
