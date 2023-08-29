import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _scanBarcode = "-1";
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    var _searchString = "";
    if (_scanBarcode != "-1") {
      _searchString = _scanBarcode;
    }
    if (_searchController.text != "") {
      _searchString = _searchController.text;
      _scanBarcode = "-1";
    }
    if (_searchString != "") {
      for (var clientSnapShot in _allResults) {
        var name = clientSnapShot['name'].toString().toLowerCase();
        var authors = clientSnapShot['authors'].join(' ').toLowerCase();
        var isbn = clientSnapShot['isbn'].toString().replaceAll('-', '');
        if (name.contains(_searchString.toLowerCase()) ||
            (isbn.contains(_searchString.replaceAll('-', ''))) ||
            (authors.contains(_searchString.toLowerCase()))) {
          showResults.add(clientSnapShot);
        }
      }
    } else {
      showResults = [];
    }
    setState(() => _resultList = showResults);
  }

  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection('books')
        .orderBy('name')
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  Future<void> scanQR() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#FF6666', 'CANCEL', true, ScanMode.DEFAULT);
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    searchResultList();
  }

  Widget _buildTab(int tab) {
    return ListView.builder(
      itemCount: _resultList.length,
      key: PageStorageKey(tab),
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () {}, //TODO: Implement book_download.dart screen
            child: ListTile(
              visualDensity: VisualDensity(vertical: 4),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              minLeadingWidth: 55,
              leading: Image.network(_resultList[index]['cover-url']),
              title: Text(_resultList[index]['name'], textScaleFactor: 1.1),
              subtitle: const SizedBox(height: 20),
              trailing: const Icon(
                Icons.add,
                color: Colors.red,
                size: 35,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: const InputDecoration(
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
        body: TabBarView(children: [
          _buildTab(0),
          _buildTab(1),
          _buildTab(2),
        ]),
      ),
    );
  }
}
