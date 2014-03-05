part of FreemansServer;

class TransportHaulageCost extends Syncable<TransportHaulageCost> {
   int type = SyncableTypes.TRANSPORT_HAULAGE_COST;
   
   int _transportID;
   int _locationID;
   num _cost;
   bool _canDeliver;
   
   int get transportID => _transportID;  
   int get locationID => _locationID;  
   num get cost => _cost;  
   bool get canDeliver => _canDeliver;   

   @IncludeSchema()
   set transportID (int transportID) {
     if (transportID != _transportID) {
       _transportID = transportID;
       requiresDatabaseSync();
     }
   }    
   
   @IncludeSchema()
   set locationID (int locationID) {
     if (locationID != _locationID) {
       _locationID = locationID;
       requiresDatabaseSync();
     }
   }  

   @IncludeSchema()
   set cost (num cost) {
     if (cost != _cost) {
       _cost = cost;
       requiresDatabaseSync();
     }
   }   

   @IncludeSchema()
   set canDeliver (bool canDeliver) {
     if (canDeliver != _canDeliver) {
       _canDeliver = canDeliver;
       requiresDatabaseSync();
     }
   }   
   
   TransportHaulageCost._create(int id):super(id);
   
   factory TransportHaulageCost (int ID) {
     if (exists(ID)) {
       return get(ID);
     } else {
       return new TransportHaulageCost._create(ID);
     }
   }
  
   static exists(int ID) => Syncable.exists(TransportHaulageCost, ID);
   static get(int ID) => Syncable.get(TransportHaulageCost, ID);
   
   TransportHaulageCost.fromJson(Map jsonMap):super.fromJson(jsonMap);
   
   void mergeJson(Map jsonMap) {
     this.transportID = jsonMap["transportID"];
     this.locationID = jsonMap["locationID"];
     this.cost = jsonMap["cost"];
     this.canDeliver = jsonMap["canDeliver"];
     super.mergeJson(jsonMap);
   }
   
   Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
     Completer c = new Completer();
     if (this.isNew) {   
       dbh.prepareExecute("INSERT INTO transport_haulage_costs (transportID, locationID, cost, canDeliver, isActive) VALUES (?, ?, ?, ?, ?)", 
           [this.transportID, this.locationID, this.cost, (this.canDeliver ? 1 : 0), (isActive ? 1 : 0)]).then((Results r) { 
         if (r.insertId != 0) {
            _firstInsert(r.insertId);
            c.complete(true);
         } else {
            c.completeError("Unspecified mysql error");
         }
       }).catchError((e) => c.completeError(e));
     }
     else {
       dbh.prepareExecute("UPDATE transport_haulage_costs SET transportID=?, locationID=?, cost=?, canDeliver=?, isActive=? WHERE ID=?", [this.transportID, this.locationID, this.cost, (this.canDeliver ? 1 : 0), (isActive ? 1 : 0), this.ID]).then((Results res) { 
         if (res.affectedRows <= 1) {
            synced();
            c.complete(true);
          } else {
            c.completeError("Query affected ${res.affectedRows} instead of just one.");
          }
       }).catchError((e) => c.completeError(e));
     }
     return c.future;
   }
   
   static Future<bool> init() {
     Completer c = new Completer();
     ffpServerLog.info("Loading Transport Haulage Costs list...");
     dbHandler.query("SELECT ID, locationID, transportID, cost, canDeliver, isActive FROM transport_haulage_costs").then((Results results){
       results.listen((Row row) {
         TransportHaulageCost thc = new TransportHaulageCost(row[0])
                                 ..locationID = row[1]
                                 ..transportID = row[2]
                                 ..cost = row[3]
                                 ..canDeliver = row[4] == 1
                                 ..isActive = row[5] == 1;
       },
       onDone: () {
         c.complete(true);
         ffpServerLog.info("List loaded.");
       },
       onError: (e) {
         c.completeError("Could not load list from database: $e");
       });
     }).catchError((e) {
       c.completeError("Could not load list from database: $e");
     });
     return c.future;
   }
   
   Map toJson () {
     return super.toJson()..addAll({ "transportID": transportID, "locationID": locationID, "cost": cost, "canDeliver": canDeliver, "isActive": isActive });
   }
}