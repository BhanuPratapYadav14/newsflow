enum NewsCategory {
  general,
  business,
  entertainment,
  health,
  science,
  sports,
  technology,
}

extension NewsCategoryX on NewsCategory {
  String get value => name; // matches API's lowercase string exactly

  String get label {
    switch (this) {
      case NewsCategory.general:
        return 'General';
      case NewsCategory.business:
        return 'Business';
      case NewsCategory.entertainment:
        return 'Entertainment';
      case NewsCategory.health:
        return 'Health';
      case NewsCategory.science:
        return 'Science';
      case NewsCategory.sports:
        return 'Sports';
      case NewsCategory.technology:
        return 'Technology';
    }
  }
}