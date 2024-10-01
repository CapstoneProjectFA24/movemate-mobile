// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:movemate/models/request/paging_model.dart';
// import 'package:movemate/utils/enums/enums_export.dart';

// class FetchData<T> {
//   final Future<List<T>> Function(PagingModel model, BuildContext context)
//       function;

//   FetchData({required this.function});

//   Future<void> fetchData({
//     required GetDataType getDataType,
//     required BuildContext context,
//     required ValueNotifier<int> pageNumber,
//     required ValueNotifier<bool> isLastPage,
//     required ValueNotifier<bool> isLoadMoreLoading,
//     required ValueNotifier<List<T>> items,
//     required ValueNotifier<bool> isFetchingData,
//     required PagingModel pagingModel,
//     required String? filterSystemContent,
//     required String? filterPartnerContent,
//     required String? dateFrom,
//     required String? dateTo,
//   }) async {
//     if (getDataType == GetDataType.loadmore && isFetchingData.value) {
//       return;
//     }

//     if (getDataType == GetDataType.fetchdata) {
//       pageNumber.value = 0;
//       isLastPage.value = false;
//       isLoadMoreLoading.value = false;
//     }

//     if (isLastPage.value) {
//       return;
//     }

//     isFetchingData.value = true;
//     pageNumber.value = pageNumber.value + 1;

//     final fetchedItems = await function(
//       PagingModel(
//         pageNumber: pageNumber.value,
//         // filterSystemContent: filterSystemContent,
//         // filterContent: filterPartnerContent,
//         // searchDateFrom: orderDateFrom,
//         // searchDateTo: orderDateTo,
//       ),
//       context,
//     );
//     isLastPage.value = fetchedItems.length < pagingModel.pageSize;
//     if (getDataType == GetDataType.fetchdata) {
//       isLoadMoreLoading.value = true;
//       items.value = fetchedItems;
//     } else {
//       items.value = [...items.value, ...fetchedItems];
//     }

//     isFetchingData.value = false;
//   }
// }


// T useFetch<T> ({
//     required Future<List<T>> Function(PagingModel model, BuildContext context) fetchFunction,
//   required PagingModel initialPagingModel,
//   required BuildContext context,
// }){

// }
