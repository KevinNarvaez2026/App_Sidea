import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants.dart';
import '../controllers/product_controller.dart';


const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(30)),
  borderSide: BorderSide.none,
);
  final ProductController productController = Get.put(ProductController());
class SearchForm extends StatelessWidget {
  
  const SearchForm({
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        onSaved: (value) {

          
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Buscar Actas...",
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          errorBorder: outlineInputBorder,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(20),
            child: SvgPicture.asset("assets/Search.svg"),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(
                ),
            child: SizedBox(
              width: 1,
              height: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                 
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(53)),
                  ),
                ),
                onPressed: () {},
                child: SvgPicture.asset("assets/Filter.svg"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
