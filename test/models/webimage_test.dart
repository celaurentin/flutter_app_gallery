import 'package:flutter_app_gallery/models/webimage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromJson', () {
    test("Return a valid webImage model", () {
       final json = {
         "id": "1",
         "author": "Test author",
         "width": 100,
         "height": 150,
         "url": "http://test.com/",
         "download_url": "http://download.com/1"
       };

       final actual = WebImage.fromJson(json);
       final expected = WebImage(
           id: "1",
           author: "Test author",
           width: 100,
           height: 150,
           url: "http://test.com/",
           download_url: "http://download.com/1",
       );
       expect(actual, isA<WebImage>());
       expect(actual.toString()==expected.toString(), true);
    },
    );
  });

}
