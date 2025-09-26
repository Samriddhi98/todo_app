enum FilterOptions {
  all,
  completed,
  notCompleted;

  String get label {
    switch (this) {
      case FilterOptions.all:
        return "All";
      case FilterOptions.completed:
        return "Completed";
      case FilterOptions.notCompleted:
        return "Pending";
    }
  }
}
