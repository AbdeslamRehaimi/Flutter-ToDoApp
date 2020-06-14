import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/database.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/widgets/custom_button.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Database provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<Database>(context);

    return StreamProvider.value(
      value: provider.getTodoByType(TodoType.TYPE_TASK.index),
      child: Consumer<List<TodoData>>(
        builder: (context, _dataList, child) {
          return _dataList == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    return _dataList[index].isFinish
                        ? _taskComplete(_dataList[index])
                        : _taskUncomplete(_dataList[index]);
                  },
                );
        },
      ),
    );
  }

  Widget _taskUncomplete(TodoData data) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Confirm Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data.task),
                      SizedBox(
                        height: 24,
                      ),
                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Complete",
                        onPressed: () {
                          provider
                              .completeTodoEntries(data.id)
                              .whenComplete(() => Navigator.of(context).pop());
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
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Delete Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data.task),
                      SizedBox(
                        height: 24,
                      ),
                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Delete",
                        onPressed: () {
                          provider
                              .deleteTodoEntries(data.id)
                              .whenComplete(() => Navigator.of(context).pop());
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        //padding: const EdgeInsets.only(left: 24.0, right: 24),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.radio_button_unchecked,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            SizedBox(
              width: 28,
            ),
            //Text(data.todoType.toString()),
            _displayTime(DateFormat("dd-MM").format(data.date)),
            _displayContent(data.task),
          ],
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

  Widget _displayContent(String task) {
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
            //Place the children with their start edge aligned with the start side of the cross axis.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              Icon(
                Icons.watch_later,
                color: Colors.deepPurpleAccent,
                size: 20, ),
              
              Divider(
                color: Colors.grey,
                height: 8,
                thickness: 2,
              ),
              Text(
                task,
                style: TextStyle(
                    //fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayContentDone(String task) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.white54,
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
              //Icon put it here to be positioned
              Container(
                padding: const EdgeInsets.only(left: 190),
                child: Icon(
                Icons.check_box,
                color: Colors.green,
                //lightGreenAccent
                size: 20,
              ),
              ),
              //unpetit devider (ligne entre top et content)
              Divider(
                color: Colors.grey,
                height: 8,
                thickness: 2,
              ),
              Text(
                task,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskComplete(TodoData data) {
    return InkWell(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Delete Task",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(
                          height: 24,
                        ),
                        Text(data.task),
                        SizedBox(
                          height: 24,
                        ),
                        Text(new DateFormat("dd-MM-yyyy").format(data.date)),
                        SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                          buttonText: "Delete",
                          onPressed: () {
                            provider.deleteTodoEntries(data.id).whenComplete(
                                () => Navigator.of(context).pop());
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
          //foregroundDecoration: BoxDecoration(color: Color(0x60FDFDFD)),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.radio_button_checked,
                //color: Theme.of(context).accentColor,
                color: Colors.lightBlue,
                size: 20,
              ),
              SizedBox(
                width: 28,
              ),
              //Text(data.todoType.toString()),
              _displayTime(DateFormat("dd-MM").format(data.date)),
              _displayContentDone(data.task),
            ],
          ),
        ));
  }
}
