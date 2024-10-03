import 'package:flutter/widgets.dart';
import 'package:movemate/features/test/data/models/response/house_response.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:movemate/features/test/data/remote/house_source.dart';
import 'package:movemate/features/test/data/repositories/house_type_repository_impl.dart';

part 'house_type_repository.g.dart';

abstract class HouseTypeRepository {
  Future<HouseResponse> getHouseTypeData(
    {
    // required String accessToken,
    required PagingModel request,
  }
  );
}

@Riverpod(keepAlive: true)
HouseTypeRepository houseTypeRepository(HouseTypeRepositoryRef ref) {
  final houseTypeSource = ref.read(houseSourceProvider);
  return HouseTypeRepositoryImpl(houseTypeSource);
}
