import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'event_entry.dart';
import 'repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFlutterDiary',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Flutter Diary'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<EventEntry> _entries = <EventEntry>[];

  @override
  void initState() {
    super.initState();
    _updateEntries();
  }

  @override
  void dispose() {
    Repository().closeDB();
    super.dispose();
  }

  void _addEntry(int i) async {
    var entry = EventEntry(i, DateTime.now());
    await Repository().addEvent(entry);
    _updateEntries();
  }

  void _deleteEntry(EventEntry entry) async {
    await Repository().deleteEvent(entry);
    _updateEntries();
  }

  void _updateEntries() async {
    var entries = await Repository().getAllEvents();
    setState(() {
      _entries = entries;
    });
  }

  Color _makeColor(int i) => HSVColor
      .fromAHSV(1.0, (i - 1) * 60.0, 0.6, 1.0)
      .toColor();

  List<Widget> _makeRow(double W) {
    double A = W / 7;

    List<Widget> row = <Widget>[];

    for (var i = 1; i <= 6; i++) {
      var btn = SizedBox(
        width: A,
        height: A + 20.0,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: _makeColor(i),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero))
          ),
          onPressed: () => {
            _addEntry(i)
          },
          child: Text(
            '$i',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

      row.add(btn);
    }

    return row;
  }

  ListView _makeListView(BuildContext context) => ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: (_entries.length / 2).ceil(),
      itemBuilder: (BuildContext context, int index) {
        var sublist = _entries.slices(2).toList()[index];
        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: GestureDetector(
                  onLongPress: () {
                    _showDeleteConfirmDialog(context, sublist[0]);
                  },
                  child: Container(
                      height: 50,
                      color: _makeColor(sublist[0].type),
                      child: Center(
                        child: Text(sublist[0].toStringAgo()),
                      )
                  ),
                ),
              ),
            ),
            sublist.length > 1
                ? Flexible(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: GestureDetector(
                  onLongPress: () {
                    _showDeleteConfirmDialog(context, sublist[1]);
                  },
                  child: Container(
                      height: 50,
                      color: _makeColor(sublist[1].type),
                      child: Center(
                        child: Text(sublist[1].toStringAgo()),
                      )
                  ),
                ),
              ),
            )
                : const Spacer()
          ],
        );
      }
  );

  _showDeleteConfirmDialog(BuildContext context, EventEntry entry) {
    // set up the buttons
    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed:  () {
        _deleteEntry(entry);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete entry"),
      content: Text(entry.toStringDateTime()),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: _makeListView(context)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _makeRow(
                    MediaQuery.of(context).size.width
                )
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
