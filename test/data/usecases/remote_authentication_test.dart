import 'package:clean_architecture/data/http/http.dart';
import 'package:clean_architecture/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture/data/usecases/usecases.dart';
import 'package:clean_architecture/domain/usecases/usecases.dart';

class HttpCLientSpy extends Mock implements HttpClient {}

void main() {
  final httpClient = HttpCLientSpy();
  final url = faker.internet.httpUrl();
  final sut = RemoteAuthentication(httpClient: httpClient, url: url);
  final params = AuthenticationParams(
      email: faker.internet.email(), secret: faker.internet.password());

  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(url: '', method: '', body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    try {
      sut.auth(params);
    } catch (e) {
      expect(e, throwsA(DomainError.unexpected));
    }
  });
  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    when(httpClient.request(url: '', method: '', body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    try {
      sut.auth(params);
    } catch (e) {
      expect(e, throwsA(DomainError.unexpected));
    }
  });
  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    when(httpClient.request(url: '', method: '', body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    try {
      sut.auth(params);
    } catch (e) {
      expect(e, throwsA(DomainError.unexpected));
    }
  });
}
