import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapter {
  final Client client;
  HttpAdapter(
    this.client,
  );
  Future<void> request(Uri url, String method) async {
    await client.post(url);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('post', () {
    test('Should call post with correct values', () async {
      final client = ClientSpy();
      final sut = HttpAdapter(client);
      final url = Uri.parse(faker.internet.httpUrl());

      when(() => client.post(url)).thenAnswer((_) async => Response('{}', 200));
      await sut.request(url, 'post');

      verify(() => client.post(url));
    });
  });
}
