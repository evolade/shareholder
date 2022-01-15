import 'main.dart';

class Add {
  static void investor() {
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
}
