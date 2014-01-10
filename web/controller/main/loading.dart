part of FreemansClient;

@NgController(
    selector: '[loader]',
    publishAs: 'loader'
)
class Loading {
  bool loaded = false;
  num progress = 0.00;
  Loading () {
    Logger.root.info("Loading ${this.runtimeType}");
    
    FreemansModule.preloader.startLoad().listen((int prog) { 
      progress = prog;
      if (prog == 100) {
        loaded = true;
      }
    });
  }
  
}
