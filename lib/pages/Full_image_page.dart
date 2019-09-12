import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rewalls/blocs/image_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../keys.dart';

class FullImagePage extends StatefulWidget {
  @override
  _FullImagePageState createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  // no idea how you named your data class...
  String home = "Home Screen", lock = "Lock Screen", both = "Both Screen";
  bool panelState = false;
  bool isFirstLoad = true;

  Stream<String> progressString;
  double res = 0;
  bool downloading = false;
  var result = "Waiting to set wallpaper";

  @override
  void initState() {
    super.initState();
  }

  _toastMsg(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _panelOpen() {
    setState(() {
      panelState = true;
    });
  }

  void _panelClosed() {
    if (isFirstLoad == true) {
      isFirstLoad = false;
      return;
    }
    setState(() {
      panelState = false;
    });
  }

  _launchURL(urlLink) async {
    String url = urlLink;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    final ImageBloc imageBloc = Provider.of<ImageBloc>(context);
    if (imageBloc.imageSingle == null) Navigator.of(context).pop();
    return Scaffold(
      body: SlidingUpPanel(
        onPanelOpened: _panelOpen,
        onPanelClosed: _panelClosed,
        minHeight: 80,
        panel: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              color: Colors.black87,
            ),
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    child: Icon(panelState == false
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                imageBloc.imageSingle.user.profileImage.medium),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child:
                                        Text(imageBloc.imageSingle.user.name)),
                                onTap: () {
                                  _launchURL(
                                      imageBloc.imageSingle.user.links.html);
                                }),
                            InkWell(
                                child: Text('Unsplash'),
                                onTap: () {
                                  _launchURL('https://unsplash.com');
                                }),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                      child: Row(
                        children: <Widget>[
                          imageBloc.imageSingle.user.bio != null ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'Bio',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(imageBloc.imageSingle.user.bio)
                              ],
                            ),
                          ) : Text('')
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )),
        body: Stack(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    imageUrl: imageBloc.imageSingle.urls.regular,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: imageBloc.imageSingle.id,
                      child: CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: imageBloc.imageSingle.urls.regular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 0.0),
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white54,
                            )),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        borderRadius: radius,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.list_view,
        curve: Curves.ease,
        overlayOpacity: 0.3,
        tooltip: 'Speed Dial',
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        elevation: 16.0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.stay_primary_portrait),
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              label: 'Both',
              labelBackgroundColor: Colors.black87,
              onTap: () {
                _toastMsg('Downloading...');
                progressString = Wallpaper.ImageDownloadProgress(
                    '${imageBloc.imageSingle.links.download}?client_id=${Keys.UNSPLASH_API_CLIENT_ID}');
                progressString.listen((data) {
                  setState(() {
                    res = double.parse(data.replaceAll(RegExp('%'), ''));
                    downloading = true;
                  });
                  print("DataReceived: " + data);
                }, onDone: () async {
                  both = await Wallpaper.homeScreen();
                  _toastMsg('Wallpaper set successfully');
                  setState(() {
                    downloading = false;
                    both = both;
                  });
                  print("Task Done");
                }, onError: (error) {
                  setState(() {
                    downloading = false;
                  });
                  print("Some Error");
                });
              }),
          SpeedDialChild(
              child: Icon(Icons.screen_lock_portrait),
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              labelBackgroundColor: Colors.black87,
              label: 'Lock Screen',
              onTap: () {
                _toastMsg('Downloading...');
                progressString = Wallpaper.ImageDownloadProgress(
                    '${imageBloc.imageSingle.links.download}?client_id=${Keys.UNSPLASH_API_CLIENT_ID}');
                progressString.listen((data) {
                  setState(() {
                    res = double.parse(data.replaceAll(RegExp('%'), ''));
                    downloading = true;
                  });
                  print("DataReceived: " + data);
                }, onDone: () async {
                  lock = await Wallpaper.homeScreen();
                  _toastMsg('Lockscreen wallpaper set successfully');
                  setState(() {
                    downloading = false;
                    lock = lock;
                  });
                  print("Task Done");
                }, onError: (error) {
                  setState(() {
                    downloading = false;
                  });
                  print("Some Error");
                });
              }),
          SpeedDialChild(
              child: Icon(Icons.add_to_home_screen),
              label: 'Home Screen',
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              labelBackgroundColor: Colors.black87,
              onTap: () {
                _toastMsg('Downloading...');
                progressString = Wallpaper.ImageDownloadProgress(
                    '${imageBloc.imageSingle.links.download}?client_id=${Keys.UNSPLASH_API_CLIENT_ID}');
                progressString.listen((data) {
                  setState(() {
                    res = double.parse(data.replaceAll(RegExp('%'), ''));
                    downloading = true;
                  });
                  print("DataReceived: " + data);
                }, onDone: () async {
                  home = await Wallpaper.homeScreen();
                  _toastMsg('Homescreen wallpaper set successfully');
                  setState(() {
                    downloading = false;
                    home = home;
                  });
                  print("Task Done");
                }, onError: (error) {
                  setState(() {
                    downloading = false;
                  });
                  print("Some Error");
                });
              }),
        ],
      ),
    );
  }
}
