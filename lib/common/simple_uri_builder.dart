import 'package:flutter_dotenv/flutter_dotenv.dart';

Uri simpleUriBuilder(String path, [Map<String, dynamic>? queryParameters]) {
  return Uri.http(dotenv.env['SERVER_HOST']!, path, queryParameters);
}
