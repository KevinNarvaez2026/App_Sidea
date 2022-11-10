import 'package:get/state_manager.dart';
import 'package:app_actasalinstante/RFCDescargas/models/product.dart';
import 'package:app_actasalinstante/RFCDescargas/services/remote_services.dart';

class ProductControllers extends GetxController {
  var isLoading = true.obs;
  var productList = List<Product>().obs;

  @override
  void onInit() {
    fetchProductsrfc();

    super.onInit();
  }

  void fetchProductsrfc() async {
    try {
      isLoading(true);
      var products = await RemoteServices2.fetchProductsrfc();
      if (products != null) {
         print( "No tiene Datos de RFC");
        productList.value = products;
       
      }
    } finally {
      isLoading(false);
    }

  }
   
}
