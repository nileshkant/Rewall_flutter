import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:rewalls/blocs/image_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wallpaper/wallpaper.dart';

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
  double res;
  bool downloading = false;
  var result = "Waiting to set wallpaper";

  @override
  void initState() {
    super.initState();

  }

  Future _setWallpaper(url, type) async {
    progressString = Wallpaper.ImageDownloadProgress(url);
    progressString.listen((data) {
      setState(() {
        res = double.parse(data.replaceAll(RegExp('%'), ''));
        downloading = true;
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      String wallpaperType = await Wallpaper.homeScreen();
      if (type == 'home') {
        wallpaperType = await Wallpaper.homeScreen();
      } else if (type == 'lock') {
        wallpaperType = await Wallpaper.lockScreen();
      } else {
        wallpaperType = await Wallpaper.bothScreen();
      }
      setState(() {
        downloading = false;
        type = wallpaperType;
      });
      print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }

  void _panelOpen () {
    setState(() {
          panelState = true;
        });
  }
  void _panelClosed () {
    if (isFirstLoad == true) {
      isFirstLoad = false;
      return;
    }
    setState(() {
          panelState = false;
        });
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  final snackBar = SnackBar(
    content: Text('Yay! A SnackBar!'),
  );
  @override
  Widget build(BuildContext context) {
    final ImageBloc imageBloc = Provider.of<ImageBloc>(context);
    return Scaffold(
      body: SlidingUpPanel(
        onPanelOpened:_panelOpen,
        onPanelClosed:_panelClosed,
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
                    Text(imageBloc.imageSingle.user.name)
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
                      imageBuilder: (context, imageProvider) =>  Container(
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
                  ),),
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
                title:  Container(child: downloading && res < 100 ?  LinearProgressIndicator() : Text('')),
              ),
            ),
          ],
        ),
        borderRadius: radius,
      ),
      floatingActionButton: SpeedDial(
        // // both default to 16
        // marginRight: 18,
        // marginBottom: 40,
        animatedIcon: AnimatedIcons.list_view,
        // animatedIconTheme: IconThemeData(size: 22.0),
        // // this is ignored if animatedIcon is non null
        // // child: Icon(Icons.add),
        // visible: _dialVisible,
        // // If true user is forced to close dial manually
        // // by tapping main button and overlay is not rendered.
        // closeManually: false,
        curve: Curves.ease,
        // overlayColor: Colors.black,
        overlayOpacity: 0.3,
        // onOpen: () => print('OPENING DIAL'),
        // onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        // heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        // elevation: 8.0,
        // shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.stay_primary_portrait),
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              label: 'Both',
              labelBackgroundColor: Colors.black87,
              onTap: () async {
                await _setWallpaper(imageBloc.imageSingle.urls.regular, 'both');
                if (res == 100) {
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.screen_lock_portrait),
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              labelBackgroundColor: Colors.black87,
              label: 'Lock Screen',
              onTap: () async {
                await _setWallpaper(imageBloc.imageSingle.urls.regular, 'lock');
              }),
          SpeedDialChild(
              child: Icon(Icons.add_to_home_screen),
              label: 'Home Screen',
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              labelBackgroundColor: Colors.black87,
              onTap: () async {
               await _setWallpaper(imageBloc.imageSingle.urls.regular, 'home');
              }),
        ],
      ),
    );
  }
}
