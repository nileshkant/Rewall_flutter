import 'dart:convert';
import 'dart:io';

import 'package:rewalls/models/single_image_model.dart';

import '../keys.dart';

class ApiCall {

  static Future<List<SingleImage>> loadImages({int page = 1, int perPage = 10}) async {
    String url = 'https://api.unsplash.com/photos?page=$page&per_page=$perPage';
    // receive image data from unsplash
    var data = await _getImageData(url);
    // generate UnsplashImage List from received data
    List<SingleImage> imageLists =
        List<SingleImage>.generate(data.length, (index) {
      return SingleImage.fromJson(data[index]);
    });
    // return images
    // if (page == 1) {
    //   return imageList = imageLists;
    // } else if (page > 1) {
    // List<SingleImage> newList = new List.from(_imageList)..addAll(imageLists);
    return imageLists;
  }

    static dynamic _getImageData(String url) async {
    // setup http client
    HttpClient httpClient = HttpClient();
    // setup http request
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    // pass the client_id in the header
    request.headers
        .add('Authorization', 'Client-ID ${Keys.UNSPLASH_API_CLIENT_ID}');

    // wait for response
    HttpClientResponse response = await request.close();
    // Process the response
    if (response.statusCode == 200) {
      // response: OK
      // decode JSON
      String json = await response.transform(utf8.decoder).join();
      // return decoded json
      return jsonDecode(json);
    } else {
      // something went wrong :(
      print("Http error: ${response.statusCode}");
      // return empty list
      return [];
    }
  }
}