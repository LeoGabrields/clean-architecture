import 'package:clean_architecture/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_architecture/infra/http/http.dart';
import 'package:flutter_test/flutter_test.dart';

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

    void mockResponse(int statusCode, {String body = '{"teste":"teste"}'}) {
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

      expect(response, {'teste': 'teste'});
    });

    test('Should return null if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
