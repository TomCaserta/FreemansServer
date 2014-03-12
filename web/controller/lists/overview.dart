library ListOverview;

import "dart:html";
// Already using mirrors so fuck it.
import "dart:mirrors";
import "package:angular/angular.dart";
import "dart:js";
import "../../utilities/state_service.dart";
import "../../class/main.dart";
import "../../websocket/websocket_handler.dart";
import "package:intl/intl.dart";

part "list_container.dart";
part "list_buttons.dart";



@NgController(
    selector: '[listoverview]',
    publishAs: 'listoverview'
)
class ListEditor {
  List<ListContainer> lists = new List<ListContainer>();
  ListContainer activeList;
  Element scopeElem;
  Scope scope;
  StateService state;
  
  String listNameUnconfirmed = "";
  bool isAddUnconfirmed = false;
  bool isSaveDialogShown = false;
  ListEditor(this.state, Element scopeElem, Scope this.scope) {
    if (state.checkLogin()) {
      this.scopeElem = scopeElem;
      lists.add(new ListContainer<Customer>("Customer", state, state.customerList));
      lists.add(new ListContainer<Supplier>("Suppliers", state, state.supplierList));
      lists.add(new TransportListContainer("Transport", state, state.transportList));
      lists.add(new ListContainer<Product>("Products", state, state.productList));
      lists.add(new ListContainer<ProductCategory>("Product Categories", state, state.productCategoryList));
      lists.add(new ListContainer<ProductDescriptors>("Descriptors", state, state.productDescriptorList));
      lists.add(new ListContainer<ProductWeight>("Weights/Amounts", state, state.productWeightsList));
      lists.add(new ListContainer<ProductPackaging>("Packaging", state, state.productPackagingList));
      lists.add(new ListContainer<Terms>("Terms", state, state.termsList));
      lists.add(new ListContainer<Locations>("Locations", state, state.locationList));
    }
  }
  void confirmedViewChange ([String listName, bool isNew]) {
    isSaveDialogShown = false;
    activeList = lists.where((e) => e.name == listName).first;
    activeList.processList(isNew);
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

