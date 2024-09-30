import 'package:flutter/widgets.dart';
import 'package:movemate/features/test/data/models/house_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:movemate/features/test/data/remote/house_source.dart';
import 'package:movemate/features/test/data/repositories/house_type_repository_impl.dart';

part 'house_type_repository.g.dart';

abstract class HouseTypeRepository {
  Future<HouseResponse> getHouseTypeData();
}

@Riverpod(keepAlive: true)
HouseTypeRepository houseTypeRepository(HouseTypeRepositoryRef ref) {
  final houseTypeSource = ref.read(houseSourceProvider);
  return HouseTypeRepositoryImpl(houseTypeSource);
}
