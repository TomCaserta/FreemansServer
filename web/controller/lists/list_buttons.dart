part of ListOverview;

@NgComponent(
  selector: "listbuttons",
  templateUrl: "views/lists/list_buttons.html",
  publishAs: "button",
  applyAuthorStyles: true
)
class ListButtons {
  ListContainer _container;
  
  String _controller;
  @NgAttr("controller")
  String get controller => _controller;
  
  set controller (String cont) {
    if (this.scope != null && cont != null && cont.isNotEmpty) {
      _controller = cont;      
      _container = scope.$parent.$eval(cont);
      
      scope.$parent.$watch(cont,(currentValue, previousValue, Scope scope) { 
          _container = currentValue;
      });
    }
  }  
  
  @NgAttr("name")
  String name = "";
  
  bool get isAdd => _container != null ? _container.isAdd : false;
  
  Scope scope;
  
  ListButtons (Scope this.scope) {
    
  }
  
  void clickDelete () {
    print("Deleted");
    if (_container != null) {
      _container.onDelete();
    }
  }
  
  void clickUpdate () {
    print("Updated");
    if (_container != null) {
      _container.onUpdate();
    }
  }
  
  void clickCancel () {
    print("Cancellled");
    if (_container != null) {
      _container.onDelete();
    }
  }
  
  void clickAdd() {
    print("Added");
    if (_container != null) {
      _container.onAdd();
    }
  }
}