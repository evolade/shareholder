// ignore_for_file: avoid_print, prefer_const_constructors
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  await GetStorage.init(); // load getstorage
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

final box = GetStorage(); // local storage

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

  Color bgColor = Color(0xFF212c31); // gray-blue

  int valuation = box.read("valuation_key") ?? 0;
  List<dynamic> shareHolders = box.read("shareHolders_key") ?? [];
  List<dynamic> money = box.read("money_key") ?? [];
  List<dynamic> perc = box.read("perc_key") ?? [];

  final nameController = TextEditingController();
  final investmentController = TextEditingController();
  final valueController = TextEditingController();

  void writeData() {
    box.write("shareHolders_key", shareHolders);
    box.write("money_key", money);
    box.write("perc_key", perc);
    box.write("valuation_key", valuation);
  }

  void showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Clear all shareholders?",
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  shareHolders.clear();
                  money.clear();
                  perc.clear();
                  valuation = 0;
                  writeData();
                });
                Navigator.pop(context, true);
              },
              child: Text("yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("no"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 18),
            child: Column(
              children: [
                Center(),
                SizedBox(height: height / 18),
                TextField(
                  cursorColor: Colors.white,
                  controller: nameController,
                  style: TextStyle(color: Colors.white70, fontSize: width / 30),
                  decoration: const InputDecoration(
                    labelText: "Investor name",
                    labelStyle: TextStyle(color: Colors.white60),
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
                SizedBox(height: height / 40),
                TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  controller: investmentController,
                  style: TextStyle(color: Colors.green, fontSize: width / 30),
                  decoration: const InputDecoration(
                    labelText: "Investment (\$)",
                    labelStyle: TextStyle(color: Colors.white60),
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
                SizedBox(height: height / 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: height / 14,
                          color: Colors.green[400],
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                List<dynamic> calc = [];
                                money.add(int.parse(investmentController.text));
                                double roi =
                                    money.last / (money.last + valuation);
                                shareHolders.add("${nameController.text}");
                                perc.add(roi * 100);
                                for (int i = 0;
                                    i < shareHolders.length - 1;
                                    i++) {
                                  calc.add(perc[i] / perc.last);
                                }
                                double prevPerc = 0;
                                for (int i = 0; i < calc.length; i++) {
                                  prevPerc += calc[i];
                                }
                                for (int i = 0;
                                    i < shareHolders.length - 1;
                                    i++) {
                                  perc[i] = perc[i] - (perc[i] / prevPerc);
                                }
                                valuation +=
                                    int.parse(investmentController.text);
                                writeData();
                              });
                            },
                            child: Text(
                              "Add Investor",
                              style: TextStyle(
                                color: bgColor,
                                fontSize: width / 27,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width / 50),
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: height / 14,
                          color: Colors.red[400],
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                showDialogBox(context);
                              });
                            },
                            child: Text(
                              "Clear",
                              style: TextStyle(
                                color: bgColor, // red
                                fontSize: width / 27,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$$valuation",
                      style: TextStyle(
                          fontSize: width / 16, color: Colors.white70),
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
                                color: Colors.green, fontSize: width / 32),
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.white60),
                              hintText: "150000",
                              hintStyle: TextStyle(color: Colors.white24),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white38),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width / 40),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.green[400],
                            child: IconButton(
                              onPressed: () {
                                if (shareHolders.isNotEmpty) {
                                  setState(() {
                                    valuation +=
                                        int.parse(valueController.text);
                                    for (int i = 0;
                                        i < shareHolders.length;
                                        i++) {
                                      money[i] =
                                          (valuation * perc[i] / 100).round();
                                    }
                                    writeData();
                                  });
                                }
                              },
                              icon: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: height / 30,
                  thickness: 1,
                  indent: 40,
                  endIndent: 40,
                  color: Colors.white10,
                ),
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: shareHolders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Text(
                          "${index + 1}.     ${shareHolders[index]}    ",
                          style: TextStyle(
                            fontSize: width / 30,
                            color: Colors.white70,
                          ),
                        ),
                        title: Text(
                          "\$${money[index]}",
                          style: TextStyle(
                            fontSize: width / 25,
                            color: Colors.green,
                          ),
                        ),
                        trailing: Text(
                          "%${perc[index].toStringAsFixed(2)}    ",
                          style: TextStyle(
                              fontSize: width / 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
