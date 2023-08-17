import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/animations/animation_title.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
import 'package:bpibs/ui/widgets/buildButton_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class RaportsScreen extends StatefulWidget {
  static const id = 'RaportsScreen';

  const RaportsScreen({Key? key}) : super(key: key);

  @override
  RaportsScreenState createState() => RaportsScreenState();
}

class RaportsScreenState extends State<RaportsScreen> {
  List<Map<String, dynamic>> raports = [];
  int currentIndex = 0;
  bool isShowingFullScreen = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRaportData();
  }

  Future<void> _fetchRaportData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    try {
      List<Map<String, dynamic>> raportData =
          await ApiService.fetchRaportData(nis);

      setState(() {
        raports = raportData;
        isLoading = false;
      });
    } catch (e) {
      String errorMessage;
      if (e is http.ClientException) {
        errorMessage = 'Failed to connect to the server.';
      } else {
        errorMessage = 'Failed to fetch raport data: $e';
      }

      showErrorDialog(context, errorMessage, () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(HomeScreen.id);
      });
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black,
          onPressed: () {
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
        ),
        title: AnimatedTitle(
          isLoading: isLoading,
          title: 'Raports',
          fontsize: 15,
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
                final imageUrl = '$imageapi${raport['images']}';
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${raport['exam_type']}',
                              style: const TextStyle(
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
                        '$imageapi${raports[currentIndex]['images']}',
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
                      loadingBuilder: (context, event) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BuildButton(
                        width: double.infinity,
                        height: size.height / 16,
                        onTap: closeFullScreen,
                        label: 'Close'),
                  )
                ],
              ),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
