import 'package:movemate/features/testapi/data/models/house_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:movemate/features/testapi/data/remote/house_source.dart';
import 'package:movemate/features/testapi/data/repositories/house_types_repo_impl.dart';

part 'house_type_repository.g.dart';

abstract class HouseTypeRepository {
  Future<HouseResponse> getHousesTypesData({required String accessToken});
}

@Riverpod(keepAlive: true)
HouseTypeRepository houseTypeRepository(HouseTypeRepositoryRef ref) {
  final HouseTypeSource = ref.read(houseSourceProvider);
  return HouseTypesRepoImpl(HouseTypeSource);
}
