import 'package:bpibs/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../constants/const.dart';
import 'criticsform_screen.dart';
import 'home_screen.dart';

class SuggestionsAndCriticsScreen extends StatefulWidget {
  static const id = "SuggestionsAndCriticsScreen";
  const SuggestionsAndCriticsScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionsAndCriticsScreen> createState() =>
      _SuggestionsAndCriticsScreenState();
}

class _SuggestionsAndCriticsScreenState
    extends State<SuggestionsAndCriticsScreen> {
  List<Map<String, String>> ticketList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTicketList();
  }

  Future<void> fetchTicketList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'kritik_saran_get',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          ticketList = List<Map<String, String>>.from(
              jsonResponse['kritikSaran']
                  .map((data) => Map<String, String>.from(data)));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showErrorDialog(jsonResponse['message']);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Failed to connect to the server.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacementNamed(context, CriticsformScreen.id);
            },
          ),
        ],
      ),
    );
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
          'Kritik dan Saran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: ticketList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  ticketList[index]['subjek'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'No Tiket: ${ticketList[index]['no_tiket'] ?? ''}',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ticketList[index]['status'] == 'Open'
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ticketList[index]['status'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TicketDetailDialog(
                        ticketData: ticketList[index],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, CriticsformScreen.id);
        },
        backgroundColor: buttonColor1,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class TicketDetailDialog extends StatelessWidget {
  final Map<String, String> ticketData;

  const TicketDetailDialog({Key? key, required this.ticketData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Divisi: ${ticketData['divisi'] ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Kategori: ${ticketData['kategori'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Subject: ${ticketData['subjek'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'No Tiket: ${ticketData['no_tiket'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${ticketData['status'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Pesan: ${ticketData['pesan'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
