import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<List<double>?> uploadAudioFile(File file) async {
  Uri url = Uri.parse('http://localhost:8084/music/');
  List<int> bytes = await file.readAsBytes();
  List<int> bytes_res = [];
  int resolution = (bytes.length/300).toInt() ;
  for(int i =0;i < bytes.length; ++i)
    {
      if (i % resolution == 0)
        {
          bytes_res.add(bytes[i]);
        }
    }

  final response = await http.post(
      Uri.parse('http://localhost:8084/music/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'music':bytes_res.toString()
      })
  );
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<double> data_new = data.map((e) => double.parse(e.toString())).toList();
    return data_new;
  } else {
    // Обработка ошибки
    return [];
  }
}




