part of FreemansClient;

@NgController(
  selector: "[salesinput]",
  publishAs: "sales"
)
class SalesController {
  Scope s;
  StateService state;
  

  SalesController (Scope this.s, StateService this.state) {
    
  }
}