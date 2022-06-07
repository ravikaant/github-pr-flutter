import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:github/components/pullRequests.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github PRs',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool expanded = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) => {
      setState(() {
        expanded = true;
      }),
      Future.delayed(Duration(seconds: kIsWeb ? 0 : 2, milliseconds: 700)).then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => PullRequests()), (route) => false)
      })
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(expanded ? 12 : 24),
          color: Colors.black12),
      child: Center(
        child:
        AnimatedContainer(
          curve: Curves.bounceOut,
          duration: const Duration(seconds: 2, milliseconds: 500),
          height: expanded ? MediaQuery.of(context).size.height : 100,
          width: expanded ? MediaQuery.of(context).size.width : 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Image(image: AssetImage('assets/self-help-dark.png')),
              LinearProgressIndicator(
                semanticsLabel: 'Loading',
              ),
            ],
          ),

        ),

      ),
    );
  }
}
