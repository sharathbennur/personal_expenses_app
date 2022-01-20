import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'Personal Expenses',
            theme: const CupertinoThemeData(
              primaryColor: Colors.deepPurple,
              primaryContrastingColor: Colors.white,
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
                  color: Colors.purple,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            home: MyHomePage(),
          )
        : MaterialApp(
            title: 'Personal Expenses',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.purple,
              fontFamily: 'OpenSans',
              textTheme: ThemeData.light().textTheme.copyWith(
                    bodyText2: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    button: TextStyle(color: Colors.white),
                  ),
              appBarTheme: const AppBarTheme(
                  titleTextStyle:
                      TextStyle(fontFamily: 'QuickSand', fontSize: 20)),
            ),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var uuid = const Uuid();
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   transactionDate: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Groceres',
    //   amount: 54.22,
    //   transactionDate: DateTime.now(),
    // )
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.transactionDate.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  void _addNewTransaction(
      String titleTx, double amountTx, DateTime datePicked) {
    final newTx = Transaction(
        id: uuid.v1(),
        title: titleTx,
        amount: amountTx,
        transactionDate: datePicked);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final isLandscape = _mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget _appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses App'),
            trailing: CupertinoButton(
              minSize: kMinInteractiveDimensionCupertino,
              child: const Icon(CupertinoIcons.add),
              onPressed: () => _startAddNewTransaction(context),
              padding: EdgeInsets.zero,
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: const Text(
              'Personal Expenses App',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final txListWidget = Container(
        height: (_mediaQuery.size.height -
                _appBar.preferredSize.height -
                _mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final _pageBody = SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Show Chart'),
                Switch.adaptive(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                ),
              ],
            ),
          if (!isLandscape)
            Container(
              height: (_mediaQuery.size.height -
                      _appBar.preferredSize.height -
                      _mediaQuery.padding.top) *
                  0.3,
              child: Chart(_recentTransactions),
            ),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            _showChart
                ? Container(
                    height: (_mediaQuery.size.height -
                            _appBar.preferredSize.height -
                            _mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions),
                  )
                : txListWidget,
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _pageBody,
            navigationBar: _appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: _appBar,
            body: _pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
