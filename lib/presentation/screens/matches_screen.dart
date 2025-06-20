import 'package:flutter/material.dart';
import 'package:live_odds/presentation/widgets/matches_datagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final DataGridController _dataGridController = DataGridController();
  late SportMatchesDataSource _sportMatchesDataSource;

  @override
  void initState() {
    _sportMatchesDataSource = SportMatchesDataSource(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Live Odds'),
      ),
      body: MatchesDataGrid(
        dataGridSource: _sportMatchesDataSource,
        dataGridController: _dataGridController,
      ),
    );
  }
}
