// components/profile_info.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/order/presentation/widgets/profile_card.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
  });

  // You can pass data as parameters if needed

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ProfileCard(
        title: "Thông tin người đánh giá",
        profileImageUrl:
            'https://storage.googleapis.com/a1aa/image/kQqIOadQcVp4CFdZfMh5llKP6sUMpfDr5KIUucyHmaXaArsTA.jpg',
        name: 'Lê Văn Phước Đại',
        rating: 5.0,
        ratingDetails: '73-H1 613.58',
        onPhonePressed: () {
          // Handle phone icon press
        },
        onCommentPressed: () {
          // Handle comment icon press
        },
      ),
    );
  }
}
