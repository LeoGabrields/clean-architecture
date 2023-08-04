abstract class HttpClient {
  Future<Map> request({
    String url,
    String method,
    Map? body,
  });
}
