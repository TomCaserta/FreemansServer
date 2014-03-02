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
  
  bool get loaded {
    return preloader.loaded;  
  }
  
  bool get webSocketLoaded {
    return wsh.loaded;
  }
  
  
  void parseInitializationPacket (InitialDataResponseServerPacket packet) {
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
    preloader.addMethod(new PreloadElement("ServerPacket", ServerPacket.init));
  }

}