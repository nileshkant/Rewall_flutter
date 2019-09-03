import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewalls/blocs/image_bloc.dart';
import 'package:rewalls/pages/Full_image_page.dart';
import 'package:rewalls/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageBloc>.value(
          value: ImageBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => Homepage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/second': (context) => FullImagePage(),
        },
      ),
    );
  }
}
