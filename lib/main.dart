import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:furnai/image_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _gallery = [];
  late Map<String, bool> _hovered;

  @override
  void initState() {
    _hovered = Map.fromEntries(
      _gallery.map(
        (e) => MapEntry(e, false),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.builder(
          itemCount: _gallery.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 128),
          itemBuilder: (_, index) => MouseRegion(
            onHover: (event) => setState(() {
              _hovered[_gallery[index]] = true;
            }),
            onExit: (event) => setState(() {
              _hovered[_gallery[index]] = false;
            }),
            child: AnimatedScale(
              scale: _hovered[_gallery[index]]! ? 1.2 : 1,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTapUp: (details) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditImagePage(imagePath: _gallery[index]),
                  ),
                ),
                child: Image.file(
                  File(_gallery[index]),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'save',
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png'],
          );
          final path = result?.paths.firstOrNull;
          if (path != null) {
            setState(() {
              _gallery.add(path);
              _hovered.update(
                path,
                (value) => false,
                ifAbsent: () => false,
              );
            });
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              const SnackBar(
                content: Text(
                  'File picking canceled',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            );
          }
        },
        tooltip: 'Pick file',
        child: const Icon(Icons.file_open),
      ),
    );
  }
}
