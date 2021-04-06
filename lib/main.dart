//import 'dart:ffi';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

var random = new Random();
int _mapSize = 8;

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
  int imageCount = 0;

  Thor() {
    this.alive = true;
    this.cord = [random.nextInt(_mapSize), random.nextInt(_mapSize)];
    this.face = "images/thorDown01.png";
  }

  void nextImageCount() {
    imageCount = (imageCount + 1) % 3;
  }

  void setImageDirection(direction) {
    nextImageCount();
    switch (direction) {
      case 'up':
        face = "images/thorUp0" + (imageCount + 1).toString() + ".png";
        break;
      case 'down':
        face = "images/thorDown0" + (imageCount + 1).toString() + ".png";
        break;
      case 'left':
        face = "images/thorLeft0" + (imageCount + 1).toString() + ".png";
        break;
      case 'right':
        face = "images/thorRight0" + (imageCount + 1).toString() + ".png";
        break;
    }
  }

  void die() {
    alive = false;
    face = "images/thorDead.png";
  }
}

class Axe {
  List<int> cord;
  bool alive;
  String face;

  Axe() {
    this.face = "images/axe01.png";
    this.cord = [random.nextInt(_mapSize), random.nextInt(_mapSize)];
    this.alive = true;
  }
}

class Thanos {
  List<int> cord;
  bool alive;
  String face;

  Thanos() {
    this.face = "images/thanos01.png";
    this.cord = [random.nextInt(_mapSize), random.nextInt(_mapSize)];
    this.alive = true;
  }

  void die() {
    alive = false;
    face = "images/thanosDead.png";
  }
}

bool compareCoords(cord1, cord2) {
  return cord1[0] == cord2[0] && cord1[1] == cord2[1];
}

List newMatrix(row, column) {
  return List.generate(
      row, (i) => List.generate(column, (j) => false, growable: false),
      growable: false);
}

List calculateThorPath(Thor thor, Axe axe, Thanos thanos, int mapsize) {
  var thorPath = newMatrix(mapsize, mapsize);
  List<int> thorCord = [thor.cord[0], thor.cord[1]];

  while (thorCord[0] != axe.cord[0] || thorCord[1] != axe.cord[1]) {
    thorPath[thorCord[0]][thorCord[1]] = true;
    if (thorCord[0] > axe.cord[0]) {
      thorCord[0] = thorCord[0] - 1;
    } else if (thorCord[0] < axe.cord[0]) {
      thorCord[0] = thorCord[0] + 1;
    } else if (thorCord[1] > axe.cord[1]) {
      thorCord[1] = thorCord[1] - 1;
    } else if (thorCord[1] < axe.cord[1]) {
      thorCord[1] = thorCord[1] + 1;
    }
  }
  thorPath[thorCord[0]][thorCord[1]] = true;

  return thorPath;
}

class _MyHomePageState extends State<MyHomePage> {
  Thor _myThor = Thor();
  Axe _myAxe = Axe();
  Thanos _myThanos = Thanos();
  var thorPath;

  _MyHomePageState() {
    thorPath = calculateThorPath(_myThor, _myAxe, _myThanos, _mapSize);
  }

  void _restart() {
    setState(() {
      _myThor = Thor();
      _myAxe = Axe();
      while (compareCoords(_myThor.cord, _myAxe.cord)) {
        print('recriando machado');
        _myAxe = Axe();
      }

      _myThanos = Thanos();
      while (compareCoords(_myThor.cord, _myThanos.cord) ||
          compareCoords(_myAxe.cord, _myThanos.cord)) {
        print('recriando thanos');
        _myThanos = Thanos();
      }
      moveThor("");
    });
  }

  void incrementMapSize(int num) {
    if (_mapSize > 2 || num > 0) {
      _mapSize += num;
    }
    _restart();
  }

  int canMove(nextCord) {
    //0 = fim do mapa; 1 = pode andar; 2 = encontrou thanos; 3 = encontrou o machado
    if (nextCord[0] < 0 ||
        nextCord[1] < 0 ||
        nextCord[0] >= _mapSize ||
        nextCord[1] >= _mapSize) return 0;

    if (compareCoords(nextCord, _myThanos.cord)) return 2;
    if (compareCoords(nextCord, _myAxe.cord)) return 3;
    return 1;
  }

  void moveThor(direction) {
    var nextCoord = [_myThor.cord[0], _myThor.cord[1]];
    switch (direction) {
      case 'up':
        nextCoord[1]--;
        break;
      case 'down':
        nextCoord[1]++;
        break;
      case 'left':
        nextCoord[0]--;
        break;
      case 'right':
        nextCoord[0]++;
        break;
    }

    setState(() {
      if (_myThor.alive) {
        _myThor.setImageDirection(direction);

        int moveAction = canMove(nextCoord);
        if (moveAction == 1) {
          _myThor.cord = nextCoord;
        }
        if (moveAction == 2) {
          if (_myAxe.alive) {
            _myThor.die();
          } else {
            _myThanos.die();
          }
        }
        if (moveAction == 3) {
          _myThor.cord = nextCoord;
          _myAxe.alive = false;
        }
      }
      thorPath = calculateThorPath(_myThor, _myAxe, _myThanos, _mapSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          FlatButton(
            textColor: Colors.white,
            onPressed: _restart,
            child: Text("Restart"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                color: Colors.green,
                child: Center(
                  child: createRPGMap2(_mapSize, _myThor, _myAxe, _myThanos,
                      thorPath, MediaQuery.of(context).size.width),
                )),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: FloatingActionButton(
                    onPressed: () => {incrementMapSize(-1)},
                    child: Icon(Icons.remove),
                    backgroundColor: Colors.green,
                  ),
                )),
                Expanded(
                    child: Container(
                  child: FloatingActionButton(
                    onPressed: () => {moveThor('up')},
                    child: Icon(Icons.keyboard_arrow_up_outlined),
                  ),
                )),
                Expanded(
                    child: Container(
                  child: FloatingActionButton(
                    onPressed: () => {incrementMapSize(1)},
                    child: Icon(Icons.add),
                    backgroundColor: Colors.green,
                  ),
                )),
              ],
            ),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: FloatingActionButton(
                    onPressed: () => {moveThor('left')},
                    child: Icon(Icons.keyboard_arrow_left_outlined),
                  ),
                )),
                Expanded(
                    child: Container(
                  child: FloatingActionButton(
                    onPressed: () => {moveThor('down')},
                    child: Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                )),
                Expanded(
                    child: Container(
                  child: FloatingActionButton(
                    onPressed: () => {moveThor('right')},
                    child: Icon(Icons.keyboard_arrow_right_outlined),
                  ),
                )),
              ],
            ),
          )
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Column createRPGMap2(int mapSize, _myThor, _myAxe, _myThanos, thorPath, width) {
  Column rpgMap;

  List<Widget> rows = [];

  double boxSize = width / mapSize - 3;
  //Create Rows
  for (int y = 0; y < mapSize; y++) {
    List<Widget> containers = [];

    //Crete each Item of Row
    for (int x = 0; x < mapSize; x++) {
      Container currentContainer;
      //Thor Container

      var image = (x == _myThor.cord[0]) && (y == _myThor.cord[1])
          ? _myThor.face
          : (x == _myAxe.cord[0]) &&
                  (y == _myAxe.cord[1]) &&
                  (_myAxe.alive == true)
              ? _myAxe.face
              : (x == _myThanos.cord[0]) && (y == _myThanos.cord[1])
                  ? _myThanos.face
                  : "images/transparent.png";

      currentContainer = Container(
        margin: const EdgeInsets.all(1.5),
        height: boxSize,
        width: boxSize,
        decoration: BoxDecoration(
          color: thorPath[x][y] && _myAxe.alive ? Colors.blue : Colors.black26,
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fill,
          ),
          //shape: BoxShape.circle,
        ),
      );

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
