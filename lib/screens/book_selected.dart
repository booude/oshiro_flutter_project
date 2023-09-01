import 'package:flutter/material.dart';
import 'package:project_oshiro/screens/track_list.dart';
import 'package:project_oshiro/utils/file_manager.dart';

class BookSelected extends StatefulWidget {
  final book;
  const BookSelected({super.key, required this.book});

  @override
  State<BookSelected> createState() => _BookSelectedState();
}

class _BookSelectedState extends State<BookSelected> {
  late FileManager fileManager;
  @override
  void initState() {
    fileManager = FileManager(book: widget.book);
    fileManager.readFile();
    super.initState();
  }

  Future _bookToLibrary() {
    return fileManager.writeFile(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 35,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, size: 30.0))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Column(
              children: [
                Image.network(
                  widget.book["cover-url"],
                  width: 130,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.book["name"],
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.4,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                        child: Text("Autores:",
                            textAlign: TextAlign.right, textScaleFactor: 1.0)),
                    const VerticalDivider(width: 8),
                    Expanded(
                        child: Text(widget.book["authors"].join("\n"),
                            textScaleFactor: 1.0))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                        child: Text("Editora:",
                            textAlign: TextAlign.right, textScaleFactor: 1.0)),
                    const VerticalDivider(width: 8),
                    Expanded(
                        child: Text(widget.book["publisher"],
                            textScaleFactor: 1.0))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                        child: Text("Publicado:",
                            textAlign: TextAlign.right, textScaleFactor: 1.0)),
                    const VerticalDivider(width: 8),
                    Expanded(
                        child: Text(widget.book["published"],
                            textScaleFactor: 1.0))
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amberAccent[700],
                  ),
                  onPressed: () {
                    _bookToLibrary();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackList(book: widget.book),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                      Text(
                        style: TextStyle(color: Colors.white),
                        ' Adicionar esse Livro',
                        textScaleFactor: 1.4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
