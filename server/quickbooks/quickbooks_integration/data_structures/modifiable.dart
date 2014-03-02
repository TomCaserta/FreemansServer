part of QuickbooksIntegration;

abstract class QBModifiable {
  static Map<Type, Map<String, QBModifiable>> _CACHE = new Map<Type, Map<String, QBModifiable>>();

  static Future<QBModifiable> get(Type t, String listID, QuickbooksConnector qbc) {
    if (QBModifiable._CACHE.containsKey(t) && QBModifiable._CACHE[t].containsKey(listID)) {
      _qbLogger.info("Requested data for ${t}:${listID} from cache");
      Completer c = new Completer();
      c.complete(_CACHE[t][listID]);
      return c.future;
    } else {
      // perform query
      _qbLogger.info("No data for ${t}:${listID} found in cache... fetching from quickbooks");
      ClassMirror cm = reflectClass(t);
      Future retVal = cm.invoke(const Symbol("fetchByID"), [listID, qbc]).reflectee;
      return retVal;
    }
  }

  static Future fetchByID(String listID) {
    _qbLogger.severe("QBModified does not have a static method fetchByID");
    throw new UnimplementedError();
  }

  String listID;

  void addToCache(String listID) {
    if (this.listID != null) {
      if (!QBModifiable._CACHE.containsKey(this.runtimeType)) {
        QBModifiable._CACHE[this.runtimeType] = new Map<String, QBModifiable>();
      }
      QBModifiable._CACHE[this.runtimeType][this.listID] = this;
    }
  }

  /* PREPARE FOR HACKY MIRRORS :) */

  void mergeWith(updated, [bool forceMerge = false]) {
    if (this.runtimeType == updated.runtimeType || forceMerge) {
      InstanceMirror origIM = reflect(this);
      InstanceMirror updatedIM = reflect(updated);
      ClassMirror origCM = reflectClass(this.runtimeType);
      _merge(origCM, origIM, updatedIM);
    } else throw new Exception("Cannot merge two objects of different types. To override set forceMerge to true");
  }

  void _merge(ClassMirror fromClass, InstanceMirror original, InstanceMirror newValues) {
    fromClass.declarations.forEach((Symbol s, DeclarationMirror dm) {
      if (dm is VariableMirror && dm.isPrivate == false) {
        dynamic val = newValues.getField(s).reflectee;
        if (val != null) {
          original.setField(s, val);
        }
      }
    });
    if (fromClass.superclass != null) {
      _merge(fromClass.superclass, original, newValues);
    }
  }

  Future<bool> insert(QuickbooksConnector qbc) {
   
  }
 
  Future<bool> update(QuickbooksConnector qbc) {
  }
}