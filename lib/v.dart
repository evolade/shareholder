import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';

import 'main.dart';

class V {
  static void addInvestor() {
    Map investor = {};
    shareholders.add(investor);
    List<num> calc = [];
    investor["money"] = int.parse(investmentController.text);
    double roi = investor["money"] / (investor["money"] + valuation);
    investor["name"] = nameController.text;
    investor["perc"] = roi * 100;
    for (int i = 0; i < shareholders.length - 1; i++) {
      calc.add(shareholders[i]["perc"] / investor["perc"]);
    }

    double prevPerc = 0;
    for (int i = 0; i < calc.length; i++) {
      prevPerc += calc[i];
    }

    for (int i = 0; i < shareholders.length - 1; i++) {
      shareholders[i]["perc"] =
          shareholders[i]["perc"] - (shareholders[i]["perc"] / prevPerc);
    }

    valuation += int.parse(investmentController.text);
    investor["firstMoney"] = investor["money"];
    investor["firstPerc"] = investor["perc"];
    writeData();
  }

  static void writeData() {
    db.write("shareholders_key", shareholders);
    db.write("valuation_key", valuation);
  }

  static void showHolderInfo(BuildContext context, int index) {
    num profit =
        shareholders[index]["money"] - shareholders[index]["firstMoney"];
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
            title: Text(
              "${index + 1}. ${shareholders[index]['name']}    ",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            content: SizedBox(
              height: 140,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "first\n",
                        style: TextStyle(
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        "now\n",
                        style: TextStyle(
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${shareholders[index]['firstMoney'].toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "\$${shareholders[index]['money'].toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${shareholders[index]['firstPerc'].toStringAsFixed(4)}%",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "${shareholders[index]['perc'].toStringAsFixed(4)}%",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "\n\n\$${profit > 0 ? '+' : ''}$profit",
                        style: TextStyle(
                            color: profit > 0
                                ? Colors.green[400]
                                : Colors.red[400]),
                      ),
                      Text(
                        "\n\n${profit > 0 ? '+' : ''}${(((profit) / shareholders[index]['firstMoney']) * 100).toStringAsFixed(4)}%",
                        style: TextStyle(
                            color: profit > 0
                                ? Colors.green[400]
                                : Colors.red[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget button(IconData icon, bool canDisable) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: canDisable
              ? disabled
                  ? Colors.white24
                  : Colors.red[400]!
              : Colors.green[400]!,
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: canDisable
            ? disabled
                ? Colors.white24
                : Colors.red[400]
            : Colors.green[400],
        size: 26,
      ),
    );
  }

  static void toast(String content) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.red[400],
      fontSize: width / 25,
    );
  }
}
