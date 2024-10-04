import 'package:movemate/features/truck/data/models/response/truck_response.dart';
import 'package:movemate/features/truck/data/remote/truck_source.dart';
import 'package:movemate/features/truck/data/repositories/truck_repository_impl.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/widgets.dart';

part 'truck_repository.g.dart';

abstract class TruckRepository {
  Future<TruckResponse> getTrucks({
     required PagingModel request,
  });

}

@Riverpod(keepAlive: true)
TruckRepository truckRepository(TruckRepositoryRef ref) {
  final truckSource = ref.read(truckSourceProvider);
  return TruckRepositoryImpl(truckSource);
}
