enum ActionTypes {
  cancel,
  create,
  update,
  delete,
}

class NavigationData<T> {
  NavigationData({
    this.data,
    required this.actionType,
  });

  T? data;
  ActionTypes actionType;
}
