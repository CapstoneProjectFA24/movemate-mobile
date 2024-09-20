class PagingModel {
  final int pageNumber;
  final int pageSize;
  final String? searchContent;
  final String? sortContent;
  final String? filterContent;
  final String? filterSystemContent;
  final String? searchDateFrom;
  final String? searchDateTo;

  PagingModel({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.searchContent,
    this.sortContent,
    this.filterContent,
    this.filterSystemContent,
    this.searchDateFrom,
    this.searchDateTo,
  });
}
