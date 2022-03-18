import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const ListPage(title: 'List Purchase'),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List purchase = [];

  final _formKey = GlobalKey<FormState>();
  TextEditingController qtyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  getData() async {
    print('ok');
    var url = "http://192.168.1.9:8080/list/";
    final response = await http.get(Uri.parse(url));
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    List tList = [];
    for (int i = 0; i < jsonResponse.length; i++) {
      tList.add(jsonResponse[i]);
    }

    setState(() {
      purchase.addAll(tList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
        actions: [
          IconButton(
              onPressed: () {
                showMyDialog(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            itemCount: purchase.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(purchase[index]['intSalesOrderID'].toString()),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Date'),
                          ),
                          Expanded(
                            child: Text(
                                purchase[index]['dtSalesOrder'].toString()),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Qty'),
                          ),
                          Expanded(
                            child: Text(purchase[index]['intQty'].toString()),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Customer'),
                          ),
                          Expanded(
                            child: Text(purchase[index]['customers']
                                    ['txtCustomerName']
                                .toString()),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Product'),
                          ),
                          Expanded(
                            child: Text(purchase[index]['products']
                                    ['txtProductName']
                                .toString()),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Add Purchase "),
          content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: qtyController,
                      decoration: InputDecoration(hintText: 'Date'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Qty is required';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: qtyController,
                      decoration: InputDecoration(hintText: 'Qty'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Qty is required';
                        }
                        return null;
                      }),
                ],
              )),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: const Text('Add'),
              onPressed: () {},
            ),
          ]),
    );
  }
}
