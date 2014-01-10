library Preloader;

import 'dart:async';

class PreloadElement { 
  String name;
  Function f;
  bool isFuture = true;
  PreloadElement(this.name, this.f);
}

class Preloader {
  List<PreloadElement> futures = new List<PreloadElement>();
  StreamController<int> _percent = new StreamController<int>();
  int _waiting = 0;
  int _loaded = 0;
  int _prevVal = 0;
  bool loaded = false;
  Preloader();
  void addFuture (PreloadElement f) {
    futures.add(f);
    _waiting++;
  }
  void addMethod (PreloadElement f) {
    f.isFuture = false;
    futures.add(f);
    _waiting++;
  }
  void _inc (bool value, PreloadElement ple, Function onError(String err)) {
    if (value == true) {
      _loaded++;
      int perc = _loaded ~/ (_waiting / 100);
      if (perc != _prevVal) { 
        _percent.add(perc);
        _prevVal = perc;
      }
      if (_loaded == _waiting) {
        loaded = true;
        _percent.close();
      }
    }
    else {
      onError("${ple.name} did not complete successfully.");
    }
  }
  Stream<int> startLoad ({Function onError(String s) }) {
    if (onError == null) onError = (e) { throw e; };
    for (PreloadElement ple in futures) {
      if (ple.isFuture) {
      ple.f().then((bool value) {
        _inc(value, ple, onError);
      }).catchError((e) { 
        onError(e);
      }); 
      }
      else {  
        ///TODO: FIX SO IT DOESNT USE A TIMER
        new Timer(new Duration(milliseconds: 1), () {  
            bool x = ple.f();
          _inc(x, ple, onError); 
        });
      }
    }
    return _percent.stream;
  }
}