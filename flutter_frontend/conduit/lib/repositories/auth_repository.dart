import 'package:conduit/api/api_client.dart';
import 'package:conduit/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ApiClient apiClient;
  final FlutterSecureStorage secureStorage;

  AuthRepository({
    required this.apiClient,
    FlutterSecureStorage? secureStorage,
  }) : this.secureStorage = secureStorage ?? FlutterSecureStorage();

  Future<User> login(String email, String password) async {
    final response = await apiClient.post('/users/login', body: {
      'user': {
        'email': email,
        'password': password,
      },
    });
    final user = User.fromJson(response['user']);
    await secureStorage.write(key: 'token', value: user.token);
    return user;
  }

  Future<User> register(String username, String email, String password) async {
    final response = await apiClient.post('/users', body: {
      'user': {
        'username': username,
        'email': email,
        'password': password,
      },
    });
    final user = User.fromJson(response['user']);
    await secureStorage.write(key: 'token', value: user.token);
    return user;
  }

  Future<User?> getCurrentUser() async {
    final token = await secureStorage.read(key: 'token');
    if (token == null) return null;
    
    final response = await apiClient.get('/user', headers: {
      'Authorization': 'Token $token',
    });
    return User.fromJson(response['user']);
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'token');
  }
}
