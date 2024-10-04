import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/utils/enums/enums_export.dart';

class FetchObject<T> {
  final Future<T?> Function(BuildContext context) function;

  FetchObject({required this.function});

  Future<void> fetchData({
    required GetDataType getDataType,
    required BuildContext context,
    required ValueNotifier<T?> data,
    required ValueNotifier<bool> isFetchingData,
  }) async {
    if (getDataType == GetDataType.loadmore && isFetchingData.value) {
      return;
    }

    if (getDataType == GetDataType.fetchdata) {
      data.value = null;
    }

    isFetchingData.value = true;
    
    final fetchedData = await function(context);
    
    if (getDataType == GetDataType.fetchdata) {
      data.value = fetchedData;
    }

    isFetchingData.value = false;
  }
}

class FetchObjectResult<T> {
  final T? data;
  final bool isFetchingData;
  final VoidCallback refresh;

  FetchObjectResult({
    required this.data,
    required this.isFetchingData,
    required this.refresh,
  });
}

FetchObjectResult<T> useFetchObject<T>({
  required Future<T?> Function(BuildContext context) function,
  required BuildContext context,
}) {
  final data = useState<T?>(null);
  final isFetchingData = useState(true);

  final fetch = useMemoized(() => FetchObject<T>(function: function), [function]);
 
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch.fetchData(
        getDataType: GetDataType.fetchdata,
        context: context,
        data: data,
        isFetchingData: isFetchingData,
      );
    });
    return null;
  }, []);

  return FetchObjectResult<T>(
    data: data.value,
    isFetchingData: isFetchingData.value,
    refresh: () {
      fetch.fetchData(
        getDataType: GetDataType.fetchdata,
        context: context,
        data: data,
        isFetchingData: isFetchingData,
      );
    },
  );
}

      // VÍ DỤ DƯỚI ĐÂY LÀ OPTIONAL có thể có data truyền 
            //vô function cũng dc hoặc ko

// sử dụng trong screen thì => 
    // final useFetchResult = useFetchObject<TestModel>(
    //   function: (context) => ref.read(testControllerProvider.notifier).getTest(context: context),
    //   context: context,
    // );

              // HOẶC

  // final useFetchResult = useFetchObject<TestModel>(
  //     function: (context) => ref.read(testControllerProvider.notifier).getTest(
  //           context: context,
  //           profile: useState<TestModel?>(null),
  //         ),
  //     context: context,
  //   );