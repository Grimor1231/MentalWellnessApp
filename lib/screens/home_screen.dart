import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchResources() async {
  final response = await http.post(
    Uri.parse('https://data.cms.gov/provider-data/api/1/datastore/query/xubh-q36u/0'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "conditions": [
        {
          "resource": "t",
          "property": "record_number",
          "value": 1,
          "operator": ">"
        }
      ],
      "limit": 3
    }),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['results'] as List;
  } else {
    throw Exception('Failed to load resources');
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> resources;

  @override
  void initState() {
    super.initState();
    resources = fetchResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Of Hospitals'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: resources,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.book),
                  title: Text(snapshot.data![index]['facility_name']),
                  subtitle: Text(snapshot.data![index]['address']),
                  onTap: () {},
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

