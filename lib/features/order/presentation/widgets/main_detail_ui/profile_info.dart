// components/profile_info.dart

import 'package:flutter/material.dart';
import 'package:movemate/features/order/presentation/widgets/profile_card.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';

class ProfileInfo extends StatelessWidget {
  final ProfileEntity? profileAssign;
  const ProfileInfo({
    required this.profileAssign,
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
            // 'https://storage.googleapis.com/a1aa/image/kQqIOadQcVp4CFdZfMh5llKP6sUMpfDr5KIUucyHmaXaArsTA.jpg',
            profileAssign?.avatarUrl ??
                'https://storage.googleapis.com/a1aa/image/kQqIOadQcVp4CFdZfMh5llKP6sUMpfDr5KIUucyHmaXaArsTA.jpg',
        name: '${profileAssign?.name}',
        // rating: profileAssign?.codeIntroduce ?? '4.5',
        ratingDetails: '${profileAssign?.phone}',
        onPhonePressed: () {
          // Handle phone icon press
        },
        onCommentPressed: () {
          // Handle comment icon press
        },
        iconCall: true,
      ),
    );
  }
}
