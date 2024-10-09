import 'package:movemate/features/booking/data/models/response/house_type_response.dart';
import 'package:movemate/features/booking/data/remote/house_type_source.dart';
import 'package:movemate/features/booking/data/repositories/house_type_repository_impl.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'house_type_repository.g.dart';

abstract class HouseTypeRepository {
  Future<HouseTypeResponse> getHouseTypes({
    // required String accessToken,
    required PagingModel request,
  });
}

@Riverpod(keepAlive: true)
HouseTypeRepository houseTypeRepository(HouseTypeRepositoryRef ref) {
  final houseTypeSource = ref.read(houseTypeSourceProvider);
  return HouseTypeRepositoryImpl(houseTypeSource);
}
