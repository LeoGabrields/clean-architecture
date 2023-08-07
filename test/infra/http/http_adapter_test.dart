import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapter {
  final Client client;
  HttpAdapter(
    this.client,
  );
  Future<void> request({
    required url,
    required String method,
    String? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    await client.post(url, headers: headers, body: body);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  final client = ClientSpy();
  final sut = HttpAdapter(client);
  final url = Uri.parse(faker.internet.httpUrl());
  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  final body = jsonEncode('{"any_key":"any_value"}');

  group('post', () {
    test('Should call post with correct values', () async {
      when(() => client.post(url, headers: headers, body: body))
          .thenAnswer((_) async => Response('{}', 200));

      await sut.request(
        url: url,
        method: 'post',
        body: body,
      );

      verify(
        () => client.post(
          url,
          headers: headers,
          body: body,
        ),
      );
    });

    test('Should call post without body', () async {
      when(() => client.post(url, headers: headers))
          .thenAnswer((_) async => Response('{}', 200));

      await sut.request(
        url: url,
        method: 'post',
      );

      verify(
        () => client.post(
          url,
          headers: any(named: 'headers'),
        ),
      );
    });
  });
}
