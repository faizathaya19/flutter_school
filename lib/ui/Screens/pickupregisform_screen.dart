import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
import 'package:bpibs/ui/widgets/buildButton_widget.dart';
import 'package:bpibs/ui/widgets/buildTextField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class PickupregisformScreen extends StatefulWidget {
  static const id = 'PickupregisformScreen';

  const PickupregisformScreen({Key? key}) : super(key: key);

  @override
  _PickupregisformScreenState createState() => _PickupregisformScreenState();
}

class _PickupregisformScreenState extends State<PickupregisformScreen> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions = <Widget>[
    NewDataForm(),
    ExistingDataScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the selected index is valid
    if (_selectedIndex < 0 || _selectedIndex >= _widgetOptions.length) {
      // Add a default widget or handle the case when the index is out of bounds
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid Tab Index'),
        ),
      );
    }

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
        title: const Text(
          'Form Pendaftaran Penjemputan Wali Siswa',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _widgetOptions.elementAt(_selectedIndex),
          ],
          // Use the selected widget from the _widgetOptions list
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.input),
            label: 'Input Baru',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Data Terdahulu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class NewDataForm extends StatefulWidget {
  @override
  State<NewDataForm> createState() => _NewDataFormState();
}

class _NewDataFormState extends State<NewDataForm> {
  final TextEditingController namaPenjemputController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController hubSiswaController = TextEditingController();
  final TextEditingController noKtpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController alamatTinggalController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  Map<String, dynamic> profile = {};
  List<Map<String, dynamic>> dateList = [];
  bool isLoading = false;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    getProfile();

    _fetchDateActList();
  }

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfile = prefs.getString('userProfile');
    if (userProfile != null) {
      setState(() {
        profile = json.decode(userProfile);
      });
    }
  }

  Future<void> _fetchDateActList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    List<Map<String, dynamic>> list = await ApiService.fetchDateActList(nis);
    setState(() {
      dateList = list;
      isLoading = false;
    });
  }

  Future<void> uploadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? nis;

      // Mengambil nis dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      nis = prefs.getString('nis');

      String url = api;

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['action'] = 'penjemputan_input';
      request.fields['nis'] = nis!;
      request.fields['nama_penjemput'] = namaPenjemputController.text;
      request.fields['tanggal_lahir'] = tanggalLahirController.text;
      request.fields['hubungan_dengan_siswa'] = hubSiswaController.text;
      request.fields['no_ktp'] = noKtpController.text;
      request.fields['alamat_sesuai_ktp'] = alamatController.text;
      request.fields['alamat_tinggal'] = alamatTinggalController.text;
      request.fields['no_whatsapp_penjemput'] = whatsappController.text;

      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile!.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        if (jsonResponse['status'] == 'success') {
          // Berhasil menambahkan data
          showSuccessDialog(context, jsonResponse['message'], () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(HomeScreen.id);
          });
        } else {
          // Gagal menambahkan data
          showErrorDialog(context, jsonResponse['message'], () {
            Navigator.of(context).pop();
          });
        }
      } else {
        // Terjadi masalah pada server
        showErrorDialog(context, 'Terjadi masalah pada server.', () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      // Terjadi masalah pada koneksi
      showErrorDialog(context, 'Terjadi masalah pada koneksi.', () {
        Navigator.of(context).pop();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void chooseImage() async {
    final picker = ImagePicker();
    var pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      imageFile = pickedFile;
    });
  }

  void _selectDate(BuildContext context) async {
    // Calculate the maximum allowable date for someone who is 17 years old
    final DateTime maximumDate =
        DateTime.now().subtract(Duration(days: 17 * 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: maximumDate, // Use maximumDate instead of DateTime.now()
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        tanggalLahirController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundCard1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${profile['nama_lengkap']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text('Tanggal Penjemputan tersedia :'),
              SizedBox(height: 5),
              Text(dateList.isNotEmpty ? dateList[0]['tanggal'] ?? '' : ''),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundCard1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildTextField(
                controller: namaPenjemputController,
                labelText: 'Nama Penjemput (Mahrom)',
                size: size,
                maxLines: null,
              ),
              BuildTextField(
                controller: tanggalLahirController,
                labelText: 'Tanggal Lahir',
                size: size,
                onTap: () {
                  _selectDate(context);
                },
                readOnly: true,
              ),
              BuildTextField(
                controller: hubSiswaController,
                labelText: 'Hubungan dengan siswa',
                size: size,
                maxLines: null,
              ),
              BuildTextField(
                controller: noKtpController,
                labelText: 'No KTP',
                size: size,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLines: null,
              ),
              BuildTextField(
                controller: alamatController,
                labelText: 'Alamat Sesuai KTP',
                size: size,
                maxLines: null,
              ),
              BuildTextField(
                controller: alamatTinggalController,
                labelText: 'Alamat Tinggal (Jika sesuai ktp tidak perlu diisi)',
                size: size,
                maxLines: null,
              ),
              BuildTextField(
                controller: whatsappController,
                labelText: 'No WhatsApp',
                size: size,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLines: null,
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: chooseImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: secondaryTextColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              File(imageFile!.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt,
                            color: basicTextColor,
                            size: 40.0,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              BuildButton(
                width: 300,
                height: size.height / 16,
                onTap: () async {
                  await uploadData();
                },
                label: 'Kirim',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExistingDataScreen extends StatefulWidget {
  ExistingDataScreen({super.key});

  @override
  State<ExistingDataScreen> createState() => _ExistingDataScreenState();
}

class _ExistingDataScreenState extends State<ExistingDataScreen> {
  List<Map<String, String>> pickupList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPickupList();
  }

  Future<void> fetchPickupList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'penjemputan_get',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          pickupList = List<Map<String, String>>.from(
              jsonResponse['Penjemputan']
                  .map((data) => Map<String, String>.from(data)));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showErrorDialog(context, jsonResponse['message'], () {
          Navigator.of(context).pop();
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, 'Terjadi masalah pada server.', () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var record in pickupList)
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              child: ListTile(
                title: Text('${record['nama_penjemput']}'),
                onTap: () {
                  // Navigate to the details screen when the card is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordDetailScreen(record: record),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class RecordDetailScreen extends StatefulWidget {
  final Map<String, String> record;

  const RecordDetailScreen({super.key, required this.record});

  @override
  _RecordDetailScreenState createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  // Declare TextEditingController for each form field
  TextEditingController idController = TextEditingController();
  TextEditingController namaPenjemputController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController hubSiswaController = TextEditingController();
  TextEditingController noKtpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController alamatTinggalController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();

  @override
  void initState() {
    // Initialize the form field controllers with the data from the selected record
    idController.text = widget.record['id'] ?? '';
    namaPenjemputController.text = widget.record['nama_penjemput'] ?? '';
    tanggalLahirController.text = widget.record['tanggal_lahir'] ?? '';
    hubSiswaController.text = widget.record['hubungan_dengan_siswa'] ?? '';
    noKtpController.text = widget.record['no_ktp'] ?? '';
    alamatController.text = widget.record['alamat_sesuai_ktp'] ?? '';
    alamatTinggalController.text = widget.record['alamat_tinggal'] ?? '';
    whatsappController.text = widget.record['no_whatsapp_penjemput'] ?? '';
    super.initState();
  }

  bool isLoading = false;

  XFile? imageFile;

  Future<void> updateData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? nis;

      // Mengambil nis dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      nis = prefs.getString('nis');

      String url = api;

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['action'] = 'penjemputan_update';
      request.fields['nis'] = nis!;
      request.fields['id'] = idController.text;
      request.fields['nama_penjemput'] = namaPenjemputController.text;
      request.fields['tanggal_lahir'] = tanggalLahirController.text;
      request.fields['hubungan_dengan_siswa'] = hubSiswaController.text;
      request.fields['no_ktp'] = noKtpController.text;
      request.fields['alamat_sesuai_ktp'] = alamatController.text;
      request.fields['alamat_tinggal'] = alamatTinggalController.text;
      request.fields['no_whatsapp_penjemput'] = whatsappController.text;

      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile!.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        if (jsonResponse['status'] == 'success') {
          // Berhasil menambahkan data
          showSuccessDialog(context, jsonResponse['message'], () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(HomeScreen.id);
          });
        } else {
          // Gagal menambahkan data
          showErrorDialog(context, jsonResponse['message'], () {
            Navigator.of(context).pop();
          });
        }
      } else {
        // Terjadi masalah pada server
        showErrorDialog(context, 'Terjadi masalah pada server.', () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      // Terjadi masalah pada koneksi
      showErrorDialog(context, 'Terjadi masalah pada koneksi.', () {
        Navigator.of(context).pop();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void chooseImage() async {
    final picker = ImagePicker();
    var pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      imageFile = pickedFile;
    });
  }

  void _selectDate(BuildContext context) async {
    // Calculate the minimum allowable date for someone who is 17 years old
    final DateTime minimumDate =
        DateTime.now().subtract(Duration(days: 17 * 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: minimumDate,
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        tanggalLahirController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        title: Text(
          '${widget.record['nama_penjemput']}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundCard1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildTextField(
                    controller: namaPenjemputController,
                    labelText: 'Nama Penjemput (Mahrom)',
                    size: size,
                    maxLines: null,
                  ),
                  BuildTextField(
                    controller: tanggalLahirController,
                    labelText: 'Tanggal Lahir',
                    size: size,
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                  ),
                  BuildTextField(
                    controller: hubSiswaController,
                    labelText: 'Hubungan dengan siswa',
                    size: size,
                    maxLines: null,
                  ),
                  BuildTextField(
                    controller: noKtpController,
                    labelText: 'No KTP',
                    size: size,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    maxLines: null,
                  ),
                  BuildTextField(
                    controller: alamatController,
                    labelText: 'Alamat',
                    size: size,
                    maxLines: null,
                  ),
                  BuildTextField(
                    controller: alamatTinggalController,
                    labelText: 'Alamat Tinggal',
                    size: size,
                    maxLines: null,
                  ),
                  BuildTextField(
                    controller: whatsappController,
                    labelText: 'No WhatsApp',
                    size: size,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    maxLines: null,
                  ),
                  SizedBox(height: 20),
                  Center(
                      child: Column(
                    children: [
                      GestureDetector(
                        onTap: chooseImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: secondaryTextColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    File(imageFile!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  color: basicTextColor,
                                  size: 40.0,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Update Foto Terbaru')
                    ],
                  )),
                  SizedBox(height: 20),
                  BuildButton(
                    width: 300,
                    height: size.height / 16,
                    onTap: () async {
                      await updateData();
                    },
                    label: 'Kirim',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
