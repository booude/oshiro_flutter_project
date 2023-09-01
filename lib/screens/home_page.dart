import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_oshiro/screens/search.dart';
import 'package:project_oshiro/screens/track_list.dart';
import 'package:project_oshiro/utils/file_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _allResults = [];
  List _booksList = [];
  List _bookFiles = [];
  late FileManager _fileManager;
  final db = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  resultList() async {
    var showResults = [];
    for (var book in _allResults) {
      await checkFile(book);
      var name = book.id;
      for (var __book in _bookFiles) {
        if (name == __book) {
          showResults.add(book);
        }
      }
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

  getClientStream() async {
    var data = await db.collection('books').get().then((data) => data.docs);

    setState(() {
      _allResults = data;
    });
    resultList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Biblioteca',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Search(),
                  ),
                );
              },
            ),
          ],
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 30.0),
                    Text(
                      'Todos',
                      textScaleFactor: 1.5,
                    ),
                    SizedBox(width: 30.0),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 25.0),
                    Icon(Icons.bookmark),
                    Text(
                      'Favoritos',
                      textScaleFactor: 1.5,
                    ),
                    SizedBox(width: 25.0),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 15.0,
                  ),
                  child: const Text('Conteúdo'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Exibir em Lista'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Excluir Livros'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              backgroundColor: Colors.grey[100],
              // TODO: Change this body when you have items in the list  // Use reorderables.dart
              body: _booksList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _booksList.length,
                      itemBuilder: (context, index) {
                        return Material(
                          child: InkWell(
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
                              leading:
                                  Image.network(_booksList[index]['cover-url']),
                              title: Text(_booksList[index]['name'],
                                  textScaleFactor: 1.1),
                              subtitle: const SizedBox(height: 20),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          const Text(
                            'Sem livros na biblioteca.',
                            textScaleFactor: 1.7,
                          ),
                          const SizedBox(height: 20.0),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(300, 20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Search(),
                                ),
                              );
                            },
                            child: const Text(
                              'Buscar',
                              textScaleFactor: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Scaffold(
              backgroundColor: Colors.grey[100],
              // TODO : Change this body when you have items in the list  // Use reorderables.dart
              body: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    const Text(
                      'Sem favoritos marcados.',
                      textScaleFactor: 1.7,
                    ),
                    const SizedBox(height: 20.0),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(300, 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Search(),
                          ),
                        );
                      },
                      child: const Text(
                        'Buscar',
                        textScaleFactor: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
