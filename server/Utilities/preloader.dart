library Preloader;

import 'dart:async';

class PreloadElement { 
  String name;
  Function f;
  PreloadElement(this.name, this.f);
}

class Preloader {
  List<PreloadElement> futures = new List<PreloadElement>();
  StreamController<int> _percent = new StreamController<int>();
  int _waiting = 0;
  int _loaded = 0;
  Preloader();
  void addFuture (PreloadElement f) {
    futures.add(f);
    _waiting++;
  }
  
  Stream<int> startLoad ({Function onError(String s) }) {
    if (onError == null) onError = (e) { };
    futures.forEach((PreloadElement ple) {
      ple.f().then((bool value) {
        if (value == true) {
          _loaded++;
          _percent.add(_loaded ~/ (_waiting / 100));
          if (_loaded == _waiting) {
            _percent.close();
          }
        }
        else {
          onError("${ple.name} did not complete successfully.");
        }
      }).catchError((e) { 
        onError(e);
      }); 
    });
    
    return _percent.stream;
  }
}