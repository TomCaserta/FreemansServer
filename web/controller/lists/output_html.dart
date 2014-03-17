part of FreemansClient;

@NgDirective (
  selector: "[output-html]"
)
class OutputHtml {

  String _htmlData;

  @NgOneWay("output-html")
  set html (String html) {
    _htmlData = html;
    // Cant be bothered to sanitize it.
    el.innerHtml = "";
    el.appendHtml(html);
  }

  Element el;

  String get html => _htmlData;

  OutputHtml (Scope s, Element this.el) {
     el.attributes["output-html"];
  }
}