import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool isLastPage;
  final int currentPage;
  final ScrollController scrollController;

  const PaginationState({
    required this.items,
    required this.isLoading,
    required this.isLastPage,
    required this.currentPage,
    required this.scrollController,
  });
}

typedef FetchFunction<T> = Future<List<T>> Function(int page);

PaginationState<T> usePagination<T>({
  required FetchFunction<T> fetchFunction,
  required void Function() onRefresh,
}) {
  final items = useState<List<T>>([]);
  final isLoading = useState(true);
  final isLastPage = useState(false);
  final currentPage = useState(0);
  final scrollController = useScrollController();

  Future<void> fetchData({bool isRefresh = false}) async {
    if (isLoading.value && !isRefresh) return;
    if (isLastPage.value && !isRefresh) return;

    isLoading.value = true;
    
    try {
      final page = isRefresh ? 1 : currentPage.value + 1;
      final newItems = await fetchFunction(page);
      
      if (isRefresh) {
        items.value = newItems;
        currentPage.value = 1;
        isLastPage.value = false;
      } else {
        items.value = [...items.value, ...newItems];
        currentPage.value = page;
      }
      
      isLastPage.value = newItems.length < 10; // Assuming page size is 10
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData(isRefresh: true);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >= 
          scrollController.position.maxScrollExtent - 200) {
        fetchData();
      }
    });

    return () => scrollController.dispose();
  }, const []);

  return PaginationState(
    items: items.value,
    isLoading: isLoading.value,
    isLastPage: isLastPage.value,
    currentPage: currentPage.value,
    scrollController: scrollController,
  );
}