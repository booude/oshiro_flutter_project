import 'package:flutter/material.dart';

class TrackList extends StatefulWidget {
  const TrackList({super.key});

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Track List'),
          bottom: AppBar(
            toolbarHeight: 180,
            backgroundColor: Colors.grey[300],
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                    scale: 2.5,
                    'https://firebasestorage.googleapis.com/v0/b/project-oshiro-ff1d0.appspot.com/o/books%2Fnew%20zest%201%2Fcover-zest-1.jpg?alt=media&token=76aa83b4-a110-4cef-b324-1c933799ee5c'), // book cover
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                          'New Zest 1 Language Learning English Basic'), // book name
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
        body: ListView(),
      ),
    );
  }
}
