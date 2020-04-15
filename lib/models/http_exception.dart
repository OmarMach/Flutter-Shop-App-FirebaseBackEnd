class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    return "HTTP ERROR: " + message;
  }
}
