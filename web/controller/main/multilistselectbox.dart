part of FreemansClient;

@NgComponent(
  selector: "multi-select",
  template: "<div ng-if=\"selector.header != null\" class=\"multi-select-header {{selector.classVal}}\"><div ng-repeat=\"col in selector.header\">{{col}}</div></div><ul class=\"multi-select {{selector.classVal}}\"><li ng-repeat=\"row in selector.rows\" ng-click=\"selector.setValue(\$index)\" ng-class=\"{ 'multi-select-active': selector.active == \$index }\" data-value=\"\$index\"><div ng-repeat=\"column in row\">{{column}}</div></li></ul>",
  publishAs: "selector",
  applyAuthorStyles: true
)
class MultiListSelectBox {
  Scope scope;
  
  MultiListSelectBox (Scope this.scope) {
    
  }
  String _colD;
  
  @NgAttr("column-data")
  set colData (String data) {
    if (data != null) {
      dynamic r = scope.$parent.$eval(data);
      scope.$parent.$watch(data, (r, p, Scope scope) {
        if (r != p) {
        if (r is List) {
                rows = r;
        }
        else {
          print("$data : ${r.runtimeType} is not a List");
        }  
        }
      });
      if (r is List) {
        rows = r;
      }
      else {
        print("$data : ${r.runtimeType} is not a List");
      }
      _colD = data;
    }
  }
  String get colData => _colD;
  
  @NgAttr("header")
  set colHeader (String data) {
    if (data != null) {
      dynamic r = scope.$parent.$eval(data);
      if (r is List) {
        header = r;
        classVal = "multi-select-col-${header.length}";
      }
      else {
        print("$data : ${r.runtimeType} is not a List");
      }
    }
  }
    
  List<List<String>> rows; 
  
  List<String> header;
  
  @NgAttr("active")
  int active;

  @NgAttr("output")
  String output = "";

  String classVal;

  void setValue (int value) {
    if (value == active) {
      active = null;
    }
    else  active = value;
    if (output.isNotEmpty) {
      scope.$parent.$eval("$output = $active");
    }
  }
  
}