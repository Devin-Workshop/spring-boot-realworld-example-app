import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conduit/api/api_client.dart';
import 'package:conduit/repositories/auth_repository.dart';
import 'package:conduit/repositories/article_repository.dart';
import 'package:conduit/blocs/auth/auth_bloc.dart';
import 'package:conduit/screens/home_screen.dart';
import 'package:conduit/screens/login_screen.dart';
import 'package:conduit/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(baseUrl: 'http://localhost:8080/api');
    final authRepository = AuthRepository(apiClient: apiClient);
    final articleRepository = ArticleRepository(apiClient: apiClient);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: articleRepository),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository: authRepository)..add(AppStarted()),
        child: MaterialApp(
          title: 'Conduit',
          theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            // Add more routes as needed
          },
        ),
      ),
    );
  }
}
