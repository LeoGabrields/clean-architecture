import 'dart:convert';

import 'package:clean_architecture/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapter implements HttpClient {
  final Client client;
  HttpAdapter(
    this.client,
  );

  @override
  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response =
        await client.post(Uri.parse(url), headers: headers, body: jsonBody);
    return jsonDecode(response.body);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  final client = ClientSpy();
  final sut = HttpAdapter(client);
  final url = faker.internet.httpUrl();
  final uri = Uri.parse(url);
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  const jsonBody = '{"any_key":"any_value"}';

  group('post', () {
    When mockRequest() => when(() => client.post(uri,
        headers: any(named: 'headers'), body: any(named: 'body')));

    void mockResponse(int statusCode, {String body = '{}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut
          .request(url: url, method: 'post', body: {"any_key": "any_value"});

      verify(() => client.post(
            uri,
            headers: headers,
            body: jsonBody,
          ));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(uri,
          headers: any(
            named: 'headers',
          )));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {});
    });
  });
}
