// ignore_for_file: sized_box_for_whitespace

import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import 'show.dart';
import 'add.dart';

void main() async {
  await GetStorage.init();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

final box = GetStorage(); // load local storage

int valuation = box.read("valuation_key") ?? 0;

List<dynamic> shareHolders = box.read("shareHolders_key") ?? [];
List<dynamic> money = box.read("money_key") ?? [];
List<dynamic> perc = box.read("perc_key") ?? [];

List<dynamic> firstMoney = box.read("firstMoney_key") ?? [];
List<dynamic> firstPerc = box.read("firstPerc_key") ?? [];

final nameController = TextEditingController();
final investmentController = TextEditingController();

void writeData() {
  box.write("shareHolders_key", shareHolders);
  box.write("money_key", money);
  box.write("perc_key", perc);
  box.write("valuation_key", valuation);

  box.write("firstMoney_key", firstMoney);
  box.write("firstPerc_key", firstPerc);
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    if (box.read("shareHolders_key") != null) {
      if (box.read("shareHolders_key").length > 1) {
        shareHolders = box.read("shareHolders_key");
        money = box.read("money_key");
        perc = box.read("perc_key");
        valuation = box.read("valuation_key");
      }
    }
    super.initState();
  }

  Color bgColor = const Color(0xFF0a0a0a); // blach-ish
  Color splashColor =
      const Color.fromARGB(63, 127, 127, 127); // semi-trans gray

  final valueController = TextEditingController();

  void confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Clear all shareholders?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  shareHolders.clear();
                  money.clear();
                  perc.clear();
                  valuation = 0;

                  firstMoney.clear();
                  firstPerc.clear();

                  writeData();

                  Navigator.pop(context, true);
                });
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  void addCash() {
    if (shareHolders.isNotEmpty) {
      setState(() {
        valuation += int.parse(valueController.text);
        for (int i = 0; i < shareHolders.length; i++) {
          money[i] = (valuation * perc[i] / 100).round();
        }
        writeData();
      });
    }
  }

  Widget button(String content, double width, double height, Color color) {
    return Container(
      alignment: Alignment.center,
      height: height / 14,
      decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(4)),
      child: Text(
        "${content}",
        style: TextStyle(
          color: color, // red
          fontSize: width / 22,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                      cursorColor: Colors.white,
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
                      cursorColor: Colors.white,
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
                            flex: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4),
                              splashColor: Colors.green[400],
                              onTap: () {
                                setState(() {
                                  confirmClear(context);
                                });
                              },
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                splashColor: Colors.green[400],
                                onTap: () {
                                  setState(() {
                                    Add.investor();
                                  });
                                },
                                child: button(
                                    "Add", width, height, Colors.green[400]!),
                              ),
                            ),
                          ),
                          SizedBox(width: width / 25),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4),
                              splashColor: Colors.red[400],
                              onTap: () {
                                setState(() {
                                  confirmClear(context);
                                });
                              },
                              child: button(
                                  "Clear", width, height, Colors.red[400]!),
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
                            Container(
                              width: width / 5,
                              child: TextField(
                                controller: valueController,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.green[400],
                                    fontSize: width / 32),
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white60),
                                  hintText: "120000",
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
                              ),
                            ),
                            SizedBox(width: width / 40),
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              splashColor: Colors.green[400],
                              onTap: () {
                                addCash();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.green[400]!),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green[400],
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
                  itemCount: shareHolders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: splashColor,
                      onTap: () {
                        Show.holderInfo(context, index);
                      },
                      child: ListTile(
                        leading: Text(
                          "${index + 1}.  ${shareHolders[index]}    ",
                          style: TextStyle(
                            fontSize: width / 30,
                            color: Colors.white70,
                          ),
                        ),
                        title: Text(
                          "\$${money[index]}",
                          style: TextStyle(
                            fontSize: width / 25,
                            color: Colors.green[400],
                          ),
                        ),
                        trailing: Text(
                          "${perc[index].toStringAsFixed(2)}%",
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
