// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Biblioteca',
            textScaleFactor: 1.2,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
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
                    color: Color.fromARGB(255, 221, 221, 221),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  child: Text('Conteúdo'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: const Text('Exibir em Lista'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: const Text('Excluir Livros'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              backgroundColor: Color.fromARGB(255, 244, 244, 244),
              body: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'Sem livros na biblioteca.',
                      textScaleFactor: 1.7,
                    ),
                    SizedBox(height: 20.0),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(300, 20),
                      ),
                      onPressed: () => 0,
                      child: Text(
                        'Buscar',
                        textScaleFactor: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Color.fromARGB(255, 244, 244, 244),
              body: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'Sem favoritos marcados.',
                      textScaleFactor: 1.7,
                    ),
                    SizedBox(height: 20.0),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(300, 20),
                      ),
                      onPressed: () => 0,
                      child: Text(
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
