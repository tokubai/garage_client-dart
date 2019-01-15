class RequestBody {
  static final _fromUrlEncoded =
      "application/x-www-form-urlencoded; charset=utf-8";
  static final _fromJson = "application/json; charset=utf-8";
  static final _fromText = "text/plain; charset=utf-8";

  final String parameter;
  final headers = Map<String, String>();

  RequestBody(ContentType contentType, this.parameter) {
    var from = "";
    switch (contentType) {
      case ContentType.URL_ENCODED:
        {
          from = _fromUrlEncoded;
          break;
        }
      case ContentType.JSON:
        {
          from = _fromJson;
          break;
        }
      case ContentType.TEXT:
        {
          from = _fromText;
        }
    }
    ;

    headers["Content-Type"] = from;
  }

  factory RequestBody.fromParameter(Parameter parameter) {
    return RequestBody(ContentType.URL_ENCODED, parameter.build());
  }

  void addHeader(String name, dynamic value) {
    if (value is String) {
      headers[name] = value;
    } else if (value is int) {
      headers[name] = value.toString();
    } else {
      throw ArgumentError("${value.runtimeType.toString()} is not supported");
    }
  }
}

class Parameter {
  final _parameters = Map<String, String>();

  Parameter append(String key, dynamic value) {
    if (value is String) {
      _parameters[key] = value;
    } else if (value is int) {
      _parameters[key] = value.toString();
    } else {
      throw ArgumentError("${value.runtimeType.toString()} is not supported");
    }
    return this;
  }

  String build() {
    var parameters = List<String>();
    _parameters.forEach((key, value) => parameters.add("$key=$value"));
    if (parameters.isEmpty) {
      return "";
    }
    return parameters.reduce((a, b) => "$a&$b");
  }
}

enum ContentType { URL_ENCODED, JSON, TEXT }
