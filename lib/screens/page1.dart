import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'class.dart'; // Ensure this import matches your file structure

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Welcome>> welcomeList;

  @override
  void initState() {
    super.initState();
    welcomeList = fetchAlbumModels();
  }

  Future<List<Welcome>> fetchAlbumModels() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((album) => Welcome.fromJson(album)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data'),
      ),
      body: Center(
        child: FutureBuilder<List<Welcome>>(
          future: welcomeList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No albums found');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Welcome album = snapshot.data![index];
                  return ListTile(
                    title: Text(album.title),
                    subtitle: Text('User ID: ${album.userId}, Album ID: ${album.id}'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

