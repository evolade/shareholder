// ignore_for_file: avoid_print, prefer_const_constructors
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'show.dart';
import 'add.dart';

void main() async {
  await GetStorage.init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

void writeData() {
  box.write("shareHolders_key", shareHolders);
  box.write("money_key", money);
  box.write("perc_key", perc);
  box.write("valuation_key", valuation);

  box.write("firstMoney_key", firstMoney);
  box.write("firstPerc_key", firstPerc);
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

  void confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
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
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  Color bgColor = Color(0xFF1a1b21); // gray

  final valueController = TextEditingController();

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
              Center(),
              SizedBox(height: height / 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    TextField(
                      cursorColor: Colors.white,
                      controller: nameController,
                      style: TextStyle(
                          color: Colors.white70, fontSize: width / 25),
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
                      style:
                          TextStyle(color: Colors.green, fontSize: width / 25),
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 50),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Container(
                                height: height / 14,
                                color: Colors.green[400],
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Add.investor();
                                    });
                                  },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                      color: bgColor,
                                      fontSize: width / 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width / 25),
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Container(
                                height: height / 14,
                                color: Colors.red[400],
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      confirmClear(context);
                                    });
                                  },
                                  child: Text(
                                    "Clear",
                                    style: TextStyle(
                                      color: bgColor, // red
                                      fontSize: width / 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height / 15),
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
                                    color: Colors.green, fontSize: width / 32),
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white60),
                                  hintText: "150000",
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
                                          money[i] = (valuation * perc[i] / 100)
                                              .round();
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
                      thickness: 1.2,
                      color: Colors.white10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: shareHolders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
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
                            color: Colors.green,
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
