import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';

const int maxChartSize = 300000;

class Qr {
  final String data;

  /// Width of the Qr image
  final int width;

  /// Height of the Qr image
  final int height;

  Qr(this.data, {this.height: 100, this.width: 100}) {
    if ((height * width) > maxChartSize) throw new Exception('Image to big!');
  }

  Map<String, String> get _queryParameters =>
      {'cht': 'qr', 'chl': data, 'chs': "${width}x$height"};

  Uri get url {
    final base = "chart.googleapis.com";
    final path = "chart";
    return new Uri.https(base, path, _queryParameters);
  }

  Future fetch() async {
    final client = new Client();
    final Response resp = await client.get(url);
    return resp.bodyBytes;
  }

  Future save(String path) async {
    final data = await fetch();
    final file = new File(path);
    await file.writeAsBytes(data, flush: true);
  }
}
