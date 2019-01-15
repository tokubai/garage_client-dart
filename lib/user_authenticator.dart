import 'dart:io';

abstract class UserAuthenticator {
  Future getAuthTokenIfNeeded();

  Future authenticationIfNeeded(HttpClientResponse response);

  Future requestPreparing(HttpClientRequest request);
}
