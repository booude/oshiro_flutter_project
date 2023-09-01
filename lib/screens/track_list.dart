import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:project_oshiro/screens/home_page.dart';
import 'package:project_oshiro/screens/player.dart';
import 'package:project_oshiro/utils/file_manager.dart';

class TrackList extends StatefulWidget {
  final book;
  const TrackList({super.key, required this.book});

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  late Future<ListResult> futureFiles;
  late FileManager fileManager;
  Map<int, double> downloadProgress = {};
  Map<int, String> fileLocation = {};
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    futureFiles = FirebaseStorage.instance
        .ref('/books/${widget.book.id}/audios')
        .listAll();
    fileManager = FileManager(book: widget.book);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
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
          title: const Text('Track List'),
          bottom: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
            backgroundColor: Colors.grey[300],
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(widget.book['cover-url'], scale: 2.5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.book['name']),
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {}, // download all
                            child: const Row(
                              children: [
                                Icon(Icons.download),
                                Text(
                                  'Download All',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {}, // add book to favorite
                            icon: const Icon(
                              Icons.bookmark_add_outlined,
                              color: Colors.red,
                            ),
                          )
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
                  String? location = fileLocation[index];
                  double? progress = downloadProgress[index];
                  return location == null
                      ? ListTile(
                          // true
                          title: Text(file.name),
                          subtitle: progress != null
                              ? LinearProgressIndicator(
                                  minHeight: 5,
                                  value: progress,
                                  backgroundColor: Colors.grey,
                                )
                              : const SizedBox(height: 5),
                          trailing: const Icon(
                            Icons.download,
                            color: Colors.red,
                          ),
                          onTap: () => downloadFile(index, file),
                        )
                      : ListTile(
                          // false
                          title: Text(file.name),
                          subtitle: const SizedBox(height: 5),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.red),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Player(path: fileLocation[index]),
                              ),
                            );
                          },
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

  Future downloadFile(int index, Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final url = await ref.getDownloadURL();
    final path = '${dir.path}/${ref.name}';
    await Dio().download(
      url,
      path,
      onReceiveProgress: (count, total) {
        double progress = count / total;
        setState(() {
          downloadProgress[index] = progress;
          if (downloadProgress[index] == 1.0) {
            downloadProgress.remove(index);
            fileLocation[index] = path;
          }
        });
      },
    );
  }
}
