import 'package:flutter/material.dart';
import 'package:todoapp/widgets/custom_icon_decoration.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/database.dart';
import 'package:todoapp/model/todo.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/widgets/custom_button.dart';

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}
 
class _MemoPageState extends State<MemoPage> {
  Database provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Database>(context);
    double iconSize = 20;

    return StreamProvider.value(
      value: provider.getTodoByType(TodoType.TYPE_TASK.index),
      child: Consumer<List<TodoData>>(
        builder: (context, _dataList, child) {
          return _dataList == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 24.0, right: 24),
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    /*
                    return Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: Row(
                        children: <Widget>[
                          _lineStyle(context, iconSize, index, _dataList.length,
                              _dataList[index].isFinish),
                          _displayTime(formateDate(_dataList[index].time)),
                          _displayContent(_dataList[index]),
                        ],
                      ),
                    );
                  },
                  */
                    return InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text("Confirm Task",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(_dataList[index].task),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(new DateFormat("dd-MM-yyyy")
                                            .format(_dataList[index].date)),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomButton(
                                          buttonText: "Complete",
                                          onPressed: () {
                                            provider
                                                .completeTodoEntries(
                                                    _dataList[index].id)
                                                .whenComplete(() =>
                                                    Navigator.of(context)
                                                        .pop());
                                          },
                                          color: Theme.of(context).accentColor,
                                          textColor: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text("Delete Task",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(_dataList[index].task),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Text(new DateFormat("dd-MM-yyyy")
                                            .format(_dataList[index].date)),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        CustomButton(
                                          buttonText: "Delete",
                                          onPressed: () {
                                            provider
                                                .deleteTodoEntries(
                                                    _dataList[index].id)
                                                .whenComplete(() =>
                                                    Navigator.of(context)
                                                        .pop());
                                          },
                                          color: Theme.of(context).accentColor,
                                          textColor: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 24),
                          child: Row(
                            children: <Widget>[
                              _lineStyle(context, iconSize, index,
                                  _dataList.length, _dataList[index].isFinish),
                              _displayTime(formateDate(_dataList[index].time)),
                              _displayContent(_dataList[index]),
                            ],
                          ),
                        ));

                  });
        },
      ),
    );
  }

  //Widget _displayContent(Memo event) {
  Widget _displayContent(TodoData event) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.task),
              SizedBox(
                height: 12,
              ),
              Text(event.description)
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayTime(String time) {
    return Container(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(time),
        ));
  }

  Widget _lineStyle(BuildContext context, double iconSize, int index,
      int listLength, bool isFinish) {
    return Container(
        decoration: CustomIconDecoration(
            iconSize: iconSize,
            lineWidth: 1,
            firstData: index == 0 ?? true,
            lastData: index == listLength - 1 ?? true),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    color: Color(0x20000000),
                    blurRadius: 5)
              ]),
          child: Icon(
              isFinish
                  ? Icons.fiber_manual_record
                  : Icons.radio_button_unchecked,
              size: iconSize,
              color: Theme.of(context).accentColor),
        ));
  }

  String formateDate(DateTime dt) {
    String formatter = DateFormat('jm').format(dt);
    return formatter;
  }
}
