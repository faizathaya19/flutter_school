import 'package:flutter/material.dart';

import '../../constants/const.dart';
import 'criticsform_screen.dart';
import 'home_screen.dart';

class SuggestionsAndCriticsScreen extends StatefulWidget {
  static const id = "SuggestionsAndCriticsScreen";
  const SuggestionsAndCriticsScreen({Key? key});

  @override
  State<SuggestionsAndCriticsScreen> createState() =>
      _SuggestionsAndCriticsScreenState();
}

class _SuggestionsAndCriticsScreenState
    extends State<SuggestionsAndCriticsScreen> {
  List<Map<String, String>> ticketList = [
    {
      'divisi': 'Divisi A',
      'kategori': 'Kategori 1',
      'subject': 'Subject 1',
      'no tiket': '12345',
      'status': 'Open',
      'pesan': 'Pesan 1',
    },
    {
      'divisi': 'Divisi B',
      'kategori': 'Kategori 2',
      'subject': 'Subject 2',
      'no tiket': '67890',
      'status': 'Closed',
      'pesan': 'Pesan 2',
    },
    // Tambahkan data tiket lainnya di sini
  ];

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
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ticketList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ticketList[index]['subject'] ?? ''),
                  subtitle:
                      Text('No Tiket: ${ticketList[index]['no tiket'] ?? ''}'),
                  trailing: Text(ticketList[index]['status'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketDetailScreen(
                          ticketData: ticketList[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, CriticsformScreen.id);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class TicketDetailScreen extends StatelessWidget {
  final Map<String, String> ticketData;

  const TicketDetailScreen({super.key, required this.ticketData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Divisi: ${ticketData['divisi'] ?? ''}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Kategori: ${ticketData['kategori'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Subject: ${ticketData['subject'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'No Tiket: ${ticketData['no tiket'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${ticketData['status'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Pesan: ${ticketData['pesan'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
