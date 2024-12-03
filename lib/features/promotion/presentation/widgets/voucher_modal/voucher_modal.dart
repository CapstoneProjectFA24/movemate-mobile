import 'package:flutter/material.dart';
import 'package:movemate/utils/commons/widgets/form_input/label_text.dart';
import 'package:movemate/utils/constants/asset_constant.dart';

class VoucherModal extends StatefulWidget {
  final List<String> vouchers;

  const VoucherModal({super.key, required this.vouchers});

  @override
  _VoucherModalState createState() => _VoucherModalState();
}

class _VoucherModalState extends State<VoucherModal> {
  final TextEditingController _controller = TextEditingController();
  bool _isApplyButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự thay đổi của TextField
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {
      // Nút "Áp dụng" sẽ bị disable khi độ dài > 4
      _isApplyButtonEnabled = _controller.text.length >= 4;
    });
  }

  void _clearTextField() {
    _controller.clear();
  }

  void _applyVoucher() {
    // Xử lý khi nhấn nút "Áp dụng"
    String voucherCode = _controller.text;
    // Thêm logic áp dụng voucher ở đây
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã áp dụng mã voucher: $voucherCode'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const LabelText(
              content: 'Phiếu giảm giá',
              size: AssetsConstants.labelFontSize * 1.4,
              fontWeight: FontWeight.w600,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Expanded TextField để chiếm hết không gian còn lại
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Nhập mã MoveMate voucher',
                          prefixIcon: const Icon(Icons.percent),
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _clearTextField,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Nút "Áp dụng"
                    ElevatedButton(
                      onPressed: _isApplyButtonEnabled ? _applyVoucher : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isApplyButtonEnabled
                            ? Colors.grey.shade500
                            : Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 0.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        minimumSize:
                            const Size(0, 48), // Chiều cao bằng TextField
                      ),
                      child: Text(
                        'Áp dụng',
                        style: TextStyle(
                          color: !_isApplyButtonEnabled
                              ? Colors.grey.shade400
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: List.generate(10, (index) {
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.card_giftcard,
                                color: Colors.amberAccent,
                                size: 40.0,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phiếu giảm giá ${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      'Mô tả phiếu giảm giá',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  // Xử lý khi nhấn nút "Sử dụng"
                                  // Bạn có thể thêm hành động ở đây
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.orange.shade700,
                                      content: Text(
                                        'Đã sử dụng phiếu giảm giá ${index + 1}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange, // Màu nền cam
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Text(
                                  'Sử dụng',
                                  style: TextStyle(
                                    color: Colors.white, // Màu chữ trắng
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
