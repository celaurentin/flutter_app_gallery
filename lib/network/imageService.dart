import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_app_gallery/models/webImageList.dart';
import 'package:flutter_app_gallery/models/webimage.dart';
import 'package:flutter_app_gallery/network/endpoints.dart';
import 'package:http/http.dart' as http;

//Web service for calling picsum api
class ImageWebService{
  final http.Client _client;
  final EndPoints endPoints = EndPoints();

  ImageWebService(this._client);
  
  //HINT: Consider creating an api call to collect a list of web image info (endpoints.getListOfImages)
  Future<WebImageList> fetchListOfImages(int page, int pageSize) async{
    var isCacheExist = await APICacheManager().isAPICacheKeyExist(page.toString());
    if (!isCacheExist) {
      try {
        final response = await _client
            .get(Uri.parse(endPoints.getListOfImages(page, pageSize)));
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = APICacheDBModel(
              key: page.toString(),
              syncData: response.body,
          );
          await APICacheManager().addCacheData(cacheDBModel);
          return WebImageList.fromJson(jsonDecode(response.body));
        } else {
          print(response.body);
          throw Exception(response.statusCode);
        }
      }
      catch (e) {
        return Future.error(e);
      }
    } else {
      var cacheData = await APICacheManager().getCacheData(page.toString());
      return WebImageList.fromJson(jsonDecode(cacheData.syncData));
    }
  }

  //Use this function to fetch a web image's full info json
  Future<WebImage> fetchWebImageInfo(int id) async{
    try{
      final response =  await _client
    .get(Uri.parse(endPoints.getImageInfoFromId(id)));
      if(response.statusCode == 200){
        return WebImage.fromJson(jsonDecode(response.body));
      }else{
        print(response.body);
        throw Exception(response.statusCode);
      }
    }
    catch(e){
      return Future.error(e);
    }
  }

}
