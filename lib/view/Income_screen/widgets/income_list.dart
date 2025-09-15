import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'income_items.dart';

class income_list extends StatelessWidget {
  final List<Map<String, dynamic>> incomes;
  final List<String> docIds;

  const income_list({super.key, required this.incomes, required this.docIds});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(docIds[index]),
          direction: DismissDirection.endToStart,
          onDismissed: (_) async {
            await FirebaseFirestore.instance
                .collection('incomes')
                .doc(docIds[index])
                .delete();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('income Deleted'.tr),
                duration: Duration(seconds: 2),
              ),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: incomeitems(
            tit: incomes[index]['tit'],
            subtit: incomes[index]['subtit'],
            amount: incomes[index]['amount'],
            icon: incomes[index]['icon'],
          ),
        );
      },
    );
  }
}
