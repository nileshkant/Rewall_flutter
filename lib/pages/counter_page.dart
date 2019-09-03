import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewalls/blocs/counter_bloc.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final CounterBloc counterbloc = Provider.of<CounterBloc>(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(counterbloc.counter.toString()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counterbloc.increment(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
