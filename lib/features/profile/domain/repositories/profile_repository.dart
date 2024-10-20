// local
import 'package:movemate/features/profile/data/remote/profile_source.dart';

// system
import 'package:movemate/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'profile_repository.g.dart';

abstract class ProfileRepository {
  // Future<HouseResponse> getHouseTypeData();

}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final profileSource = ref.read(profileSourceProvider);
  return ProfileRepositoryImpl(profileSource);
}
