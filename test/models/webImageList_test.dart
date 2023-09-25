import 'package:flutter_app_gallery/models/webImageList.dart';
import 'package:flutter_app_gallery/models/webimage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromJson', () {
    test("Return a valid webImageList model", () {
      final json = [
        {
          "id": "1",
          "author": "Test author 1",
          "width": 100,
          "height": 150,
          "url": "http://test.com/",
          "download_url": "http://download.com/1"
        },
        {
          "id": "2",
          "author": "Test author 2",
          "width": 100,
          "height": 150,
          "url": "http://test.com/",
          "download_url": "http://download.com/2"
        }];

      final actual = WebImageList.fromJson(json);
      final webImageMock1 = WebImage(
        id: "1",
        author: "Test author",
        width: 100,
        height: 150,
        url: "http://test.com/",
        download_url: "http://download.com/1",
      );
      final webImageMock2 = WebImage(
        id: "2",
        author: "Test author 2",
        width: 100,
        height: 150,
        url: "http://test.com/",
        download_url: "http://download.com/2",
      );
      final webimagesMock = [webImageMock1, webImageMock2];
      final expected = WebImageList(webimages: webimagesMock);

      expect(actual, isA<WebImageList>());
      expect(actual.webimages, everyElement(isA<WebImage>()));
      expect(actual.webimages.length==expected.webimages.length, true);
      expect(actual.webimages[0].toString(), expected.webimages[0].toString());
      expect(actual.webimages[1].toString(), expected.webimages[1].toString());
    },
    );
  });

}
