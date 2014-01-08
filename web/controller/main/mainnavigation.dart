part of FreemansClient;

@NgController (
      selector: "[mainnav]",
      publishAs: 'main'
    )
class MainNavigation {
  Link activeLink = new Link("","");
  List<Link> links = new List<Link>();
  MainNavigation() {
    links.add(new Link("Overview", "/overview"));
    links.add(new Link("Workbook", "/workbook"));
    links.add(new Link("Sales", "/sales"));
    links.add(new Link("Purchases", "/purchases"));
    links.add(new Link("Transport", "/transport"));
    links.add(new Link("Payments", "/payments"));
  }
}

class Link {
  String url = "";
  String name = "";
  Link(this.name, this.url);
}