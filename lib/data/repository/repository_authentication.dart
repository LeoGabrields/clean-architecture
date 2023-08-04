import 'package:clean_architecture/data/models/remote_account_model.dart';
import 'package:clean_architecture/domain/entities/entities.dart';
import 'package:clean_architecture/domain/helpers/domain_error.dart';

import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RepositoryAuthentication {
  final HttpClient httpClient;
  final String url;

  RepositoryAuthentication({required this.httpClient, required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toMap();
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: body,
      );
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }
}
