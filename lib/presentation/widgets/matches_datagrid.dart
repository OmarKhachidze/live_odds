import 'package:flutter/material.dart';
import 'package:live_odds/core/extensions/datetime_extension.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/constants.dart';
import '../providers/matches_provider.dart';
import 'load_more_datagrid.dart';

enum MatchColumn { sport, competitors, time, score, odds }

class MatchesDataGrid extends StatefulWidget {
  const MatchesDataGrid({
    super.key,
    required this.dataGridSource,
    this.dataGridController,
  });

  final DataGridController? dataGridController;
  final SportMatchesDataSource dataGridSource;

  @override
  State<MatchesDataGrid> createState() => _MatchesDataGridState();
}

class _MatchesDataGridState extends State<MatchesDataGrid> {
  Map<String, double> columnWidths = {
    MatchColumn.sport.name: 80,
    MatchColumn.competitors.name: 100,
    MatchColumn.time.name: 130,
    MatchColumn.score.name: 60,
    MatchColumn.odds.name: 250,
  };

  @override
  void initState() {
    widget.dataGridSource.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadMoreDataGrid(
      dataGridController: widget.dataGridController,
      dataGridSource: widget.dataGridSource,
      columnNames: columnWidths.keys.toList(),
      columnLabels: {
        MatchColumn.sport.name: 'Sport',
        MatchColumn.competitors.name: 'Competitors',
        MatchColumn.time.name: 'Start Time',
        MatchColumn.score.name: 'Score',
        MatchColumn.odds.name: 'Odds',
      },
      onCellTap: (details) {},
      columnWidths: columnWidths,
    );
  }
}

class SportMatchesDataSource extends DataGridSource {
  SportMatchesDataSource(this.context);

  final BuildContext context;

  final List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  void initData() {
    _addMoreRows();
    _appendNewRows(fromIndex: 0);
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: cell.value is Widget
              ? cell.value
              : Text(
                  cell.value.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 11.0),
                  overflow: TextOverflow.ellipsis,
                ),
        );
      }).toList(),
    );
  }

  @override
  Future<void> handleLoadMoreRows() async {
    final previousCount = context.read<OddsProvider>().matches.length;
    await Future.delayed(const Duration(milliseconds: 500));
    _addMoreRows();
    _appendNewRows(fromIndex: previousCount);
    notifyListeners();
  }

  void _appendNewRows({required int fromIndex}) {
    _dataGridRows.addAll(
      context.read<OddsProvider>().matches.sublist(fromIndex).map<DataGridRow>((
        match,
      ) {
        return DataGridRow(
          cells: [
            DataGridCell<String>(
              columnName: MatchColumn.sport.name,
              value: match.sport.icon,
            ),
            DataGridCell<String>(
              columnName: MatchColumn.competitors.name,
              value: '${match.competitorA} 🆚 ${match.competitorB}',
            ),
            DataGridCell<String>(
              columnName: MatchColumn.time.name,
              value: match.matchStartTime.formatToString(),
            ),
            DataGridCell<String>(
              columnName: MatchColumn.score.name,
              value: match.currentScore,
            ),
            DataGridCell<String>(
              columnName: MatchColumn.odds.name,
              value: match.bettingOptions
                  .map((e) => '${e.description}:${e.odds}')
                  .join(' • '),
            ),
          ],
        );
      }),
    );
  }

  void _addMoreRows() {
    context.read<OddsProvider>().getMatches(dataGridPageSize);
  }
}
