import 'package:flutter/material.dart';
import 'main.dart';

class V {
  static void addInvestor() {
    List<dynamic> calc = [];
    money.add(int.parse(investmentController.text));
    double roi = money.last / (money.last + valuation);
    shareHolders.add("${nameController.text}");
    perc.add(roi * 100);
    for (int i = 0; i < shareHolders.length - 1; i++) {
      calc.add(perc[i] / perc.last);
    }
    double prevPerc = 0;
    for (int i = 0; i < calc.length; i++) {
      prevPerc += calc[i];
    }
    for (int i = 0; i < shareHolders.length - 1; i++) {
      perc[i] = perc[i] - (perc[i] / prevPerc);
    }
    valuation += int.parse(investmentController.text);

    firstMoney.add(money.last);
    firstPerc.add(perc.last);

    writeData();
  }

  static void writeData() {
    box.write("shareHolders_key", shareHolders);
    box.write("money_key", money);
    box.write("perc_key", perc);
    box.write("valuation_key", valuation);

    box.write("firstMoney_key", firstMoney);
    box.write("firstPerc_key", firstPerc);
  }

  static void showHolderInfo(BuildContext context, int index) {
    num profit = money[index] - firstMoney[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "${index + 1}. ${shareHolders[index]}    ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 140,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("first \n"),
                    Text("now\n"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${firstMoney[index].toStringAsFixed(2)}"),
                    Text("\$${money[index].toStringAsFixed(2)}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${firstPerc[index].toStringAsFixed(4)}%"),
                    Text("${perc[index].toStringAsFixed(4)}%"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "\n\n\$${profit > 0 ? '+' : ''}${profit}",
                      style: TextStyle(
                          color: profit > 0 ? Colors.green : Colors.red),
                    ),
                    Text(
                      "\n\n${profit > 0 ? '+' : ''}${(((profit) / firstMoney[index]) * 100).toStringAsFixed(4)}%",
                      style: TextStyle(
                          color: profit > 0 ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget button(
      IconData icon, double width, double height, Color color) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 26,
      ),
    );
  }
}
