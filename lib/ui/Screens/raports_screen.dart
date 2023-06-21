import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class RaportsScreen extends StatefulWidget {
  static const id = 'RaportsScreen';

  @override
  _RaportsScreenState createState() => _RaportsScreenState();
}

class _RaportsScreenState extends State<RaportsScreen> {
  List<Map<String, dynamic>> raports = [];
  int currentIndex = 0;
  bool isShowingFullScreen = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final nis = '12119185'; // Isi dengan NIS yang login
    final response = await http.post(
      Uri.parse('http://192.168.1.2/mybpibs-api/api/api.php'),
      body: {
        'action': 'raports_get',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          raports = List<Map<String, dynamic>>.from(jsonResponse['raports']);
        });
      } else {
        // Handle error response
      }
    } else {
      // Handle error response
    }
  }

  void viewRaportAttachment(int index) {
    setState(() {
      isShowingFullScreen = true;
      currentIndex = index;
    });
  }

  void closeFullScreen() {
    setState(() {
      isShowingFullScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
        ),
        title: const Text(
          'Raports',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!isShowingFullScreen)
            ListView.builder(
              itemCount: raports.length,
              itemBuilder: (context, index) {
                final raport = raports[index];
                final imageUrl =
                    'http://192.168.1.2/mybpibs-api/uploads/raports/${raport['images']}';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap: () => viewRaportAttachment(index),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: Image.network(imageUrl),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Semester: ${raport['semesters']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${raport['exam_type']}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          if (isShowingFullScreen)
            Container(
              color: backgroundColor1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PhotoView(
                      imageProvider: NetworkImage(
                        'http://192.168.1.2/mybpibs-api/uploads/raports/${raports[currentIndex]['images']}',
                      ),
                      backgroundDecoration: BoxDecoration(
                        color: backgroundColor1,
                      ),
                      initialScale: PhotoViewComputedScale.contained * 1,
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: 'raportImage$currentIndex',
                      ),
                      loadingBuilder: (context, event) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: closeFullScreen,
                      child: Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
