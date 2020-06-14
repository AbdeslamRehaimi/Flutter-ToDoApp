import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/widgets/custom_date_time_picker.dart';
import 'package:todoapp/widgets/custom_modal_action_button.dart';
import 'package:todoapp/widgets/custom_textfield.dart';
import 'package:todoapp/model/database.dart';
import 'package:todoapp/model/todo.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  //String _selectedDate = 'Pick date';
  DateTime _selectedDate = DateTime.now();
  //String _selectedTime = 'Pick time';
  TimeOfDay _selectedTime = TimeOfDay.now(); 


  final _textEventControler = TextEditingController();
  final _textDescControler = TextEditingController();

  DateTime convertDateFromString(String strdate) {
    DateTime dt = DateTime.parse(strdate);
    return dt;
  }

  Future _pickDate() async {
    DateTime datepick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));
    if (datepick != null)
      setState(() {
        //_selectedDate = datepick.toString();
        _selectedDate = datepick;
      });
  }

  Future _pickTime() async {
    TimeOfDay timepick = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());
    if (timepick != null) {
      setState(() {
        _selectedTime = timepick;
        //_selectedTime = timepick.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Database>(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
              child: Text(
            "Add new event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
          SizedBox(
            height: 24,
          ),
          CustomTextField(
              labelText: 'Enter event name', controller: _textEventControler),
          SizedBox(height: 12),
          CustomTextField(
              labelText: 'Enter description', controller: _textDescControler),
          SizedBox(height: 12),
          CustomDateTimePicker(
            icon: Icons.date_range,
            onPressed: _pickDate,
            //value: _selectedDate,
            value: new DateFormat("dd-MM-yyyy").format(_selectedDate),
          ),
          CustomDateTimePicker(
            icon: Icons.access_time,
            onPressed: _pickTime, 
            //value: new DateFormat("jm").format(_selectedDate), 
            value: formatTimeOfDay(_selectedTime),
          ),
          SizedBox(
            height: 24,
          ),
          CustomModalActionButton(
            onClose: () {
              Navigator.of(context).pop();
            },
            onSave: () {
              if (_textEventControler.text == "" ||
                  _textDescControler.text == "") {
                print("data not found");
              } else {
                provider
                    .insertTodoEntries(new TodoData(
                        //date: convertDateFromString(_selectedDate),
                        date: _selectedDate,
                        time: formatTimeToDate(_selectedTime),
                        isFinish: false,
                        task: _textEventControler.text,
                        description: _textDescControler.text,
                        todoType: TodoType.TYPE_EVENT.index,
                        id: null))
                    .whenComplete(() => Navigator.of(context).pop());
              }
            },
          )
        ],
      ),
    );
  }



String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
}

DateTime formatTimeToDate( TimeOfDay t){ 
  final now = new DateTime.now();
  return new DateTime(now.year, now.month, now.day, t.hour, t.minute);
}

String formatTimeOfDayd(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
}

TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}



}
