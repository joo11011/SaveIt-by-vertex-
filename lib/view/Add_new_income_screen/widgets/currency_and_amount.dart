import 'package:flutter/material.dart';

class Currencyandamount extends StatelessWidget {
  final String currency;
  final void Function(String?) currencychange;
  final void Function(String?) currencysaved;
  final void Function(String?) amountsaved;

  const Currencyandamount({
    super.key,
    required this.currency,
    required this.currencychange,
    required this.currencysaved,
    required this.amountsaved
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Currency',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
              value: currency,
              items: ['USD','EUR','EGP'].map((c)=>DropdownMenuItem(
                  child: Text(c),
                value: c,
              )).toList(),
              onChanged: currencychange,
              onSaved: currencysaved,
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          flex: 3,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onSaved: amountsaved,
          ),
        ),
      ],
    );
  }
}
