import 'dart:io';

class GarageError implements Exception {
  HttpClientResponse response;

  GarageError(HttpClientResponse);
}
