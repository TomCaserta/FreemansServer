part of FreemansClient;

@NgDirective (
 selector: "input[auto-completer]",   
 publishAs: "autocompleter"
)
class ContentDropdown {
  String fieldType = "";
  InputElement element;
  Scope s;
  ContentDropdown (Scope this.s, Element el) {
    element = el;
    s.$on(r"$destroy", () { 
      this.destroy();      
    });
    fieldType = el.getAttribute("data-type");
    el.onKeyDown.listen((dat) { 
            
    });
    
  }
  
  void destroy () {
      
  }
  
  void updateDropdown () {
    
  }
}