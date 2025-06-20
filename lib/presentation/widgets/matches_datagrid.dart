import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/constants.dart';
import '../../core/extensions/datetime_extension.dart';
import '../../domain/models/sport_match.dart';
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
  final Map<String, double> columnWidths = {
    MatchColumn.sport.name: 80,
    MatchColumn.competitors.name: 100,
    MatchColumn.time.name: 130,
    MatchColumn.score.name: 60,
    MatchColumn.odds.name: 250,
  };

  @override
  void initState() {
    super.initState();
    context.read<OddsProvider>().getMatchesAndStartOdds(dataGridPageSize);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.dataGridSource.initData();
      widget.dataGridSource.listenForOddsUpdates();

      // Restore selection from Hive
      // _restoreSelectedRows();
    });
  }

  void _saveSelectedRows() {
    final selected = widget.dataGridController?.selectedRows;
    final ids =
        selected
            ?.map((row) {
              log('${widget.dataGridSource.rows.indexOf(row)}');
              return widget.dataGridSource.rows.indexOf(row);
            })
            .whereType<int>()
            .toList() ??
        [];

    Hive.box<List<int>>('selected_match_ids').put('ids', ids);
  }

  @override
  Widget build(BuildContext context) {
    return LoadMoreDataGrid(
      onSelectionChanged: _saveSelectedRows,
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
      columnWidths: columnWidths,
    );
  }
}

class SportMatchesDataSource extends DataGridSource {
  SportMatchesDataSource(this.context, this.controller);

  final Map<int, List<double?>> _previousOddsMap = {};
  final Map<int, OddsChange> _oddsChangeMap = {};
  final BuildContext context;
  final DataGridController controller;
  final List<DataGridRow> _dataGridRows = [];

  void _restoreSelectedRows() {
    final selectedIds = Hive.box<List<int>>(
      'selected_match_ids',
    ).get('ids', defaultValue: [])!.where((e) => e < rows.length);

    controller.selectedRows = selectedIds.map((e) => rows[e]).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  void initData() {
    _addMoreRows();
    _appendNewRows(fromIndex: 0);
    _restoreSelectedRows();
    notifyListeners();
  }

  void listenForOddsUpdates() {
    final provider = context.read<OddsProvider>();
    provider.addListener(() {
      _updateOddsCells(provider.matches);
    });
  }

  @override
  Future<void> handleLoadMoreRows() async {
    final previousCount = context.read<OddsProvider>().matches.length;
    await Future.delayed(const Duration(milliseconds: 500));
    _addMoreRows();
    _appendNewRows(fromIndex: previousCount);
    _restoreSelectedRows();
    notifyListeners();
  }

  void _addMoreRows() {
    context.read<OddsProvider>().getMatches(dataGridPageSize);
  }

  void _appendNewRows({required int fromIndex}) {
    final matches = context.read<OddsProvider>().matches;
    _dataGridRows.addAll(
      matches.sublist(fromIndex).map((match) {
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

  void _updateOddsCells(List<SportMatch> matches) {
    for (int i = 0; i < matches.length; i++) {
      if (i >= _dataGridRows.length) break;
      final match = matches[i];
      final currentOdds = match.bettingOptions.map((e) => e.odds).toList();

      OddsChange change = match.oddsChange;
      final previousOdds = _previousOddsMap[i];
      _oddsChangeMap[i] = change;

      if (previousOdds != null && previousOdds.length == currentOdds.length) {
        for (int j = 0; j < currentOdds.length; j++) {
          if (currentOdds[j]! > previousOdds[j]!) {
            change = OddsChange.increase;
            break;
          } else if (currentOdds[j]! < previousOdds[j]!) {
            change = OddsChange.decrease;
            break;
          }
        }
      }

      // Save current odds and change type
      _previousOddsMap[i] = currentOdds;
      _oddsChangeMap[i] = change;

      // Update only the odds cell
      _dataGridRows[i].getCells()[4] = DataGridCell<String>(
        columnName: MatchColumn.odds.name,
        value: match.bettingOptions
            .map((e) => '${e.description}:${e.odds}')
            .join(' • '),
      );

      notifyDataSourceListeners(rowColumnIndex: RowColumnIndex(i, 4));
    }
  }

  Color? _setColumnColor(DataGridCell<dynamic> cell, int rowIndex) {
    if (cell.columnName != MatchColumn.odds.name) return null;

    final change =
        _oddsChangeMap[rowIndex] ??
        context.read<OddsProvider>().matches[rowIndex].oddsChange;

    return switch (change) {
      OddsChange.increase => Colors.green.withValues(alpha: 0.2),
      OddsChange.decrease => Colors.red.withValues(alpha: 0.2),
      OddsChange.none => Colors.transparent,
    };
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final rowIndex = _dataGridRows.indexOf(row);

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          color: _setColumnColor(cell, rowIndex),
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
}
