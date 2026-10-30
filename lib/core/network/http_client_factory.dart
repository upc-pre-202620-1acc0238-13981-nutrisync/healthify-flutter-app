import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'api_config.dart';

/// Base HTTP client with the connection timeout. The anonymous and authenticated stacks share it, so they reuse
/// the connection pool.
http.Client createHttpClient() => IOClient(HttpClient()..connectionTimeout = connectTimeout);
