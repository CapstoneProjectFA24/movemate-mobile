import 'package:flutter/material.dart';

class VoucherModal extends StatelessWidget {
  final List<String> vouchers;

  const VoucherModal({super.key, required this.vouchers});

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
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.card_giftcard,
                        color: Colors.amberAccent,
                      ),
                      title: Text(
                        'Phiếu giảm giá ${index + 1}',
                        style: const TextStyle(color: Colors.black),
                      ),
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
