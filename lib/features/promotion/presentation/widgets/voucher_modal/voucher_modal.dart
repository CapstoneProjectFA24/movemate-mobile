
import 'package:flutter/material.dart';

class VoucherModal extends StatelessWidget {
  final List<String> vouchers;

  const VoucherModal({Key? key, required this.vouchers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Phiếu giảm giá'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
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
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      leading: const Icon(Icons.card_giftcard),
                      title: Text('Phiếu giảm giá ${index + 1}'),
                      subtitle: const Text('Mô tả phiếu giảm giá'),
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