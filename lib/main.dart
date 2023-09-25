import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_gallery/models/webimage.dart';
import 'package:flutter_app_gallery/network/imageService.dart';
import 'package:flutter_app_gallery/models/webImageList.dart';
import 'package:flutter_app_gallery/widgets/imageCard.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gallery App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final controller = CarouselController();
  Future<WebImageList>? _webImageList;
  List<WebImage> _webImages = [];

  late int _currentPage;
  late int _currentIndex;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _currentPage = 1;
    fetchImages();
  }

  void fetchImages() async {
    setState(() {
      _webImageList = ImageWebService(http.Client())
          .fetchListOfImages(_currentPage, _pageSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:  Center(
        child: Column(
            children: [
              FutureBuilder<WebImageList>(
                future: _webImageList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _webImages = snapshot.data!.webimages;
                    return CarouselSlider.builder(
                        carouselController: controller,
                        options: CarouselOptions(
                            height: 400,
                            viewportFraction: 1
                        ),
                        itemCount: _webImages.length,
                        itemBuilder: (context, index, realIndex) {
                          return ImageCard(
                              authorName: _webImages[index].author,
                              imageUrl: _webImages[index].download_url
                          );
                        }
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),

              buildButtons()
            ]
        )
      ),
    );
  }

  Widget buildButtons({bool stretch = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
          onPressed: previous,
          icon: const Icon(Icons.arrow_back_ios, size: 32)
      ),
      IconButton(
          onPressed: next,
          icon: const Icon(Icons.arrow_forward_ios, size: 32)
      )
    ]
  );

  void next() => {
    _currentIndex++,
    if (_currentIndex < (_pageSize*_currentPage)) {
      debugPrint("current Index:$_currentIndex for page:$_currentPage"),
      controller.nextPage()
    } else {
      setState(() {
        _currentPage++;
      }),
      debugPrint(
          "current Index:$_currentIndex fetching new images for page: $_currentPage"),
      fetchImages()
    }
  };

  void previous() => {
    _currentIndex--,
    if (_currentIndex == 0) {
      controller.previousPage()
    } else if (_currentIndex > 0) {
      if (_currentIndex < (_pageSize * (_currentPage-1))) {
        setState(() {
          if (_currentPage > 1) _currentPage--;
        }),
        debugPrint(
            "current Index:$_currentIndex fetching new images for page: $_currentPage"),
        fetchImages()
      } else {
        debugPrint("current Index:$_currentIndex for page:$_currentPage"),
        controller.previousPage()
      }
    } else {
      _currentIndex++
    }
  };

}
