import 'package:flutter/material.dart';
import 'main.dart';

class Show {
  static void holderInfo(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "${index + 1}. ${shareHolders[index]}    ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 170,
            width: 10000,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("first \n"),
                    Text("current\n"),
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
                      "\n\n\n\$${money[index] - firstMoney[index] > 0 ? '+' : ''}${money[index] - firstMoney[index]}",
                      style: TextStyle(
                          color: money[index] - firstMoney[index] > 0
                              ? Colors.green
                              : Colors.red),
                    ),
                    Text(
                      "\n\n\n${money[index] - firstMoney[index] > 0 ? '+' : ''}${(((money[index] - firstMoney[index]) / firstMoney[index]) * 100).toStringAsFixed(4)}%",
                      style: TextStyle(
                          color: money[index] - firstMoney[index] > 0
                              ? Colors.green
                              : Colors.red),
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
}
