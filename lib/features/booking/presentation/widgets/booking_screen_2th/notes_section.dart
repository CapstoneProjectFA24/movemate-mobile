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
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends ConsumerState<NotesSection> {
  final FocusNode _focusNode = FocusNode();
  final Duration _inactiveDuration = const Duration(seconds: 5);
  Timer? _timer;
  bool _isSaved = false;
  bool _isActive = false;
  Color _borderColor = Colors.orange;

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(_inactiveDuration, () {
      setState(() {
        _isSaved = true;
        _isActive = false;
        _borderColor = Colors.grey;
        _focusNode.unfocus();
      });
    });
  }

  void _onTextChanged(String value) {
    setState(() {
      _isSaved = false;
      _isActive = true;
      _borderColor = Colors.orange;
    });
    _startTimer();
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
                  focusNode: _focusNode,
                  enabled: !_isSaved,
                  maxLines: 3,
                  onChanged: (value) {
                    bookingNotifier.updateNotes(value);
                    _onTextChanged(value);
                  },
                  decoration: InputDecoration(
                    hintText: _isSaved ? 'Đã lưu ghi chú' : 'Nhập ghi chú...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _borderColor,
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
