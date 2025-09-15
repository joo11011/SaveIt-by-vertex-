import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:savelt_app/view/Add_new_income_screen/widgets/add_income_button.dart';
import 'package:savelt_app/view/Add_new_income_screen/widgets/currency_and_amount.dart';
import 'package:savelt_app/view/Add_new_income_screen/widgets/date.dart';
import 'package:savelt_app/view/Add_new_income_screen/widgets/note.dart';
import 'package:savelt_app/view/Add_new_income_screen/widgets/source_of_money.dart';
import 'package:savelt_app/view/Income_screen/Income_screen.dart';

class AddNewIncomeScreen extends StatefulWidget {
  const AddNewIncomeScreen({super.key});

  @override
  State<AddNewIncomeScreen> createState() => _AddNewIncomeScreenState();
}

class _AddNewIncomeScreenState extends State<AddNewIncomeScreen> {
  final _fkey=GlobalKey<FormState>();
  String sourcemoney='';
  String currency = 'USD';
  double amount=0.0;
  DateTime? date;
  String note='';
  String get datestr => date == null ?  '': '${date!.year}/${date!.month}/${date!.day}';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => income_screen(),));
          }, icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text("Add New Income"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _fkey,
            child:ListView(
              children: [
                Sourceofmoney(
                  onsaved: (p0) => sourcemoney=p0??"",
                ),
                SizedBox(height: 15,),
                Currencyandamount(
                  currency: currency,
                  currencychange:(p0) => setState(() {
                    currency=p0??'USD';
                  }),
                  currencysaved:(p0) => currency=p0??'USD',
                  amountsaved: (p0) => amount=double.tryParse(p0??"0")??0,
                ),
                SizedBox(height: 15,),
                Date(
                  date: datestr,
                  ontap: () async{
                    FocusScope.of(context).requestFocus(FocusNode());
                    final choosen=await showDatePicker(
                        context: context,
                        initialDate: date??DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2050),
                    );
                    if(choosen!=null)
                      {
                        setState(() {
                          date=choosen;
                        });
                      }
                  },
                ),
                SizedBox(height: 15,),
                Note(
                    onsaved: (p0) => note=p0??''
                ),
                SizedBox(height: 30,),
                Addincomebutton(
                  onpressed: () async {
                    _fkey.currentState?.save();
                    if(sourcemoney.isEmpty||amount==0||date==null)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please add all required fields")),
                        );
                        return;
                      }
                    await FirebaseFirestore.instance.collection('incomes').add(
                      {
                      'source_of_money':sourcemoney,
                      'currency':currency,
                      'amount':amount,
                      'date':date!.toIso8601String(),
                      'note':note,
                      'createdAt':FieldValue.serverTimestamp()
                      });
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => income_screen(),));
                  },
                )
              ],
            ),
        ),
      ),
    );
  }
}
