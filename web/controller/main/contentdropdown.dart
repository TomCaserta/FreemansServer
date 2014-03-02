part of FreemansClient;

@NgDirective (
    selector: "div[auto-completer]"
)
class ContentDropdown {
  String fieldType = "";
  Scope s;
  List selectedElements = new List();
  UListElement selectedElementsDisplay;

  int rows = 0;
  List rowsList = new List();
  bool get isComplete => rows == activeNum;
  int activeNum = 0;

  String currentSearch = "";
  int currentSelected = 0;
  List get activeList => (activeNum < rowsList.length ? rowsList[activeNum] : []);
  Element el;
  DivElement inputBox;
  DivElement autoCompleteBox;

  ContentDropdown (Scope this.s, Element this.el) {
    this.rows = int.parse((el.getAttribute("rows") != null ? el.getAttribute("rows") : ""), onError: (s) { return 1; });
    for (int x = 1; x <= rows; x++) {
      String rName = "row$x";
      String rowVal = el.getAttribute(rName);
      // Pass by reference so itl update automatically
      rowsList.add(s.$eval(rowVal));
    }

    this.inputBox = new DivElement();

    el.onClick.listen((ev) { inputBox.focus(); });
    inputBox.tabIndex = 1;
    inputBox.classes.add("auto-completer-input");
    inputBox.tabIndex = 1;
    inputBox.contentEditable = "true";
    inputBox.onKeyUp.listen((KeyboardEvent ev) {
      if ((ev.which >= 48 && ev.which <= 222) || (ev.which == 32)) {
        refreshSubset();
      }
      if (ev.which == 8) {
        if (inputBox.text.length > 0) {
          refreshSubset();
        }
        else {
          if (activeNum > 0) {
            currentSelected = 0;
            activeNum--;
            selectedElements.removeLast();
            this.selectedElementsDisplay.children.last.remove();
            inputBox.text = "";
            refreshSubset();
          }
        }
      }
    });
    inputBox.onFocus.listen((ev) {
      this.autoCompleteBox = new DivElement();
      el.append(autoCompleteBox);
      el.classes.add("focused");
      refreshSubset();
    });
    inputBox.onBlur.listen((ev) { this.autoCompleteBox.remove();el.classes.remove("focused"); });
    inputBox.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.which) {
        case 13:
          if (!isComplete) {
            List<Element> lis = this.autoCompleteBox.querySelectorAll("ul > li");
            print(lis.length);
            if (lis.length > 0) {
              selectedElements.add(lis[currentSelected].text);
              this.selectedElementsDisplay.append(new LIElement()..text = lis[currentSelected].text);
              activeNum++;
              inputBox.text = "";
              refreshSubset();
            }
          }
          ev.preventDefault();
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
              lis[currentSelected].classes.add("active");
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
              lis[currentSelected].classes.add("active");
            }
            ev.preventDefault();
          }
          break;
      }
    });
    DivElement selectedSections = new DivElement();
    selectedSections.classes.add("auto-completer-selections");
    this.selectedElementsDisplay = new UListElement();
    selectedSections.append(selectedElementsDisplay);
    el.append(selectedSections);
    el.append(inputBox);
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
      activeList.where((String res) { return currentSearch.length <= res.length ? res.substring(0,currentSearch.length).toLowerCase() == currentSearch.toLowerCase() : false; }).forEach((String match) {
        LIElement li = new LIElement();
        li.text = match;
        ulEl.append(li);
        if (isFirst) { li.classes.add("active"); isFirst =  false;}
      });
      this.autoCompleteBox.append(ulEl);
    }
  }
}