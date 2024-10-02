enum CategoryType {
  normal('NORMAL'),
  extra('EXTRA');

  final String type;
  const CategoryType(this.type);
}

extension ConvertCategoryType on String {
  CategoryType toCategoryTypeEnum() {
    switch (this) {
      case 'NORMAL':
        return CategoryType.normal;
      case 'EXTRA':
        return CategoryType.extra;
      default:
        return CategoryType.normal;
    }
  }
}
