import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double amountDay;
  final double amountPctDay;

  ChartBar(this.label, this.amountDay, this.amountPctDay);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(
          child: Text('\$${amountDay.toStringAsFixed(0)}'),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 60,
          width: 15,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: amountPctDay,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(label),
      ],
    );
  }
}
