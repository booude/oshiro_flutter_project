import 'package:flutter/material.dart';

class BookDownload extends StatefulWidget {
  final book;
  const BookDownload({super.key, required this.book});

  @override
  State<BookDownload> createState() => _BookDownloadState();
}

class _BookDownloadState extends State<BookDownload> {
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
                  onPressed: () {},
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
