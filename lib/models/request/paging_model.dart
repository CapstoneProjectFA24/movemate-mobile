class PagingModel {
  final int pageNumber;
  final int pageSize;
  final String? searchContent;
  final String? sortContent;
  final String? filterContent;
  final String? sortColumn;
  final String? filterSystemContent;
  final String? searchDateFrom;
  final String? searchDateTo;
  final String? type;
  final int? sortDir;
  final int? userId;

  PagingModel({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.searchContent,
    this.sortContent,
    this.sortColumn,
    this.filterContent,
    this.filterSystemContent,
    this.searchDateFrom,
    this.searchDateTo,
    this.type,
    this.sortDir,
    this.userId,
  });
}
