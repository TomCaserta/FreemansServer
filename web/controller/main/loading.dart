part of FreemansClient;

@NgController(
    selector: '[loader]',
    publishAs: 'loader'
)
class Loading {
  StateService service;
  bool get loaded {
    return (service != null ? service.loaded : false);
  }
  num progress = 0.00;
  Loading (StateService this.service) {
    Logger.root.info("Loading ${this.runtimeType}");
    
    service.preloader.startLoad().listen((int prog) { 
      progress = prog;
    });
  }
  
}
