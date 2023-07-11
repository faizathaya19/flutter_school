import 'package:flutter/material.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});
  static const id = 'InformationScreen';
  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 100, // Atur tinggi khusus untuk toolbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
        ),
        title: const Text(
          'Informasi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              PaymentInfo(
                title: 'Cara Pembayaran SPP',
                bankCode: '7186',
                accountNumber: '21222018',
                transferBankCode: '9007186',
              ),
              PaymentInfo(
                title: 'Cara Transfer Uang Saku atau Biaya Lainnya',
                bankCode: '7187',
                accountNumber: '21222018',
                transferBankCode: '9007187',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentInfo extends StatelessWidget {
  final String title;
  final String bankCode;
  final String accountNumber;
  final String transferBankCode;

  const PaymentInfo({
    Key? key,
    required this.title,
    required this.bankCode,
    required this.accountNumber,
    required this.transferBankCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(title),
        children: <Widget>[
          ListTile(
            title: Text(
                'Metoda pembayaran yang digunakan adalah menggunakan virtual account BSI, dengan kode tujuan $bankCode.'),
            subtitle: Text('Nomor VA (8 digit): $accountNumber'),
          ),
          ListTile(
            title: const Text('Langkah-langkah Pembayaran Melalui ATM BSI:'),
            subtitle: Text(
              '1. Pilih Menu Utama\n'
              '2. Pilih Payment/Pembayaran/Pembelian > Akademik\n'
              '3. Masukkan kode institusi/sekolah dan ID\n'
              '   a. Kode institusi/sekolah         : $bankCode - Yay. Bintang Pelajar Indoneisa Open\n'
              '   b. Kode ID/nomor VA (8 digit) : $accountNumber\n'
              '   Maka rekening tujuan akan muncul sebagai berikut: $bankCode-$accountNumber\n'
              '4. Tekan Benar/Selanjutnya.\n'
              '5. Masukkan nominal sesuai tagihan yang akan dibayarkan\n'
              '6. Di halaman konfirmasi, pastikan detail pembayaran seperti nama sekolah, nama siswa dan jumlah pembayaran sudah tepat\n'
              '7. Jika data sudah sesuai, pilih BENAR / YA\n'
              '8. Transaksi berhasil',
            ),
          ),
          const ListTile(
            title: Text('Langkah-langkah Pembayaran Melalui BSI Mobile:'),
            subtitle: Text(
              '1. Pilih menu Bayar > Akademik\n'
              '2. Masukkan kata sandi BSI Mobile, tekan Lanjut\n'
              '3. Pada kolom Nama Akademik masukkan Kode/Nama Sekolah dan pada kolom ID Pelanggan/Kode Bayar masukkan 8 digit nomor VA siswa.\n'
              '4. Tekan Selanjutnya\n'
              '5. Masukkan nominal sesuai tagihan yang akan dibayarkan, tekan selanjutnya. Apabila tidak mengetahui jumlah tagihan, Abu/Ummu bisa konfirmasi ke Bendahara Penerimaan Sekolah\n'
              '6. Masukkan PIN BSI Mobile, tekan Selanjutnya\n'
              '7. Di halaman konfirmasi, pastikan nama sekolah, nama siswa, kode bayar/nomor VA siswa dan jumlah pembayaran sudah benar,.\n'
              '8. Lalu tekan Selanjutnya untuk menyelesaikan transaksi\n'
              '9. Transaksi berhasil',
            ),
          ),
          ListTile(
            title: const Text(
                'Langkah-langkah Pembayaran Melalui Outlet Bank BSI:'),
            subtitle: Text(
              '1. Isi memo setoran tunai BPIBS.\n'
              '2. Tulis rekening tujuan dengan format: $bankCode + 8 digit nomor VA siswa, yaitu: $bankCode$accountNumber\n'
              '3. Tulis nama rekening tujuan dengan nama siswa.\n'
              '4. Tulis jumlah setoran sesuai tagihan.\n'
              '5. Berikan keterangan pada berita jika dibutuhkan.\n'
              '6. Tanda tangan dan nama jelas.\n'
              '7. Berikan kepada petugas bank.\n'
              '8. Selesai.',
            ),
          ),
          ListTile(
            title: const Text('Langkah-langkah Pembayaran dari Bank Lain:'),
            subtitle: Text(
              '1. Pilih Transfer\n'
              '2. Pilih Antar Bank Online / Transfer Online antar Bank\n'
              '3. Masukkan kode BSI 451 atau pilih Bank Syariah Indonesia\n'
              '4. Masukan kode $transferBankCode + Nomor Pembayaran (Virtual Account) Yaitu =  $transferBankCode$accountNumber\n'
              '5. Masukan nominal tagihan\n'
              '6. Layar akan menampilkan data transaksi Anda, jika data sudah benar pilih YA (OK)\n'
              '7. Proses Pembayaran',
            ),
          ),
        ],
      ),
    );
  }
}
