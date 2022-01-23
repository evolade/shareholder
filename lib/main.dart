// ignore_for_file: sized_box_for_whitespace

import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import 'v.dart';

void main() async {
  await GetStorage.init();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

final box = GetStorage(); // load local storage

num valuation = box.read("valuation_key") ?? 0;

List shareHolders = box.read("shareHolders_key") ?? [];
List money = box.read("money_key") ?? [];
List perc = box.read("perc_key") ?? [];

List firstMoney = box.read("firstMoney_key") ?? [];
List firstPerc = box.read("firstPerc_key") ?? [];

final nameController = TextEditingController();
final investmentController = TextEditingController();

Color bgColor = const Color(0xFF0e0f12); // black-ish

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

  Color splashColor =
      const Color.fromARGB(63, 127, 127, 127); // semi-trans gray

  final valueController = TextEditingController();

  void confirmClear() {
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

                  V.writeData();

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
        V.writeData();
      });
    }
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
                            flex: 7,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              splashColor: Colors.green[400],
                              onTap: () {
                                try {
                                  if (nameController.text == "" ||
                                      investmentController.text == "") {
                                    V.toast("Form isn't filled", width);
                                  } else {
                                    setState(() {
                                      V.addInvestor();
                                    });
                                  }
                                } catch (_) {
                                  V.toast(
                                      "Investment should be a number", width);
                                }
                              },
                              child: V.button(Icons.person_add_outlined, width,
                                  height, Colors.green[400]!),
                            ),
                          ),
                          SizedBox(width: width / 25),
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(32),
                              splashColor: Colors.red[400],
                              onTap: () {
                                setState(() {
                                  confirmClear();
                                });
                              },
                              child: V.button(Icons.person_off_outlined, width,
                                  height, Colors.red[400]!),
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
                                try {
                                  addCash();
                                } catch (_) {
                                  V.toast("Form isn't filled correctly", width);
                                }
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.green[400]!),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green[400],
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
                  itemCount: shareHolders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: splashColor,
                      onTap: () {
                        V.showHolderInfo(context, index);
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
