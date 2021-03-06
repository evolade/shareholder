import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'v.dart';

void main() async {
  await GetStorage.init();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

final db = GetStorage(); // load local storage

List shareholders = [];

int valuation = 0;

bool disabled = true;

final nameController = TextEditingController();
final investmentController = TextEditingController();

double height = 0;
double width = 0;

Color bgColor = const Color(0xFF0e0f12); // black-ish

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    if (db.read("shareholders_key") != null) {
      if (db.read("shareholders_key").length > 1) {
        shareholders = db.read("shareholders_key");
        valuation = db.read("valuation_key");
      }
    }

    disabled = shareholders.isEmpty;
    super.initState();
  }

  Color splashColor =
      const Color.fromARGB(63, 127, 127, 127); // semi-trans gray

  final valueController = TextEditingController();

  void confirmClear() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: AlertDialog(
            backgroundColor: bgColor,
            title: const Text(
              "Clear all shareholders?",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(primary: Colors.red[400]),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.green[400]),
                onPressed: () {
                  setState(() {
                    shareholders.clear();
                    valuation = 0;
                    V.writeData();
                    disabled = true;
                    Navigator.pop(context, true);
                  });
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addCash() {
    if (shareholders.isNotEmpty) {
      setState(() {
        valuation += int.parse(valueController.text);
        for (int i = 0; i < shareholders.length; i++) {
          shareholders[i]["money"] =
              (valuation * shareholders[i]["perc"] / 100).round();
        }
        V.writeData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const Center(),
              SizedBox(height: height / 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    TextField(
                      maxLength: 17,
                      cursorColor: Colors.grey,
                      controller: nameController,
                      style: TextStyle(
                          color: Colors.white70, fontSize: width / 25),
                      decoration: const InputDecoration(
                        labelText: "Investor name",
                        labelStyle: TextStyle(color: Colors.white38),
                        hintText: "George",
                        hintStyle: TextStyle(color: Colors.white24),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                      ),
                    ),
                    SizedBox(height: height / 100),
                    TextField(
                      maxLength: 13,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.grey,
                      controller: investmentController,
                      style: TextStyle(
                          color: Colors.green[400], fontSize: width / 25),
                      decoration: const InputDecoration(
                        labelText: "Investment (\$)",
                        labelStyle: TextStyle(color: Colors.white38),
                        hintText: "200000",
                        hintStyle: TextStyle(color: Colors.white24),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                      ),
                    ),
                    SizedBox(height: height / 50),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 50),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              splashColor: Colors.green[400],
                              onTap: () {
                                try {
                                  if (nameController.text == "" ||
                                      investmentController.text == "") {
                                    V.toast("Form isn't filled");
                                  } else {
                                    setState(() {
                                      V.addInvestor();
                                      disabled = false;
                                    });
                                  }
                                } catch (_) {
                                  V.toast("Investment should be a number");
                                }
                              },
                              child: V.button(Icons.person_add_outlined, false),
                            ),
                          ),
                          SizedBox(width: width / 25),
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              splashColor: disabled
                                  ? Colors.transparent
                                  : Colors.red[400],
                              onTap: () {
                                if (disabled) {
                                  null;
                                } else {
                                  setState(() => confirmClear());
                                }
                              },
                              child: V.button(Icons.person_off_outlined, true),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height / 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$$valuation",
                          style: TextStyle(
                              fontSize: width / 18, color: Colors.white70),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width / 5,
                              child: TextField(
                                controller: valueController,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.grey,
                                style: TextStyle(
                                    color: Colors.green[400],
                                    fontSize: width / 32),
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white60),
                                  hintText: "10000",
                                  hintStyle: TextStyle(color: Colors.white24),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white24),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white38),
                                  ),
                                ),
                                readOnly: disabled,
                              ),
                            ),
                            SizedBox(width: width / 40),
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              splashColor: disabled
                                  ? Colors.transparent
                                  : Colors.green[400],
                              onTap: () {
                                try {
                                  addCash();
                                } catch (_) {
                                  V.toast("Form isn't filled correctly");
                                }
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: disabled
                                          ? Colors.white24
                                          : Colors.green[400]!),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: disabled
                                      ? Colors.white24
                                      : Colors.green[400],
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1.2,
                      color: Colors.white10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: shareholders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: splashColor,
                      onTap: () => V.showHolderInfo(context, index),
                      child: ListTile(
                        leading: Text(
                          "${index + 1}.    ${shareholders[index]['name']}",
                          style: TextStyle(
                            fontSize: width / 30,
                            color: Colors.white70,
                          ),
                        ),
                        title: Text(
                          "\$${shareholders[index]['money']}",
                          style: TextStyle(
                            fontSize: width / 25,
                            color: Colors.green[400],
                          ),
                        ),
                        trailing: Text(
                          "${shareholders[index]['perc'].toStringAsFixed(2)}%",
                          style: TextStyle(
                              fontSize: width / 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
