import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

final connector = WalletConnect(
  bridge: 'https://bridge.walletconnect.org',
  clientMeta: PeerMeta(
    name: 'WalletConnect',
    description: 'WalletConnect Developer App',
    url: 'https://walletconnect.org',
    icons: [
      'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
    ],
  ),
);

var walletUri = "";

void main() async {
  connector.on('connect', (session) => print(session));
  connector.on('session_update', (payload) => print(payload));
  connector.on('disconnect', (session) => print(session));
  if (!connector.connected) {
    connector.createSession(
      chainId: 4160,
      onDisplayUri: (uri) => {
        walletUri = uri,
        print(uri)
      },
    );
  }
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const platform = MethodChannel('open_dynamic_link');

  Future<void> openDynamicLink(dynamicLink) async {
    try {
      await platform.invokeListMethod(
          'openDynamicLink',
          dynamicLink
      );
    } on PlatformException catch (e) {
      print("call native open url error: " + e.details);
    }
  }

  void _incrementCounter() {
    var dynamicLink = 'https://dosivault.page.link/muUh?uri_wc=' +
        Uri.encodeComponent(walletUri);
    print("wc url: " + dynamicLink);
    openDynamicLink(dynamicLink);
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
