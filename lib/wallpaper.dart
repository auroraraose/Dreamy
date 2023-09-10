import 'dart:convert';

import 'package:dreamy/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Wallpaper extends StatefulWidget {
  Wallpaper({Key? key}) : super(key: key);

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              'qEa6aeU1S7NDHITEq2QdEIcVA5gVd89bMWgoW9GeNq2pTLcMpU3Q5QUo'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    // ignore: unused_local_variable
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();

    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              'qEa6aeU1S7NDHITEq2QdEIcVA5gVd89bMWgoW9GeNq2pTLcMpU3Q5QUo'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Container(
            child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreen(imageUrl: images[index]['src']['large2x'], key: null,

                              )));
                    },
                    child: Container(
                      color: Colors.white,
                      child: Image.network(
                        images[index]['src']['tiny'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
          ),
        ),
        InkWell(
          onTap: () {
            loadmore();
          },
          child: Container(
            height: 60,
            width: double.infinity,
            color: Colors.black,
            child: Center(
              child: Text(
                'Load More',
                style: TextStyle(fontSize: 20, color: Colors.yellow[500]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
