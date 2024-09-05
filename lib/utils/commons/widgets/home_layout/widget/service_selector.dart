import 'package:flutter/material.dart';

class ServiceSelector extends StatelessWidget {
  const ServiceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(top: 100),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Số dư 0 đ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Từ',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: const [
                      DropdownMenuItem(
                          value: 'Đại học FPT',
                          child: Row(
                            children: [
                              Icon(Icons.add_location_outlined,
                                  color: Colors.orange, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Đại học FPT',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          )),
                      DropdownMenuItem(
                          value: 'Nhà văn hóa',
                          child: Row(
                            children: [
                              Icon(Icons.add_location_outlined,
                                  color: Colors.orange, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Nhà văn hóa',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          )),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Đến',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: const [
                      DropdownMenuItem(
                          value: 'Nhà văn hóa',
                          child: Row(
                            children: [
                              Icon(Icons.add_location_outlined,
                                  color: Colors.orange, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Nhà văn hóa',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          )),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ngày',
                      hintText: '2020/03/27 - 09:00',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'Chọn',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
