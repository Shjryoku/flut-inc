import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv6, 80);
  print('Server was started on http://${server.address.host}:${server.port}');

  await for (HttpRequest request in server){
    final path = request.uri.path;
    final file = File('dummy.txt');

    if(path == '/write'){
      final content = await utf8.decoder.bind(request).join();
      await file.writeAsString(content, mode: FileMode.write);

      request.response
        ..statusCode = HttpStatus.ok
        ..write('Data was written to ${path}')
        ..close();
    } else if (path == '/read'){
      if(await file.exists()){
        final content = await file.readAsString();

        request.response
          ..statusCode = HttpStatus.ok
          ..write('Data: ${content}')
          ..close();
      } else{
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('File is not found')
          ..close();
      }
    } else {
      request.response
        ..statusCode = HttpStatus.ok
        ..write('Unknown path')
        ..close();
    }
  }
}
