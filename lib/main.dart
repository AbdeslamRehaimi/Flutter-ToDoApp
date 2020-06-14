import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/database.dart';
import 'package:todoapp/pages/memo_page.dart';
import 'package:todoapp/pages/add_memo_page.dart';
import 'package:todoapp/pages/add_event_page.dart';
import 'package:todoapp/pages/add_task_page.dart';
import 'package:todoapp/pages/event_page.dart';
import 'package:todoapp/pages/task_page.dart';
import 'package:todoapp/widgets/custom_button.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is where the app runs.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //charger la class database using provider
      providers: [ChangeNotifierProvider<Database>(builder: (_) => Database())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        //theme de l'interface colors and some fonts 
        theme:
            ThemeData(primarySwatch: Colors.teal, fontFamily: "Montserrat"),
        //calling interface to show !!!
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //A page controller to manipulate which page is visible in a a view pour user
  PageController _pageController = PageController();
  // btn +
  double currentPage = 0;

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });

    final dt = new DateTime.now();
    String dta = DateFormat('d').format(dt);

    //implements basic material design visual
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 35,
            color: Theme.of(context).accentColor,
          ),
          Positioned(
            right: 0,
            child: Text(
              //num date aujourdhui
              dta,
              style: TextStyle(fontSize: 200, color: Color(0x10000000)),
            ),
          ),
          _mainContent(context),
        ],
      ),
      //Button plus action .. add events/tasks
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    //which Dialog to add event or task or memo to show to show
                    //if else
                    child:
                    //currentPage == 0 ?  AddTaskPage() : currentPage == 1 ? AddEventPage() : AddMemoPage(),
                    currentPage == 0 ?  AddTaskPage() :  AddEventPage(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))));
              });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    final dt = new DateTime.now();
    String dta = DateFormat('EEEE').format(dt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            //date aujourdhiu
            dta,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _button(context),
        ),
        //Show page content / the main veiw
        Expanded(
            child: PageView(
          controller: _pageController,
          children: <Widget>[TaskPage(), EventPage()],
          //Declare All my views to show
          //children: <Widget>[TaskPage(), EventPage(), MemoPage()],
        ))
      ],
    );
  }

//Button navigation
  Widget _button(BuildContext context) {
    return Row(
      children: <Widget>[

        Expanded(
            child: CustomButton(
          onPressed: () {
            _pageController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceInOut);
          },
          buttonText: "Tasks",
          color:
              //currentPage < 0.5 ? Theme.of(context).accentColor : Colors.white,
              currentPage == 0 ? Theme.of(context).accentColor : Colors.white,
          textColor:
              //currentPage < 0.5 ? Colors.white : Theme.of(context).accentColor,
              currentPage == 0 ? Colors.white : Theme.of(context).accentColor,
          //borderColor: currentPage < 0.5
          borderColor: currentPage == 0
              ? Colors.transparent
              : Theme.of(context).accentColor,
        )),



        SizedBox(
          width: 32,
          //width: 8,
        ),



        Expanded(
            child: CustomButton(
          onPressed: () {
            _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceInOut);
      
          },
          buttonText: "Events",
          color:
              currentPage == 1 ? Theme.of(context).accentColor : Colors.white,
              //currentPage > 0.5 ? Theme.of(context).accentColor : Colors.white,
          textColor:
              currentPage == 1 ? Colors.white : Theme.of(context).accentColor,
              //currentPage > 0.5 ? Colors.white : Theme.of(context).accentColor,
          //borderColor: currentPage > 0.5
          borderColor: currentPage == 1
              ? Colors.transparent
              : Theme.of(context).accentColor,
        ))
        
        /*
        ,
        SizedBox(
          //width: 32,
          width: 8,
        ),
        Expanded(
            child: CustomButton(
          onPressed: () {
            _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceInOut);
          },
          buttonText: "Memos",
          color:
              currentPage == 2 ? Theme.of(context).accentColor : Colors.white,
              //currentPage < 0 ? Theme.of(context).accentColor : Colors.white,
          textColor:
              currentPage == 2 ? Colors.white : Theme.of(context).accentColor,
              //currentPage < 0 ? Colors.white : Theme.of(context).accentColor,
          //borderColor: currentPage < 0
          borderColor: currentPage == 2
              ? Colors.transparent
              : Theme.of(context).accentColor,
        ))
*/


      ],
    );
  }
}
