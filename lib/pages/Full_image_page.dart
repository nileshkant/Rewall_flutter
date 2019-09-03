import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewalls/blocs/image_bloc.dart';

class FullImagePage extends StatefulWidget {
  @override
  _FullImagePageState createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  // no idea how you named your data class...

  @override
  Widget build(BuildContext context) {
    final ImageBloc imageBloc = Provider.of<ImageBloc>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Image Details'),),
        body: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        CircularProgressIndicator(),
                    imageUrl: imageBloc.imageSingle.urls.regular,
                  ),
                ),
              ),
            Container(
              
              height: 80,
              child: Text('Phottttooo', style: TextStyle(color: Colors.white, fontSize: 20.0),),
            )
          ],
        ),
      );
    }
  }
