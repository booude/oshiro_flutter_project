import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _scanBarcode = 'Unknown';

  Future<void> scanQR() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#FF6666', 'CANCEL', true, ScanMode.DEFAULT);
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    print(_scanBarcode); // TODO: Remove after implementing search function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Busca',
          ),
          centerTitle: true,
          bottom: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[300],
            title: Container(
              width: double.infinity,
              height: 45,
              color: Colors.white,
              child: const TextField(
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: 'Título, Autor, ISBN...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => scanQR(),
                icon: const Icon(Icons.qr_code_scanner),
              ),
            ],
          ),
        ),
        body: const CustomScrollView());
  }
}
