import 'package:flutter/material.dart';

import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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


class Node {
  int value;
  late Node left;
  late Node right;

  Node(this.value);
}

class GCBinaryTree {
  static int kStretchTreeDepth    = 18;	// about 16Mb
  static int kLongLivedTreeDepth  = 16;  // about 4Mb
  static int kArraySize  = 500000;  // about 4Mb
  static int kMinTreeDepth = 4;
  static int kMaxTreeDepth = 16;

  // Nodes used by a tree of a given size
  static int treeSize(int i) {
    return ((1 << (i + 1)) - 1);
  }

  // Number of iterations to use for a given tree depth
  static double numIterations(int i) {
    return 2 * treeSize(kStretchTreeDepth) / treeSize(i);
  }

  // Build tree top down, assigning to older objects.
  static void populateTree(Node? thisNode, int depth, int value) {
    if (depth == 0) {
      return;
    } else {
      depth = depth - 1;
      value = value * 2;
      thisNode?.left = Node(value);
      thisNode?.right = Node(value + 1);
      populateTree(thisNode?.left, depth, value);
      populateTree(thisNode?.right, depth, value);
    }
  }

  // Build tree bottom-up
  static Node makeTree(int depth, int value) {
    if (depth == 0) {
      return Node(value);
    } else {
      Node node = Node(value);
      node.left = makeTree(depth - 1, value * 2);
      node.right = makeTree(depth - 1, value * 2 + 1);
      return node;
    }
  }

  static void timeConstruction(int depth) {
    Node root;
    double iNumIters = numIterations(depth);
    Node? tempTree;

    // print("Creating $iNumIters trees of depth $depth");

    DateTime tStart = DateTime.now();
    for (int i = 0; i < iNumIters; ++i) {
      tempTree = Node(1);
      populateTree(tempTree, depth, 1);
      tempTree = null;
    }
    DateTime tFinish = DateTime.now();
    // print("\tTop down construction took ${tFinish.difference(tStart).inMilliseconds} msecs");

    tStart = DateTime.now();
    for (int i = 0; i < iNumIters; ++i) {
      tempTree = makeTree(depth, 1);
      tempTree = null;
    }
    tFinish = DateTime.now();
    // print("\tBottom up construction took ${tFinish.difference(tStart).inMilliseconds} msecs");
  }

  static void testGC() {
    Node	root;
    Node	longLivedTree;
    Node?	tempTree;
    DateTime	tStart, tFinish;
    BigInt	tElapsed;


    // print("Garbage Collector Test");
    // print("Stretching memory with a binary tree of depth $kStretchTreeDepth");
    tStart = DateTime.now();

    // Stretch the memory space quickly
    tempTree = makeTree(kStretchTreeDepth, 1);
    tempTree = null;

    // Create a long lived object
    // print(" Creating a long-lived binary tree of depth $kLongLivedTreeDepth ");
    longLivedTree = new Node(0);
    populateTree(longLivedTree, kLongLivedTreeDepth, 1);

    // Create long-lived array, filling half of it
    // print(" Creating a long-lived array of $kArraySize doubles");
    List<double> array = List.filled(kArraySize, 0.0, growable: false);
    for (int i = 0; i < kArraySize/2; ++i) {
      array[i] = 1.0/i;
    }

    for (int d = kMinTreeDepth; d <= kMaxTreeDepth; d += 2) {
      timeConstruction(d);
    }

    tFinish = DateTime.now();
    print("GC Test Completed in ${tFinish.difference(tStart).inMilliseconds} ms.");
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      GCBinaryTree.testGC();
    });
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              key: Key('counter'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        key: Key('increment'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
