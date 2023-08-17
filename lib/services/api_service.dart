import 'dart:convert';
import 'package:http/http.dart' as http;

const urlapi = 'http://192.168.1.3/mybpibs-api';
// const urlapi = 'https://test1787.000webhostapp.com';
const api = '$urlapi/api/api.php';
const apiimgact = '$urlapi/uploads/';
const imageapi = '$urlapi/uploads/raports/';

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchPickupList(String? nis) async {
    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'penjemputan_only_1',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return List<Map<String, dynamic>>.from(jsonResponse['Penjemputan']);
      }
    }
    return []; // Return an empty list if there is no success or response error
  }

  static Future<List<Map<String, dynamic>>> fetchDateActList(
      String? nis) async {
    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'tanggal_aktivitas_get',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return List<Map<String, dynamic>>.from(jsonResponse['Aktivitas']);
      }
    }
    return []; // Return an empty list if there is no success or response error
  }

  static Future<List<Map<String, dynamic>>> fetchRaportData(String? nis) async {
    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'raports_get',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return List<Map<String, dynamic>>.from(jsonResponse['raports']);
      } else {
        throw jsonResponse['message'];
      }
    }
    return []; // Return an empty list if there is no success or response error
  }

  static Future<dynamic> fetchPoinPrestasi(String nis) async {
    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'poin_prestasi_get',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return jsonResponse['poinPrestasi'];
      } else {
        throw jsonResponse['message'];
      }
    }
  }

  static Future<String> changePickupStatus(String nis) async {
    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'penjemputan_status_update',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return jsonResponse['message'];
      } else {
        throw jsonResponse['message'];
      }
    } else {
      // Handle non-200 status codes (optional)
      throw 'Failed to update pickup status';
    }
  }

  static Future<String> changeVisitStatus(String nis) async {
    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'penjengukan_status_update',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return jsonResponse['message'];
      } else {
        throw jsonResponse['message'];
      }
    } else {
      // Handle non-200 status codes (optional)
      throw 'Failed to update visit status';
    }
  }

  static Future<List<Map<String, dynamic>>> fetchVisitList(String? nis) async {
    final response = await http.post(
      Uri.parse(api),
      body: {
        'action': 'penjengukan_only_1',
        'nis': nis,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return List<Map<String, dynamic>>.from(jsonResponse['Penjengukan']);
      }
    }
    return []; // Return an empty list if there is no success or response error
  }
}
