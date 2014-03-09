library StateService;

//TODO: Remove this dependency
import "dart:html";
import "../class/main.dart";
import "../websocket/websocket_handler.dart";
import "../utilities/preloader.dart";



class StateService {
  bool loggedIn = false;
  WebsocketHandler wsh = new WebsocketHandler("ws://127.0.0.1:1337/websocket");
  Preloader preloader = new Preloader();
  User currUser;
  
  List<Customer> customerList = new List<Customer>();
  List<ProductWeight> productWeightsList = new List<ProductWeight>();
  List<ProductCategory> productCategoryList = new List<ProductCategory>();
  List<ProductPackaging> productPackagingList = new List<ProductPackaging>();
  List<Product> productList = new List<Product>();
  List<Supplier> supplierList = new List<Supplier>();
  List<Transport> transportList = new List<Transport>();
  List<User> userList = new List<User>();
  List<Terms> termsList = new List<Terms>();
  List<Locations> locationList = new List<Locations>();
  List<TransportHaulageCost> transportHaulageCostList = new List<TransportHaulageCost>();
  
  List get activeSupplierList {
    return this.supplierList.where((e) => e.isActive).toList();
  }
  
  List get activeProductList {
    return this.productList.where((e) => e.isActive).toList();
  }
  
  List get activeWeightList {
    return this.productWeightsList.where((e) => e.isActive).toList();
  }
  
  List get activePackagingList {
    return this.productPackagingList.where((e) => e.isActive).toList();
  }
  
  List get activeProductCategoryList {
    return this.productCategoryList.where((e) => e.isActive).toList();
  }
  
  
  
  bool get loaded {
    return preloader.loaded;  
  }
  
  bool get webSocketLoaded {
    return wsh.loaded;
  }
  
  void handleLogin (LoggedInServerPacket packet) {
     WebsocketHandler.websocketLogger.info("Received login notification from server... parsing packet");
     this.loggedIn = true;
     WebsocketHandler.websocketLogger.info(packet.user.toString());
     this.currUser = new User.fromJson(packet.user); 
     wsh.sendGetResponse(new InitialDataRequestClientPacket()).then((ServerPacket packet) {
       if (packet is InitialDataResponseServerPacket) {
          this.parseInitializationPacket(packet);
        }               
     });
  }
  
  void parseInitializationPacket (InitialDataResponseServerPacket packet) {
    print("Parsing packet");
    this.customerList.clear();
    packet.customerList.forEach((Map customerListJson) {
      this.customerList.add(new Customer.fromJson(customerListJson));
    });
    packet.productWeightsList.forEach((Map productWeightJson) { 
      this.productWeightsList.add(new ProductWeight.fromJson(productWeightJson));
    });
    packet.productCategoryList.forEach((Map productCategoryList) { 
      this.productCategoryList.add(new ProductCategory.fromJson(productCategoryList));      
    });
    packet.productPackagingList.forEach((Map productPackagingList) { 
      this.productPackagingList.add(new ProductPackaging.fromJson(productPackagingList));
    });
    packet.productList.forEach((Map productJson) { 
      this.productList.add(new Product.fromJson(productJson));
    });
    packet.supplierList.forEach((Map supplierJson) { 
      this.supplierList.add(new Supplier.fromJson(supplierJson));
    });
    packet.transportList.forEach((Map transportJson) { 
      this.transportList.add(new Transport.fromJson(transportJson));
    });
    packet.userList.forEach((Map userJson) { 
      this.userList.add(new User.fromJson(userJson));
    });
    packet.termsList.forEach((Map termsList) { 
      this.termsList.add(new Terms.fromJson(termsList));
    });
    packet.locationList.forEach((Map locationList) { 
      this.locationList.add(new Locations.fromJson(locationList));
    });
    packet.termsList.forEach((Map thcList) { 
      this.transportHaulageCostList.add(new TransportHaulageCost.fromJson(thcList));
    });
  }
  
  
  bool checkLogin () {
    if (loggedIn == false) {
      // TODO: Move hash change to individual classes
      window.location.hash = "login";
      return false;
    }
    else {
      return true;
    }
  }
     
  StateService () { 
    wsh.ss = this;
    if (ServerPacket.init()) { 
      preloader.addMethod(new PreloadElement("Dummy", () { return true; }));
      wsh.connect();
    }
  }

}