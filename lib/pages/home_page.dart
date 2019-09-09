import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:rewalls/blocs/apiCalls.dart';
import 'package:rewalls/blocs/image_bloc.dart';
import 'package:rewalls/models/single_image_model.dart';
import 'package:rewalls/utils/colorChanger.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int perPage = 20, page = 1;
  List<SingleImage> allImageList = new List();
  final items = new List();

  StaggeredTile _buildStaggeredTile(SingleImage image, int columnCount) {
    // calc image aspect ration
    double aspectRatio = image.height.toDouble() / image.width.toDouble();
    // calc columnWidth
    double columnWidth = MediaQuery.of(context).size.width / columnCount;
    // not using [StaggeredTile.fit(1)] because during loading StaggeredGrid is really jumpy.
    return StaggeredTile.extent(1, aspectRatio * columnWidth);
  }

  ScrollController _controller = ScrollController();
  bool loadingImage = false;
  @override
  void initState() {
    super.initState();
    _callApi();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _callApi();
      }
    });
  }

  void _callApi() async {
    try {
      loadingImage = true;
      List<SingleImage> allImageLists =
          await ApiCall.loadImages(page: page, perPage: perPage);
      List<SingleImage> newList;
      if (page > 1) {
        newList = new List.from(allImageList)..addAll(allImageLists);
      } else {
        newList = allImageLists;
      }
      setState(() {
        loadingImage = false;
        allImageList = newList;
        page++;
      });
    } catch (e) {
      print(e);
      loadingImage = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _listOfImage() {
    final ImageBloc imageBloc = Provider.of<ImageBloc>(context);
    return StaggeredGridView.countBuilder(
      controller: _controller,
      crossAxisCount: 2,
      itemCount: allImageList.length,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Hero(
              tag: allImageList[index].id,
              child: Material(
                child: InkWell(
                    onTap: () {
                      imageBloc.showImageDetail(allImageList[index]);
                      Navigator.pushNamed(context, '/second');
                    },
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: FlutterColor(allImageList[index].color)
                                      .withOpacity(0.3),
                                  offset: Offset(3.0, 5.0),
                                  blurRadius: 5.0,
                                )
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10.0),
                                right: Radius.circular(10.0)),
                            color: FlutterColor(allImageList[index].color),
                          )),
                          imageUrl: allImageList[index].urls.regular,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10.0),
                                  right: Radius.circular(10.0)),
                              gradient: LinearGradient(
                                // Where the linear gradient begins and ends
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                // Add one stop for each color. Stops should increase from 0 to 1
                                stops: [0.01, 1],
                                colors: [
                                  // Colors are easy thanks to Flutter's Colors class.
                                  Colors.black87,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 0.0),
                                    child: Icon(
                                      Ionicons.getIconData("md-heart"),
                                      color: Colors.red[700],
                                      size: 20,
                                    )),
                                Expanded(
                                    child: Text(
                                  allImageList[index].likes.toString(),
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) =>
          _buildStaggeredTile(allImageList[index], 2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.5;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewall'),
      ),
      body: Padding(padding: const EdgeInsets.all(4.0), child: !loadingImage ?  _listOfImage() : LinearProgressIndicator()),
    );
  }
}
