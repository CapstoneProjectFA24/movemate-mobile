// import local
import 'package:movemate/features/test/data/models/house_model.dart';
import 'package:movemate/features/test/data/models/house_response.dart';
import 'package:movemate/features/test/data/remote/house_source.dart';
import 'package:movemate/features/test/domain/repositories/house_type_repository.dart';

// utils
import 'package:movemate/utils/constants/api_constant.dart';
import 'package:movemate/utils/resources/remote_base_repository.dart';
import 'package:retrofit/dio.dart';

class HouseTypeRepositoryImpl extends RemoteBaseRepository
    implements HouseTypeRepository {
  final bool addDelay;
  final HouseSource _houseSource;

  HouseTypeRepositoryImpl(this._houseSource, {this.addDelay = true});

  @override
  Future<HouseResponse> getHouseTypeData() async {
    // check đường dẫn
    // check response 
    
    // Bắt đầu log dữ liệu trước khi gọi API
    print("HouseTypeRepositoryImpl: Start fetching house types...");

    try {
      // Gọi API và log dữ liệu phản hồi
      final response = await getDataOf(
        request: () => _houseSource.getHouseType(
          APIConstants.contentType,
        ),
      );

      // Log phản hồi nhận được từ API
      print("HouseTypeRepositoryImpl: API response received: $response");

      // Log nội dung chi tiết của payload nếu có
      if (response.payload != null) {
        print("HouseTypeRepositoryImpl: Number of houses received: ${response.payload!.length}");
        for (var house in response.payload!) {
          print("HouseTypeRepositoryImpl: House - ID: ${house.id}, Name: ${house.name}, Description: ${house.description}");
        }
      } else {
        print("HouseTypeRepositoryImpl: Payload is null");
      }

      return response;
    } catch (e, stackTrace) {
      // Log lỗi và stack trace nếu xảy ra ngoại lệ
      print("HouseTypeRepositoryImpl: Error fetching house types: $e");
      print(stackTrace);
      // Re-throw exception để xử lý ở tầng cao hơn nếu cần
      rethrow;
    }
  }
}

