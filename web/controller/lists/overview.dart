part of FreemansClient;

@NgController(
    selector: '[listoverview]',
    publishAs: 'listoverview'
)
class ListEditor {
  List<ListContainer> lists = new List<ListContainer>();
  ListContainer activeList;
  Element scopeElem;
  bool isAdd = false;
  Scope scope;
  
  String listNameUnconfirmed = "";
  bool isAddUnconfirmed = false;
  bool isSaveDialogShown = false;
  ListEditor(StateService state, Element scopeElem, Scope this.scope) {
    this.scopeElem = scopeElem;
    lists.add(new ListContainer("Customer"));
    lists.add(new ListContainer("Suppliers"));
    lists.add(new ListContainer("Transport"));
    lists.add(new ListContainer("Products"));
    lists.add(new ListContainer("Weights"));
    lists.add(new ListContainer("Packaging"));
    lists.add(new ListContainer("Terms"));
    lists.add(new ListContainer("Users"));
  }
  void confirmedViewChange ([String listName, bool isNew]) {
    isSaveDialogShown = false;
    activeList = lists.where((e) => e.name == listName).first;
    isAdd = isNew;
  }
  
  void closeDialog () {
    isSaveDialogShown = false;
  }
  
  void changeView (String listName, [bool isNew = false]) {
    if (activeList != null) {
      if (!activeList.saved) {
        isAddUnconfirmed = isNew;
        listNameUnconfirmed = listName;
        isSaveDialogShown = true;      
        JsObject jQuery = context;
        jQuery.callMethod(r"$", ["#saveChangesModal"]).callMethod("modal",["show"]);
      }
      else confirmedViewChange(listName, isNew);
    }
    else confirmedViewChange(listName, isNew);
  }
}

class ListContainer {
  String name = "";
  List<ListItem> names;
  ListItem activeItem;
  ListItem _oldActiveItem;

  bool saved = false;
  ListContainer (this.name) {
    
  }

  void edit (String name) {
    
  }
}

class CustomerListContainer extends ListContainer {
  Customer currentCustomer = new Customer ();
  CustomerListContainer(String name):super(name);
}

class ListItem {
  String name;
  String globalID;
}
