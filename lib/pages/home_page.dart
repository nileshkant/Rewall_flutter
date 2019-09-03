import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:rewalls/blocs/apiCalls.dart';
import 'package:rewalls/blocs/image_bloc.dart';
import 'package:rewalls/models/single_image_model.dart';

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

  @override
    void initState() {
      super.initState();
      _callApi();
      _controller.addListener(() {
        if(_controller.position.pixels == _controller.position.maxScrollExtent) {
          _callApi();
        }
      });
    }

  void _callApi () async {
    try {
    List<SingleImage> allImageLists = await ApiCall.loadImages(page: page, perPage: perPage);
    List<SingleImage> newList;
    if(page > 1) {
      newList = new List.from(allImageList)..addAll(allImageLists);
    } else {
      newList = allImageLists;
    }
      setState(() {
        allImageList = newList;
        page++;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _listOfImage () {
    final ImageBloc imageBloc = Provider.of<ImageBloc>(context);
    if (allImageList == null || allImageList.length > 0) {
      return StaggeredGridView.countBuilder(
          controller: _controller,
          crossAxisCount: 2,
          itemCount: allImageList.length,
          itemBuilder: (BuildContext context, int index) => Container(
            child: Center(
              child: InkWell(
                onTap: () {
                  imageBloc.showImageDetail(allImageList[index]);
                  Navigator.pushNamed(context, '/second');
                },
                child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: allImageList[index].urls.small,
                ),
              ),
            ),
          ),
          staggeredTileBuilder: (int index) =>
              _buildStaggeredTile(allImageList[index], 2),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        );
    } else {
      Text('Loading...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewall'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: _listOfImage()
      ),
    );
  }
}
