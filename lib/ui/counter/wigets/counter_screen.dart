import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/ui/counter/view_models/counter_view_model.dart';

class CounterScreen extends StatefulWidget {
  CounterScreen({super.key});
  final CounterViewModel viewModel = CounterViewModel(counter: 0);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times:'),
            Text(
              '${widget.viewModel.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 8,
        children: [
          IconButton(
            onPressed: () {
              setState(() => widget.viewModel.decrementCounter());
            },
            tooltip: 'Decrement',
            icon: const Icon(Icons.remove),
            color: Colors.red,
          ),
          IconButton(
            onPressed: () {
              setState(() => widget.viewModel.resetCounter());
            },
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh),
            color: Colors.blue,
          ),
          IconButton(
            onPressed: () {
              setState(() => widget.viewModel.incrementCounter());
            },
            tooltip: 'Increment',
            icon: const Icon(Icons.add),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
