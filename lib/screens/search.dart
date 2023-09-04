import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:project_oshiro/screens/book_selected.dart';
import 'package:project_oshiro/screens/track_list.dart';
import 'package:project_oshiro/utils/file_manager.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _scanBarcode = "-1";
  List _allResults = [];
  List _booksList = [];
  List _bookFiles = [];
  late FileManager _fileManager;
  final db = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() async {
    var showResults = [];
    var searchString = "";
    if (_scanBarcode != "-1") {
      searchString = _scanBarcode;
    }
    if (_searchController.text != "") {
      searchString = _searchController.text;
      _scanBarcode = "-1";
    }
    if (searchString != "") {
      for (var book in _allResults) {
        var name = book['name'].toString().toLowerCase();
        var authors = book['authors'].join(' ').toLowerCase();
        var isbn = book['isbn'].toString().replaceAll('-', '');
        if (name.contains(searchString.toLowerCase()) ||
            (isbn == searchString.replaceAll('-', '')) ||
            (authors.contains(searchString.toLowerCase()))) {
          await checkFile(book);
          showResults.add(book);
        }
      }
    } else {
      showResults = [];
    }
    setState(() => _booksList = showResults);
  }

  checkFile(book) async {
    _fileManager = FileManager(book: book);
    var isFile = await _fileManager.readFile();
    setState(() {
      if (isFile[0] != '') {
        _bookFiles.add(isFile[0]);
      }
    });
  }

  bool isInLibrary(book) {
    for (var _book in _bookFiles) {
      if (book.id == _book) {
        return true;
      }
    }
    return false;
  }

  getClientStream() async {
    var data = await db.collection('books').get().then((data) => data.docs);

    setState(() {
      _allResults = data;
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
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[300],
            title: Container(
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 7.0),
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
        body: ListView.builder(
          itemCount: _booksList.length,
          itemBuilder: (context, index) {
            return Material(
              child: isInLibrary(_booksList[index])
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TrackList(book: _booksList[index]),
                          ),
                        );
                      },
                      child: ListTile(
                        visualDensity: const VisualDensity(vertical: 4),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 18),
                        minLeadingWidth: 55,
                        leading: Image.network(_booksList[index]['cover-url']),
                        title: Text(_booksList[index]['name'],
                            textScaleFactor: 1.1),
                        subtitle: const SizedBox(height: 20),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: false,
                            builder: (context) =>
                                BookSelected(book: _booksList[index]),
                          ),
                        );
                      },
                      child: ListTile(
                        visualDensity: const VisualDensity(vertical: 4),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 18),
                        minLeadingWidth: 55,
                        leading: Image.network(_booksList[index]['cover-url']),
                        title: Text(_booksList[index]['name'],
                            textScaleFactor: 1.1),
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
        ),
      ),
    );
  }
}
