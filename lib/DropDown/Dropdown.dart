import 'package:app_actasalinstante/NavBar.dart';
import 'package:flutter/material.dart';

import '../Widgets/carousel_example.dart';

class Dropdown extends StatelessWidget {
  final dropvalue = ValueNotifier('');
  final dropOpcoes = ['Nacimiento', 'Defuncion', 'Matrimonio', 'Divorcio'];
  Dropdown({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: dropvalue,
            builder: (BuildContext context, String value, _) {
              return DropdownButton<String>(
                icon: const Icon(Icons.document_scanner),
                hint: const Text('Seleciona el tipo de acta'),
                value: (value.isEmpty) ? null : value,
                onChanged:(escolha) => dropvalue.value = escolha.toString(),
                items: dropOpcoes
                .map((op) => DropdownMenuItem(
                  value: op,
                  child: Text(op),
                  
                  ))
                  
                  .toList(),
                
              );
             
              
            }),
      ),
      
    );
  }
}
