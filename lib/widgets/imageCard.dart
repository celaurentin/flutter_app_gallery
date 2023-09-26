import 'dart:io';

import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget{
  final String authorName;
  final String imageUrl;
  final double height;

  const ImageCard({super.key, required this.authorName,required this.imageUrl, required this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.black12,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.vertical,
          children: [ 
            Text(authorName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  ),
                ),
                Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(imageUrl, height: height)
                    ],
                  ),
                ),
            ],
        ),
      )
    );
  }
}
