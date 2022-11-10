import 'package:app_actasalinstante/views/controller/controller.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/instance_manager.dart';



class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<Controller>(Controller());
  }
}
