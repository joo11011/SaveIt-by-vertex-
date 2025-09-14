import 'package:flutter/material.dart';

import 'income_items.dart';

class income_list extends StatelessWidget {
  final List<Map<String,dynamic>>incomes;
  const income_list({super.key,required this.incomes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: incomes.length,
        itemBuilder: (context, index) {
          return incomeitems(
           tit: incomes[index]['tit'],
           subtit: incomes[index]['subtit'],
           amount: incomes[index]['amount'],
           icon: incomes[index]['icon'],
          );
        },
    ) ;
  }
}
