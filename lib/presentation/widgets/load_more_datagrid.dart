import 'package:flutter/material.dart';
import 'package:live_odds/presentation/widgets/datagrid_loader.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/constants.dart';
import 'matches_datagrid.dart';

enum LoadState { loading, completed }

class LoadMoreDataGrid extends StatefulWidget {
  const LoadMoreDataGrid({
    required this.dataGridSource,
    this.dataGridController,
    required this.columnNames,
    required this.columnWidths,
    required this.columnLabels,
    required this.onCellTap,
    super.key,
  });

  final DataGridController? dataGridController;
  final DataGridSource dataGridSource;
  final List<String> columnNames;
  final Map<String, double> columnWidths;
  final Map<String, String> columnLabels;
  final void Function(DataGridCellTapDetails) onCellTap;

  @override
  State<LoadMoreDataGrid> createState() => _LoadMoreDataGridState();
}

class _LoadMoreDataGridState extends State<LoadMoreDataGrid> {
  List<GridColumn> _buildDataGridColumns(BuildContext context) {
    return widget.columnNames.map((name) {
      return GridColumn(
        allowFiltering: name == MatchColumn.sport.name,
        filterIconPadding: const EdgeInsets.only(right: 5.0),
        filterPopupMenuOptions: name == MatchColumn.sport.name
            ? const FilterPopupMenuOptions(
                filterMode: FilterMode.checkboxFilter,
                canShowClearFilterOption: false,
                canShowSortingOptions: false,
                showColumnName: true,
              )
            : null,
        width: widget.columnWidths[name]!,
        minimumWidth: dataGridColumnMinWidth,
        columnName: name,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            widget.columnLabels[name] ?? name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: dataGridTitleColor(context),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      allowFiltering: true,
      controller: widget.dataGridController,
      source: widget.dataGridSource,
      loadMoreViewBuilder: (BuildContext context, LoadMoreRows loadMoreRows) {
        return FutureBuilder<LoadState>(
          initialData: LoadState.loading,
          future: () async {
            await loadMoreRows();
            return LoadState.completed;
          }(),
          builder: (context, snapshot) {
            final isLoading = snapshot.data == LoadState.loading;
            return isLoading ? const DataGridLoader() : const SizedBox.shrink();
          },
        );
      },
      columnWidthMode: ColumnWidthMode.fill,
      selectionMode: SelectionMode.multiple,
      onCellTap: widget.onCellTap,
      columns: _buildDataGridColumns(context),
      allowColumnsResizing: true,
      onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
        setState(() {
          widget.columnWidths[details.column.columnName] = details.width;
        });
        return true;
      },
      headerGridLinesVisibility: GridLinesVisibility.both,
      headerRowHeight: dataGridHeaderHeight,
    );
  }
}
