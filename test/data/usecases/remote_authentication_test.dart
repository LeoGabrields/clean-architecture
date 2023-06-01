import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/src/data/usecases/usecases.dart';
import 'package:clean_architecture/src/data/http/http.dart';
import 'package:clean_architecture/src/domain/usecases/authentication.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient = HttpClientSpy();
  String url = faker.internet.httpUrl();
  RemoteAuthentication sut =
      RemoteAuthentication(httpClient: httpClient, url: url);
  final params = AuthenticationParams(
    email: faker.internet.email(),
    password: faker.internet.password(),
  );

  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: params.toJson(),
    ));
  });
}
