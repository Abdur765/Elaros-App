import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elaros_mobile_app/ui/home/view_models/heart_rate_view_model.dart';

class MetricsDashboard extends StatelessWidget {
  const MetricsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HeartRateViewModel()..loadAll(),
      child: Scaffold(
        appBar: AppBar(title: Text('Today')),
        body: Consumer<HeartRateViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) return Center(child: CircularProgressIndicator());

            // Avg HR card
            final avg = vm.items.isNotEmpty
                ? vm.items.map((m) => m.value).reduce((a, b) => a + b) /
                      vm.items.length
                : null;

            return Column(
              children: [
                // Date selector row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: vm.selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) await vm.loadByDate(picked);
                        },
                        icon: Icon(Icons.calendar_today),
                        label: Text(
                          vm.selectedDate == null
                              ? 'All dates'
                              : vm.selectedDate!
                                    .toIso8601String()
                                    .split('T')
                                    .first,
                        ),
                      ),
                      if (vm.selectedDate != null)
                        TextButton(
                          onPressed: vm.clearDateFilter,
                          child: Text('Clear'),
                        ),
                      // Quick-set button for 12-5-2016 (Dec 5, 2016)
                      TextButton(
                        onPressed: () async {
                          await vm.loadByDate(DateTime(2016, 12, 5));
                        },
                        child: Text('12-5-2016'),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: avg == null
                        ? Text('-- bpm')
                        : Column(
                            children: [
                              Text(
                                'Avg HR',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '${avg.toStringAsFixed(0)} bpm',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // List of readings
                Expanded(
                  child: vm.items.isEmpty
                      ? Center(child: Text('No heart rate records'))
                      : ListView.builder(
                          itemCount: vm.items.length,
                          itemBuilder: (context, i) {
                            final hr = vm.items[i];
                            return ListTile(
                              title: Text('${hr.value} bpm'),
                              subtitle: Text(hr.time),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () => vm.increment(hr),
                                  ),
                                  if (hr.id != null)
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => vm.deleteById(hr.id!),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Consumer<HeartRateViewModel>(
          builder: (context, vm, _) {
            return FloatingActionButton(
              onPressed: vm.addRandom,
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
