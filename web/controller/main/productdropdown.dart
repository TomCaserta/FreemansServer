part of FreemansClient;

@NgController (
    selector: "product",
    publishAs: "dropdown"
)
class ProductDropdown {
  String fieldType = "";
  Scope s;
  StateService stateservice;

  UListElement selectedElementsDisplay;

  Product product;
  ProductWeight productWeight;
  ProductPackaging productPackaging;
  ProductDescriptors productDescriptor;

  Function stateChange;
  Function prodChange;
  Function weightChange;
  Function packagingChange;
  Function descriptorChange;
  String prodAttr;
  String weightAttr;
  String packagingAttr;
  String descriptorAttr;
  
  set productS (Product prod) {
    product = prod;
    s.$eval("$prodAttr = dropdown.product");
  }
  
  set productWeightS (ProductWeight prodWeight) {
    productWeight = prodWeight;

    s.$eval("$weightAttr = dropdown.productWeight");
  }
  
  set productPackagingS (ProductPackaging prodPackaging) {
    productPackaging = prodPackaging;
    s.$eval("$packagingAttr = dropdown.productPackaging");
  }
  
  set productDescriptorS (ProductDescriptors prodDescriptor) {
    productDescriptor = prodDescriptor;
    s.$eval("$descriptorAttr = dropdown.productDescriptor");
  }
  
  @NgAttr("state")
  set state (String state) {
    if (state != null && state.isNotEmpty) {
      if (stateChange != null) stateChange();
       var ss = s.$eval(state);
       if (ss != this.stateservice) { 
         this.stateservice = ss;
         Function pL, pacL, wl,pdl;
         if (this.stateservice != null) {
          pL = s.$watchCollection("$state.activeProductList",(List c, List p, ws) { 
            if (c != p) { 
              updateList();
            }                     
          }); 
          pacL = s.$watchCollection("$state.activePackagingList",(List c, List p, ws) { 
             if (c != p) { 
               updateList();
             }                     
          }); 

          wl = s.$watchCollection("$state.activeWeightList",(List c, List p, ws) { 
             if (c != p) { 
               updateList();
             }                     
          }); 

          pdl = s.$watchCollection("$state.activeProductDescriptorList",(List c, List p, ws) { 
             if (c != p) { 
               updateList();
             }                     
          }); 
         }
         stateChange = s.$watch(state, (curr, prev, Scope s) { 
           if (curr != prev && curr != null) {
             this.stateservice = curr;
             updateList();
           }
         });
       
        updateList();
      }
    }
  }

  @NgAttr("product")
  set productAttr (String prod) {
    if (prodChange != null) prodChange();
    this.product = s.$eval(prod);
    prodAttr = prod;
    prodChange = s.$watch(prod, (currentValue, previousValue, Scope scope) {
      if (currentValue != previousValue) {
        if (currentValue != null) updateSelected(currentValue);
        else removeTypeFromSelected(SyncableTypes.PRODUCT);
        refreshSelectedElements();
      }
    });
  }

  @NgAttr("product-weight")
  set productWeightAttr (String prodWeight) {
    if (weightChange != null) weightChange();
    this.productWeight = s.$eval(prodWeight);
    weightAttr = prodWeight;
    weightChange = s.$watch(prodWeight,(currentValue, previousValue, Scope scope) { 
      if (currentValue != previousValue) {
        if (currentValue != null) updateSelected(currentValue);
        else removeTypeFromSelected(SyncableTypes.PRODUCT_WEIGHT);
        refreshSelectedElements();
      }
    });
  }

  @NgAttr("product-packaging")
  set productPackagingAttr (String prodPackaging) {
    if (packagingChange != null) packagingChange();
    this.productPackaging = s.$eval(prodPackaging);
    packagingAttr = prodPackaging;
    packagingChange = s.$watch(prodPackaging, (currentValue, previousValue, Scope scope) { 
      if (currentValue != previousValue) {
        if (currentValue != null) updateSelected(currentValue);
        else removeTypeFromSelected(SyncableTypes.PRODUCT_PACKAGING);
        
        refreshSelectedElements();
      }
    });
  }

  @NgAttr("product-descriptor")
  set productDescriptorAttr (String prodDescriptor) {
    if (descriptorChange != null) descriptorChange();
    this.productDescriptor = s.$eval(prodDescriptor);
    descriptorAttr = prodDescriptor;
    descriptorChange = s.$watch (prodDescriptor, (currentValue, previousValue, Scope scope) { 
      if (currentValue != previousValue) {
        if (currentValue != null) updateSelected(currentValue);
        else removeTypeFromSelected(SyncableTypes.PRODUCT_DESCRIPTOR);
        refreshSelectedElements();
      }
    });
  }
  List<Syncable> selectedElements = [];
  
  // Current State
  int rows = 0;
  List rowsList = new List();
  int activeNum = 0;

  /// Current stripped input box text
  String currentSearch = "";
  /// Current selected element. 
  int currentSelected = 0;
  Syncable selectedElement = null;
  /// Active List that is being searched
  List<Syncable> activeList = [];
  List<Syncable> filteredList = []; 
 
  
  // Container Elements
  Element el;
  DivElement inputBox;
  DivElement autoCompleteBox;
  
  
  ProductDropdown (Scope this.s, Element this.el) {
    
    // Create the input box element
    this.inputBox = new DivElement();
    
    inputBox.classes.add("auto-completer-input");
    inputBox.contentEditable = "true";    
    
    inputBox.onKeyUp.listen((KeyboardEvent ev) {
      // If the key is a character:
      if ((ev.which >= 48 && ev.which <= 222) || (ev.which == 32)) {
        print(ev.which == 32);
        refreshSubset();
      }
      
      // If the key is backspace:
      if (ev.which == 8) {
        if (inputBox.text.length == 0 && currentSearch == "") {
          if (selectedElements.length > 0) {
            print(inputBox.text);
            currentSelected = 0;
            selectedElement = null;
            selectedElements.removeLast();
            this.selectedElementsDisplay.children.last.remove();
            inputBox.text = "";
            updateList();
          }
        }
        refreshSubset();
      }
    });
    
    inputBox.onFocus.listen((ev) {
      this.autoCompleteBox = new DivElement();
      el.append(autoCompleteBox);
      el.classes.add("focused");
      refreshSubset();
    });
    
    inputBox.onBlur.listen((ev) {
      el.classes.remove("focused");
      autoCompleteBox.remove();
    });
    inputBox.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.which) {
        case 13:
        case 9:
          if (activeList.length > 0) {
            if (selectedElement == null) {
              selectedElement = filteredList[0];
            }
            appendElement(selectedElement);  
            
          }
          /// Check again because it may have changed inside the above if 
          if (ev.which == 13) ev.preventDefault();
          break;
        case 32:
          print(filterRes("$currentSearch "));
          if (filterRes("$currentSearch ").length == 0) {
            if (activeList.length > 0) {
              if (selectedElement == null) {
                selectedElement = filteredList[0];
              }
              appendElement(selectedElement);  
              ev.preventDefault();
            }
          }
          break;
        case 127: ev.preventDefault();
        // Delete
        break;
        case 37: ev.preventDefault();
        // Left
        break;
        case 39: ev.preventDefault();
        // Right
        break;
        case 45: ev.preventDefault();
        break;
        case 40:
          List<Element> lis = this.autoCompleteBox.querySelectorAll("ul > li");
          if (currentSelected < lis.length-1) {
            currentSelected++;

            if (lis.length >= currentSelected) {
              lis.forEach((elem) => elem.classes.remove("active"));
              lis[currentSelected]..scrollIntoView()..classes.add("active");
              selectedElement = filteredList[int.parse(lis[currentSelected].attributes["value"])];
            }
            ev.preventDefault();
          }
          break;
        case 38:
          if (currentSelected > 0) {
            currentSelected--;
            List<Element> lis = this.autoCompleteBox.querySelectorAll("ul > li");
            if (lis.length >= currentSelected) {
              lis.forEach((elem) => elem.classes.remove("active"));
              lis[currentSelected]..scrollIntoView()..classes.add("active");
              selectedElement = filteredList[int.parse(lis[currentSelected].attributes["value"])];
            }
            ev.preventDefault();
          }
          break;
      }
    });

    el.onClick.listen((ev) { inputBox.focus(); });
    DivElement selectedSections = new DivElement();
    selectedSections.classes.add("auto-completer-selections");
    this.selectedElementsDisplay = new UListElement();
    selectedSections.append(selectedElementsDisplay);
    el.append(selectedSections);
    el.append(inputBox);
  }
  
  void updateSelected (Syncable selected) {
    for (int x = 0; x < selectedElements.length; x++) { 
      var s = selectedElements[x];
      if (s.type == selected.type) {
        selectedElements.removeAt(x);
        x--;
      }
    }
    selectedElements.add(selected);
    switch (selected.type) {
      case SyncableTypes.PRODUCT:
        this.productS = selected;
        break;
      case SyncableTypes.PRODUCT_PACKAGING:
        this.productPackagingS = selected;
        break;
      case SyncableTypes.PRODUCT_WEIGHT:
        this.productWeightS = selected;
        break;
      case SyncableTypes.PRODUCT_DESCRIPTOR:
        this.productDescriptorS = selected;
        break;
    }
    updateList();
  }
  
  void removeTypeFromSelected (int type) {
    for (int x = 0; x < selectedElements.length; x++) { 
      var s = selectedElements[x];
      if (s.type == type) {
        selectedElements.removeAt(x);
        x--;
      }
    }
    switch (type) {
      case SyncableTypes.PRODUCT:
        this.productS = null;
        break;
      case SyncableTypes.PRODUCT_PACKAGING:
        this.productPackagingS = null;
        break;
      case SyncableTypes.PRODUCT_WEIGHT:
        this.productWeightS = null;
        break;
      case SyncableTypes.PRODUCT_DESCRIPTOR:
        this.productDescriptorS = null;
        break;
    }
    updateList();
  }
  
  
  void updateList () {
    bool addProducts = true;
    bool addPackaging = true;
    bool addWeights = true;
    bool addDescriptors = true;
    selectedElements.forEach((Syncable s) { 
      switch (s.type) {
         case SyncableTypes.PRODUCT:
           addProducts = false;
           break;
         case SyncableTypes.PRODUCT_PACKAGING:
           addPackaging = false;
           break;
         case SyncableTypes.PRODUCT_WEIGHT:
           addWeights = false;
           break;
         case SyncableTypes.PRODUCT_DESCRIPTOR:
           addDescriptors = false;
           break;
      }
    });
    activeList.clear();
    if (stateservice != null) {
      if (addProducts) activeList.addAll(stateservice.activeProductList);
      if (addPackaging) activeList.addAll(stateservice.activePackagingList);
      if (addWeights) activeList.addAll(stateservice.activeWeightList);
      if (addDescriptors) activeList.addAll(stateservice.activeProductDescriptorList);
    }
  }
  
  void refreshSelectedElements() {
    //selectedElementsDisplay
    for (int x = 0; x < this.selectedElementsDisplay.childNodes.length; x++) {
      this.selectedElementsDisplay.childNodes[x].remove();
      x--;
    }
    selectedElements.forEach((e) => appendElement(e, false));
  }
  
  void appendElement (Syncable element, [bool doAdditional = true]) {
    this.selectedElementsDisplay.append(new LIElement()..text = element.name);
    if (doAdditional) {
      updateSelected(element); 
      inputBox.text = "";
      inputBox.focus();
      refreshSubset();
    }  
  }
  List filterRes (String filterStr) {
    return activeList.where((Syncable s) {
      String res = s.name;
      if (filterStr.length <= res.length) {
        return res.substring(0,filterStr.length).toLowerCase() == filterStr.toLowerCase().replaceAll(" ", " "); //  For some reason theres non breaking spaces
      }
      else {
        return false;
      }        
    }).toList();
  }
  
  void refreshSubset() {
    if (activeList != null) {
      currentSearch = inputBox.text;
      for (int x = 0; x < this.autoCompleteBox.childNodes.length; x++) {
        this.autoCompleteBox.childNodes[x].remove();
        x--;
      }
      UListElement ulEl = new UListElement();
      ulEl.classes.add("auto-completer-suggestions");
      currentSelected = 0;
      bool isFirst = true;
      filteredList = filterRes(currentSearch);
      if (filteredList.length > 0) selectedElement = filteredList[0];
      
      int x = 0;
      filteredList.forEach((Syncable s) {
        String match = s.name;
        LIElement li = new LIElement();
        li.text = match;
        li.attributes["value"] = x.toString();
        ulEl.append(li);
        li.onMouseDown.listen((ev) {
           if (activeList.length > 0) {
                appendElement(s);
           }
         });
        if (isFirst) { li.classes.add("active"); isFirst =  false;}
        
        x++;
      });
      if (isFirst) ulEl.style.display = "none";
      else ulEl.style.display = "inline-block";
      this.autoCompleteBox.append(ulEl);
    }
  }
}