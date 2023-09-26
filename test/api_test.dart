import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_gallery/models/webImageList.dart';
import 'package:flutter_app_gallery/models/webimage.dart';
import 'package:flutter_app_gallery/network/endpoints.dart';
import 'package:flutter_app_gallery/network/imageService.dart';

import 'api_test.mocks.dart';


/**
 * Here we test our api calls!
 * For full coverage remember to create tests for all your calls
 * You want to cover a succesful call and a possible failure 
 */

class ApiCacheManagerMock extends Mock implements APICacheManager{
  @override
  Future<bool> isAPICacheKeyExist(String? key) =>
      super.noSuchMethod(Invocation.method(#isAPICacheKeyExist, [key]),
      returnValue: Future<bool>.value(false));
}

@GenerateMocks([http.Client])
void main(){
  ImageWebService imageWebService;

  group('Call image api',(){
    EndPoints endPoints = EndPoints();
    final url  = endPoints.getImageInfoFromId(1);
    WebImage mockWebImage = WebImage(id: "1", author: "John Doe", width: 300, height: 300, url: 'https://example.com/data', download_url:'https://example.com/data');
    WebImageList mockWebImageList = WebImageList(webimages: [mockWebImage]);

    //Here is an example of a successful networking call
    test("Return webImage if http completes", () async{
      final httpClient = MockClient();
      imageWebService = ImageWebService(httpClient);
      when(httpClient.get(any)).thenAnswer((_) async => http.Response(jsonEncode(mockWebImage),200));
      expect(imageWebService.fetchWebImageInfo(1),isA<Future<WebImage>>());
    });

    test("Return webImageList if http completes", () async{
      final httpClient = MockClient();
      final apiCacheManagerMock = ApiCacheManagerMock();
      imageWebService = ImageWebService(httpClient);

      when(apiCacheManagerMock.isAPICacheKeyExist("1")).thenAnswer((_) => Future.value(false));
      when(httpClient.get(any)).thenAnswer((_) async => http.Response(jsonEncode(mockWebImageList),200));
      expect(imageWebService.fetchListOfImages(1, 1),isA<Future<WebImageList>>());
    });

  });
}
