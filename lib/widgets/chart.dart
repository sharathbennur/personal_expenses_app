import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalWeekdaySum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].transactionDate.day == weekDay.day &&
            recentTransactions[i].transactionDate.month == weekDay.month &&
            recentTransactions[i].transactionDate.year == weekDay.year) {
          totalWeekdaySum += recentTransactions[i].amount;
        }
      }

      // print(DateFormat.E().format(weekDay));
      // print(totalWeekdaySum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 2),
        'amount': totalWeekdaySum,
      };
    });
  }

  double get maxAmount {
    return groupedTransactionValues.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  maxAmount == 0.0
                      ? 0.0
                      : (data['amount'] as double) / maxAmount,
                ),
              );
            }).toList(),
          ),
        ));
  }
}
