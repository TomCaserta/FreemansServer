part of ListOverview;

class ListContainer<T> {
  String name = "";

  List<Syncable> _allNames;

  List<Syncable> get names => (_allNames != null ? _allNames.where((e) => e.isActive).toList() : const []);

  Syncable _activeItem;

  Syncable get activeItem => _activeItem;

  List<String> notifications = new List<String>();

  bool isError = false;

  set activeItem(active) {
    editItem(active);
  }

  StateService stateService;

  bool loading = true;

  bool saved = true;

  bool isAdd = false;

  ListContainer(this.name, this.stateService, this._allNames) {

  }

  void onUpdate() {
    activeItem.update(stateService.wsh).then((ActionResponseServerPacket response) {
      if (response.complete == true) {
        notifications.clear();
        isError = false;
        notifications.add("Updated item successfully!");
        activeItem.mergeJson(response.payload[0]);
      }
      else {
        isError = true;
        notifications.clear();
        response.payload.forEach((v) {
          if (v is String) {
            notifications.add(v);
          }
        });
      }
    });
  }

  void onAdd() {
    activeItem.isActive = true;
    activeItem.insert(stateService.wsh).then((ActionResponseServerPacket response) {
      if (response.complete == true) {
        notifications.clear();
        isError = false;
        notifications.add("Created item successfully!");
        activeItem.mergeJson(response.payload[0]);
        _allNames.add(activeItem);
        newItem();
      } 
      else {
        isError = true;
        notifications.clear();
        response.payload.forEach((v) {
          if (v is String) {
            notifications.add(v);
          }
        });
      }
    });
  }


  void onCancel() {

  }

  void onDelete() {
    activeItem.isActive = false;
    this.onUpdate();
  }

  void processList(bool isNew) {
    if (!isNew && names.length > 0) {
      editItem(names[0]);
    } else {
      newItem();
    }
  }

  void editItem(Syncable item) {
    notifications.clear();
    _activeItem = item;
    isAdd = false;
  }

  void newItem() {
    ClassMirror tm = reflectClass(T);
    activeItem = tm.newInstance(const Symbol(""), []).reflectee;
    isAdd = true;
  }
}

