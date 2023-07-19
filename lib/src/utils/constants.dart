enum ActionTypes {
  cancel,
  create,
  update,
  delete,
}

enum ChatTypes {
  team,
  request,
  invite,
}

class NavigationData<T> {
  NavigationData({
    this.data,
    required this.actionType,
  });

  T? data;
  ActionTypes actionType;
}
