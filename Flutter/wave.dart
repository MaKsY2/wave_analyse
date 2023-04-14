import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:beats/view/home_page/painter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';

import 'io_music.dart';


class Wave extends StatefulWidget {
  const Wave({Key? key}) : super(key: key);

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> {

  @override
  void dispose() {
    super.dispose();
  }




  List<double> myList = const [
    0.13, -0.42, 0.23, 0.10, 0.27, 0.24, 0.29, -0.25, 0.20, 0.28, 0.22, 0.14, 0.18, 0.21, 0.19, 0.11, 0.26, 0.15, 0.16, 0.17
  ];

  List<double>? amplitudes = [];
  final MethodChannel _methodChannel = const MethodChannel('flutter_ffmpeg');
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            SizedBox(height: 50),
            GestureDetector(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles();
                  if (result != null) {
                    final file = File(result.files.single.path!);
                    amplitudes = await uploadAudioFile(file);
                    setState(() {
                      amplitudes;
                    });

                    // final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
                    // final inputAudioFilePath = result.files.single.path!;
                    // final command = '-i $inputAudioFilePath -filter_complex "ebur128" - 2>/dev/null';
                    // final command3 = '-i $inputAudioFilePath -filter_complex "ebur128=metadata=1" -f null - 2>&1 | awk -F\': \' \'/^I:/{printf "%.3f,",\$2}\' | sed \'s/,\$//';
                    // final command1 = '-i $inputAudioFilePath -filter_complex "showwaves=format=ydata" -c:a copy -f null - 2>/dev/null';
                    // String command4 = '-i $inputAudioFilePath -filter_complex "astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - ';
                    //
                    //
                    //
                    // //final arguments = FlutterFFmpeg.parseArguments(command4);
                    // //final Map<dynamic, dynamic> results = await _methodChannel.invokeMethod('executeFFmpegWithArguments', {'arguments': arguments});
                    // //print(await _methodChannel.invokeMethod('getLastCommandOutput'));
                    // final mediaInformation = await _methodChannel.invokeMethod('getMediaInformation',
                    //     {'path': inputAudioFilePath}).then((value) => new MediaInformation(value));
                    // double a = double.parse(mediaInformation.getMediaProperties()!["duration"]);
                    // int timeInMilliseconds = 5000; // например, 5 секунд
                    // int timeInSeconds = timeInMilliseconds ~/ 1000; // переводим в секунды
                    // String cmd = "-ss $timeInSeconds -i $inputAudioFilePath  -filter:a showvolume=f=1:b=0.5 -f null -";
                    // String cmd2 = "-ss $timeInSeconds -i $inputAudioFilePath  -filter_complex ebur128=peak=true:meter=18 -t 100 -f null output.txt";
                    // final arguments2 = FlutterFFmpeg.parseArguments(cmd2);
                    // final Map<dynamic, dynamic> results = await _methodChannel.invokeMethod('executeFFmpegWithArguments', {'arguments': arguments2});
                    // final output = await _methodChannel.invokeMethod('getLastCommandOutput');
                    // print(json.encode(output));
                    // RegExp regex = RegExp(r'(?<="I": )-?\d+\.?\d*');
                    // double amplitude = double.parse(regex.firstMatch(output)!.group(0)!);
                    // print("adasdas $amplitude");


                  } else {
                    // Something...
                  }
                },
                child: Container(
                  height: 100,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: const Center(
                    child: Text(
                      'Pick File',
                      style: TextStyle(
                          fontSize: 24
                      ),
                    ),
                  ),
                )
            ),
            SizedBox(height: 50),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              //color: Colors.blue,
              child: CustomPaint(
                painter: AmplitudePainter(amplitudeData: (amplitudes!.length == 0) ? myList : amplitudes!),
              ),
            )

          ]
      ),
    );
  }
}