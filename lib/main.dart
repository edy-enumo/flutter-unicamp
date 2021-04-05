//import 'dart:ffi';
//import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Thor RPG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Thor {
  List<int> cord;
  String face;
  bool alive;
  //int name = 0;

  Thor(List<int> cord, String face, bool alive) {
    this.alive = true;
    this.cord = [0, 0];
    this.face = "images/thorDown01.png";
  }
}

class Axe {
  List<int> cord;
  bool alive;
  String face;

  Axe(List<int> cord, bool alive) {
    this.face = "images/axe01.png";
    this.cord = cord;
    this.alive = alive;
  }
}

class Thanos {
  List<int> cord;
  bool alive;
  String face;

  Thanos(List<int> cord, String face, bool alive) {
    this.face = "images/thanos01.png";
    this.cord = cord;
    this.alive = alive;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _mapSize = 8;
  int _counter = 0;
  List<int> _cordThor = [0, 0];

  Thor _myThor = Thor([0, 0], "images/thorDown01.png", true);
  Axe _myAxe = Axe([7, 7], true);
  Thanos _myThanos = Thanos([4, 4], "images/thanos01.png", true);

  void _restart() {
    setState(() {
      _myThor = Thor([0, 0], "images/thorDown01.png", true);
      _myAxe = Axe([7, 7], true);
      _myThanos = Thanos([4, 4], "images/thanosDead.png", true);
    });
  }

  void _checkThanosFight() {
    print("_myThor.cord");
    print(_myThor.cord);
    print("_myThanos.cord");
    print(_myThanos.cord);
    print("------------");

    if (_myThanos.alive == true) {
      if (_myThor.cord[0] == _myThanos.cord[0]) {
        if ((_myThor.cord[1] - 1 == _myThanos.cord[1]) ||
            (_myThor.cord[1] + 1 == _myThanos.cord[1])) {
          print("eae");
          print(_myAxe.alive);
          if (_myAxe.alive == false) {
            //Como o Thor esta com o machado, ele ganha
            _myThanos.alive = false;
            _myThanos.face = "images/thanosDead.png";
          } else {
            //Sem o machado o Thor nao consegue ganhar
            _myThor.alive = false;
            _myThor.face = "images/thorDead.png";
          }
        }
      } else if (_myThor.cord[1] == _myThanos.cord[1]) {
        if ((_myThor.cord[0] - 1 == _myThanos.cord[0]) ||
            (_myThor.cord[0] + 1 == _myThanos.cord[0])) {
          print("eae");
          print(_myAxe.alive);
          if (_myAxe.alive == false) {
            //Como o Thor esta com o machado, ele ganha
            _myThanos.alive = false;
            _myThanos.face = "images/thanosDead.png";
          } else {
            //Sem o machado o Thor nao consegue ganhar
            _myThor.alive = false;
            _myThor.face = "images/thorDead.png";
          }
        }
      }
    }
  }

  void _checkGetItem() {
    if (_myAxe.alive == true) {
      if (_myThor.cord[0] == _myAxe.cord[0]) {
        if ((_myThor.cord[1] - 1 == _myAxe.cord[1]) ||
            (_myThor.cord[1] + 1 == _myAxe.cord[1])) {
          _myAxe.alive = false;
          print("chegou");
          print(_myThor.cord);
          print(_myAxe.cord);
        }
      } else if (_myThor.cord[1] == _myAxe.cord[1]) {
        if ((_myThor.cord[0] - 1 == _myAxe.cord[0]) ||
            (_myThor.cord[0] + 1 == _myAxe.cord[0])) {
          _myAxe.alive = false;
          print("chegou2");
          print(_myThor.cord);
          print(_myAxe.cord);
        }
      }
    }
  }

  void _thorMoveUp() {
    setState(() {
      if ((_myThor.cord[1] - 1) >= 0) {
        if (_myThor.alive == true) {
          if ((_myThor.cord[1] - 1 != _myThanos.cord[1]) ||
              (_myThor.cord[0] != _myThanos.cord[0])) {
            _myThor.cord[1]--;
            _checkGetItem();
            _checkThanosFight();

            print(_mapSize);
            print(_myThor.cord);

            if (_myThor.alive == true) {
              if (_myThor.face == "images/thorUp01.png") {
                _myThor.face = "images/thorUp02.png";
              } else if (_myThor.face == "images/thorUp02.png") {
                _myThor.face = "images/thorUp03.png";
              } else {
                _myThor.face = "images/thorUp01.png";
              }
            }
          }
        }
      }
    });
  }

  void _thorMoveDown() {
    setState(() {
      if ((_myThor.cord[1] + 1) < _mapSize) {
        if (_myThor.alive == true) {
          if ((_myThor.cord[1] + 1 != _myThanos.cord[1]) ||
              (_myThor.cord[0] != _myThanos.cord[0])) {
            _myThor.cord[1]++;
            _checkGetItem();
            _checkThanosFight();

            print(_mapSize);
            print(_myThor.cord);

            if (_myThor.alive == true) {
              if (_myThor.face == "images/thorDown01.png") {
                _myThor.face = "images/thorDown02.png";
              } else if (_myThor.face == "images/thorDown02.png") {
                _myThor.face = "images/thorDown03.png";
              } else {
                _myThor.face = "images/thorDown01.png";
              }
            }
          }
        }
      }
    });
  }

  void _thorMoveLeft() {
    setState(() {
      if ((_myThor.cord[0] - 1) >= 0) {
        if (_myThor.alive == true) {
          if ((_myThor.cord[1] != _myThanos.cord[1]) ||
              (_myThor.cord[0] - 1 != _myThanos.cord[0])) {
            _myThor.cord[0]--;
            _checkGetItem();
            _checkThanosFight();

            print(_mapSize);
            print(_myThor.cord);

            if (_myThor.alive == true) {
              if (_myThor.face == "images/thorLeft01.png") {
                _myThor.face = "images/thorLeft02.png";
              } else if (_myThor.face == "images/thorLeft02.png") {
                _myThor.face = "images/thorLeft03.png";
              } else {
                _myThor.face = "images/thorLeft01.png";
              }
            }
          }
        }
      }
    });
  }

  void _thorMoveRight() {
    setState(() {
      if ((_myThor.cord[0] + 1) < _mapSize) {
        if (_myThor.alive == true) {
          if ((_myThor.cord[1] != _myThanos.cord[1]) ||
              (_myThor.cord[0] + 1 != _myThanos.cord[0])) {
            _myThor.cord[0]++;
            _checkGetItem();
            _checkThanosFight();

            print(_mapSize);
            print(_myThor.cord);

            if (_myThor.alive == true) {
              if (_myThor.face == "images/thorRight01.png") {
                _myThor.face = "images/thorRight02.png";
              } else if (_myThor.face == "images/thorRight02.png") {
                _myThor.face = "images/thorRight03.png";
              } else {
                _myThor.face = "images/thorRight01.png";
              }
            }
          }
        }
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decreaseCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: _restart,
            child: Text("Restart"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              createRPGMap2(_mapSize, _myThor, _myAxe, _myThanos),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: FractionalOffset(0.1, 1),
            child: FloatingActionButton(
              onPressed: _thorMoveLeft,
              tooltip: 'Increment',
              child: Icon(Icons.keyboard_arrow_left_outlined),
            ),
          ),
          Align(
            alignment: FractionalOffset(0.4, 1),
            child: FloatingActionButton(
              onPressed: _thorMoveDown,
              tooltip: 'Increment',
              child: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          Align(
            alignment: FractionalOffset(0.7, 1),
            child: FloatingActionButton(
              onPressed: _thorMoveUp,
              tooltip: 'Increment',
              child: Icon(Icons.keyboard_arrow_up_outlined),
            ),
          ),
          Align(
            alignment: FractionalOffset(1, 1),
            child: FloatingActionButton(
              onPressed: _thorMoveRight,
              tooltip: 'Increment',
              child: Icon(Icons.keyboard_arrow_right_outlined),
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Column widgetCreateRPGMap(int mapSize, cordThor) {
  return Column(
    children: createRows(mapSize, cordThor),
  );
}

List<Widget> createRows(int mapSize, cordThor) {
  List<Widget> rows = [];

  for (int y = 0; y < mapSize; y++) {
    Row myRow = Row(
      children: createCointainers(mapSize, cordThor),
    );
    rows.add(myRow);
  }

  return rows;
}

Column createRPGMap2(int mapSize, _myThor, _myAxe, _myThanos) {
  print(_myThor.cord);
  Column rpgMap;

  List<Widget> rows = [];

  //Create Rows
  for (int y = 0; y < mapSize; y++) {
    List<Widget> containers = [];

    //Crete each Item of Row
    for (int x = 0; x < mapSize; x++) {
      Container currentContainer;
      //Thor Container
      if ((x == _myThor.cord[0]) && (y == _myThor.cord[1])) {
        currentContainer = Container(
          margin: const EdgeInsets.all(1.5),
          height: 37.0,
          width: 37.0,
          decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
              image: AssetImage(_myThor.face),
              fit: BoxFit.fill,
            ),
            //shape: BoxShape.circle,
          ),
        );
      } //Axe Container
      else if ((x == _myAxe.cord[0]) &&
          (y == _myAxe.cord[1]) &&
          (_myAxe.alive == true)) {
        currentContainer = Container(
          margin: const EdgeInsets.all(1.5),
          height: 37.0,
          width: 37.0,
          decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
              image: AssetImage(_myAxe.face),
              fit: BoxFit.fill,
            ),
            //shape: BoxShape.circle,
          ),
        );
      } //Thanos Container
      else if ((x == _myThanos.cord[0]) && (y == _myThanos.cord[1])) {
        currentContainer = Container(
          margin: const EdgeInsets.all(1.5),
          height: 37.0,
          width: 37.0,
          decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
              image: AssetImage(_myThanos.face),
              fit: BoxFit.fill,
            ),
            //shape: BoxShape.circle,
          ),
        );
      } else {
        currentContainer = Container(
          margin: const EdgeInsets.all(1.5),
          height: 37.0,
          width: 37.0,
          color: Colors.black12,
        );
      }

      containers.add(currentContainer);
    }

    Row currentRow = Row(
      children: containers,
    );

    rows.add(currentRow);
  }

  //MAP is a Column of multiple rows
  rpgMap = Column(
    children: rows,
  );

  return rpgMap;
}

List<Widget> createCointainers(int mapSize, cordThor) {
  List<Widget> containers = [];
  List<List<Widget>> myNew = [[]];

  for (int x = 0; x < mapSize; x++) {
    Container myContainer = Container(
      margin: const EdgeInsets.all(1.5),
      height: 37.0,
      width: 37.0,
      color: Colors.black12,
    );
    containers.add(myContainer);
  }

  return containers;
}
