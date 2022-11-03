import 'package:carousel_slider/carousel_slider.dart';
import '../model/prestation_model.dart';
import 'package:flutter/material.dart';

class ImageShow extends StatefulWidget {
  PrestationsModel PrestationSelectione;
  ImageShow({Key? key, required this.PrestationSelectione}) : super(key: key);

  @override
  _ImageShowState createState() => _ImageShowState();
}

class _ImageShowState extends State<ImageShow> {
  int imageIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: Colors.white,
        leadingWidth: 85,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(Icons.arrow_back,color: Colors.black,),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0, top: 18),
            child: Text(
              imageIndex.toString() +
                  " / " +
                  widget.PrestationSelectione.imageList.length.toString(),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: CarouselSlider.builder(
          itemCount: widget.PrestationSelectione.imageList.length,
          itemBuilder: (context, index, realIndex) {
            final image = widget.PrestationSelectione.imageList[index];

            return buildImage(image, index);
          },
          options: CarouselOptions(
              enlargeCenterPage: true,
              height: MediaQuery.of(context).size.height,
              initialPage: 0,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  imageIndex = index + 1;
                });
              }),
        ),
      ),
    );
  }

  Widget buildImage(String imagepath, int index) => Container(
    child:Image.network(imagepath),
  );
}
