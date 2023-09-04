import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:project_oshiro/screens/home_page.dart';
import 'package:project_oshiro/screens/player.dart';
import 'package:project_oshiro/utils/file_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackList extends StatefulWidget {
  final book;
  const TrackList({super.key, required this.book});

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  late SharedPreferences prefs;
  late Future<ListResult> futureFiles;
  late FileManager fileManager;
  bool downloaded = false;
  bool isFavorite = false;
  final storage = FirebaseStorage.instance;
  Map<int, double> downloadProgress = {};

  @override
  void initState() {
    _loadPrefs();
    futureFiles = storage.ref('/books/${widget.book.id}/audios').listAll();
    fileManager = FileManager(book: widget.book);
    super.initState();
  }

  Future _loadPrefs() async {
    final _prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs = _prefs;
      var id = widget.book.id;
      downloaded = prefs.getBool('${id}downloaded') ?? false;
      isFavorite = prefs.getBool('${id}favorite') ?? false;
    });
  }

  Future downloadAll() async {
    var files = await futureFiles;
    int index = 0;
    for (var item in files.items) {
      downloadFile(index, item);
      index++;
    }
    setState(() {
      downloaded = true;
      prefs.setBool('${widget.book.id}downloaded', true);
    });
  }

  Future downloadFile(int index, Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final url = await ref.getDownloadURL();
    final id = widget.book.id;
    final path = '${dir.path}/$id/audios/${ref.name}';
    await Dio().download(
      url,
      path,
      onReceiveProgress: (count, total) {
        double progress = count / total;
        setState(() {
          downloadProgress[index] = progress;
          if (downloadProgress[index] == 1.0) {
            downloadProgress.remove(index);
            prefs.setString(ref.name, path);
          }
        });
      },
    );
  }

  Future _bookToFavorite(bool _bool) {
    setState(() {
      isFavorite = _bool;
      prefs.setBool('${widget.book.id}favorite', _bool);
    });
    return fileManager.writeFile(_bool);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          centerTitle: true,
          title: const Text('Lista de Faixas'),
          bottom: AppBar(
            scrolledUnderElevation: 0.0,
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
            backgroundColor: Colors.grey[200],
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.book['cover-url'], scale: 2.1),
                const VerticalDivider(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.book['name'],
                        textScaleFactor: 1.0,
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          downloaded
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {}, // already downloaded
                                  child: const Text(
                                    'Todos baixados',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    downloadAll();
                                  }, // download all
                                  child: const Row(
                                    children: [
                                      Icon(Icons.download),
                                      Text(
                                        'Baixar todos',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                          isFavorite
                              ? IconButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    _bookToFavorite(false);
                                  },
                                  icon: const Icon(
                                    Icons.bookmark,
                                    color: Colors.red,
                                  ),
                                )
                              : IconButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    _bookToFavorite(true);
                                  },
                                  icon: const Icon(
                                    Icons.bookmark_add_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<ListResult>(
          future: futureFiles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final files = snapshot.data!.items;
              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  String name = file.name.split('.mp3')[0];
                  String? location = prefs.getString(file.name);
                  double? progress = downloadProgress[index];
                  return location != null
                      ? ListTile(
                          // true
                          title: Text(
                            name,
                            textScaleFactor: 0.99,
                          ),
                          subtitle: const SizedBox(height: 0.5),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.red),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Player(path: location),
                              ),
                            );
                          },
                        )
                      : ListTile(
                          // false
                          title: Text(
                            file.name,
                            textScaleFactor: 0.99,
                          ),
                          subtitle: progress != null
                              ? LinearProgressIndicator(
                                  minHeight: 0.5,
                                  value: progress,
                                  backgroundColor: Colors.grey,
                                )
                              : const SizedBox(height: 0.5),
                          trailing: const Icon(
                            Icons.download,
                            color: Colors.red,
                          ),
                          onTap: () => downloadFile(index, file),
                        );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('error occurred'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
