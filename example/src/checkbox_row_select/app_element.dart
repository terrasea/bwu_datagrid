library app_element;

import 'dart:math' as math;
import 'dart:html' as dom;

import 'package:polymer/polymer.dart';

import 'package:bwu_datagrid/datagrid/helpers.dart';
import 'package:bwu_datagrid/bwu_datagrid.dart';
import 'package:bwu_datagrid/dataview/dataview.dart';
import 'package:bwu_datagrid/editors/editors.dart' as editors;
import 'package:bwu_datagrid/plugins/checkbox_select_column.dart';
import 'package:bwu_datagrid/plugins/row_selection_model.dart';
import 'package:bwu_datagrid/components/bwu_column_picker/bwu_column_picker.dart';

@CustomTag('app-element')
class AppElement extends PolymerElement {
  AppElement.created() : super.created();

  List<Column> columns = [];

  var gridOptions = new GridOptions(
      editable: true,
      enableCellNavigation: true,
      asyncEditorLoading: false,
      autoEdit: false);

  math.Random rnd = new math.Random();

  BwuDatagrid grid;
  MapDataItemProvider data;

  @override
  void attached() {
    super.attached();

    try {
      grid = $['myGrid'];

      CheckboxSelectColumn checkboxColumn =
          new CheckboxSelectColumn(cssClass: 'bwu-datagrid-cell-checkboxsel');
      columns.add(checkboxColumn);
      for (int i = 0; i < 5; i++) {
        columns.add(new Column(
            id: i.toString(),
            name: new String.fromCharCode('A'.codeUnits[0] + i),
            field: i.toString(),
            width: 100,
            editor: new editors.TextEditor()));
      }

      // prepare the data
      data = new MapDataItemProvider();
      for (var i = 0; i < 100; i++) {
        data.items.add(new MapDataItem({'id': i, '0': 'Row $i'}));
      }

      DataView dataView = new DataView();

      grid
          .setup(dataProvider: data, columns: columns, gridOptions: gridOptions)
          .then((_) {
        grid.setSelectionModel = (new RowSelectionModel(
            new RowSelectionModelOptions(selectActiveRow: false)));
        grid.registerPlugin(checkboxColumn);
        //new ColumnPicker(columns, grid, options);

        BwuColumnPicker columnPicker =
            (new dom.Element.tag('bwu-column-picker') as BwuColumnPicker)
          ..columns = columns
          ..grid = grid;
        dom.document.body.append(columnPicker);
      });
    } on NoSuchMethodError catch (e) {
      print('$e\n\n${e.stackTrace}');
    } on RangeError catch (e) {
      print('$e\n\n${e.stackTrace}');
    } on TypeError catch (e) {
      print('$e\n\n${e.stackTrace}');
    } catch (e) {
      print('$e');
    }
  }
}
