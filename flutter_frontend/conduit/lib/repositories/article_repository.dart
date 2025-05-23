import 'package:conduit/api/api_client.dart';
import 'package:conduit/models/article.dart';

class ArticleRepository {
  final ApiClient apiClient;

  ArticleRepository({required this.apiClient});

  Future<List<Article>> getArticles({
    int limit = 20,
    int offset = 0,
    String? tag,
    String? author,
    String? favorited,
    String? token,
  }) async {
    final queryParams = {
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    
    if (tag != null) queryParams['tag'] = tag;
    if (author != null) queryParams['author'] = author;
    if (favorited != null) queryParams['favorited'] = favorited;
    
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    final headers = token != null ? {'Authorization': 'Token $token'} : null;
    
    final response = await apiClient.get(
      '/articles?$queryString',
      headers: headers,
    );
    
    final articles = (response['articles'] as List)
        .map((json) => Article.fromJson(json))
        .toList();
        
    return articles;
  }

  Future<List<Article>> getFeed({
    int limit = 20,
    int offset = 0,
    required String token,
  }) async {
    final queryString = 'limit=$limit&offset=$offset';
    
    final response = await apiClient.get(
      '/articles/feed?$queryString',
      headers: {'Authorization': 'Token $token'},
    );
    
    final articles = (response['articles'] as List)
        .map((json) => Article.fromJson(json))
        .toList();
        
    return articles;
  }

  Future<Article> getArticle(String slug, {String? token}) async {
    final headers = token != null ? {'Authorization': 'Token $token'} : null;
    
    final response = await apiClient.get(
      '/articles/$slug',
      headers: headers,
    );
    
    return Article.fromJson(response['article']);
  }

  Future<Article> createArticle({
    required String title,
    required String description,
    required String body,
    required List<String> tagList,
    required String token,
  }) async {
    final response = await apiClient.post(
      '/articles',
      headers: {'Authorization': 'Token $token'},
      body: {
        'article': {
          'title': title,
          'description': description,
          'body': body,
          'tagList': tagList,
        },
      },
    );
    
    return Article.fromJson(response['article']);
  }

  Future<Article> updateArticle({
    required String slug,
    String? title,
    String? description,
    String? body,
    required String token,
  }) async {
    final Map<String, dynamic> articleUpdate = {};
    
    if (title != null) articleUpdate['title'] = title;
    if (description != null) articleUpdate['description'] = description;
    if (body != null) articleUpdate['body'] = body;
    
    final response = await apiClient.put(
      '/articles/$slug',
      headers: {'Authorization': 'Token $token'},
      body: {'article': articleUpdate},
    );
    
    return Article.fromJson(response['article']);
  }

  Future<void> deleteArticle({
    required String slug,
    required String token,
  }) async {
    await apiClient.delete(
      '/articles/$slug',
      headers: {'Authorization': 'Token $token'},
    );
  }

  Future<Article> favoriteArticle({
    required String slug,
    required String token,
  }) async {
    final response = await apiClient.post(
      '/articles/$slug/favorite',
      headers: {'Authorization': 'Token $token'},
    );
    
    return Article.fromJson(response['article']);
  }

  Future<Article> unfavoriteArticle({
    required String slug,
    required String token,
  }) async {
    final response = await apiClient.delete(
      '/articles/$slug/favorite',
      headers: {'Authorization': 'Token $token'},
    );
    
    return Article.fromJson(response['article']);
  }
}
