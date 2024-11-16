// components/profile_info.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movemate/features/order/presentation/widgets/profile_card.dart';
import 'package:movemate/features/profile/domain/entities/profile_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/hooks/use_fetch_obj.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';

class ProfilePosterInfo extends HookConsumerWidget {
  final int id;
  // final ProfileEntity? profileAssign;
  const ProfilePosterInfo({
    // required this.profileAssign,
    required this.id,
    super.key,
  });

  // You can pass data as parameters if needed

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final useFetchResultProfileAssign = useFetchObject<ProfileEntity>(
      function: (context) async {
        return ref
            .read(profileControllerProvider.notifier)
            .getProfileInforById(id, context);
      },
      context: context,
    );
    final profilePoster = useFetchResultProfileAssign.data;

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ProfileCard(
          // title: "Thông tin người đánh giá",
          profileImageUrl:
              profilePoster?.avatarUrl ??
                  'https://storage.googleapis.com/a1aa/image/kQqIOadQcVp4CFdZfMh5llKP6sUMpfDr5KIUucyHmaXaArsTA.jpg',
          name: '${profilePoster?.name}',
          // rating: profilePoster?.codeIntroduce ?? '4.5',
          ratingDetails: '${profilePoster?.phone}',
          onPhonePressed: () {
            // Handle phone icon press
          },
          onCommentPressed: () {
            // Handle comment icon press
          },
          iconCall: true,
          iconLocation: true,
        ),
      ),
    );
  }
}
