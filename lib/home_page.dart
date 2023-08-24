import 'package:flutter/material.dart';
import 'package:project_oshiro/search.dart';

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
              body: Center(
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
