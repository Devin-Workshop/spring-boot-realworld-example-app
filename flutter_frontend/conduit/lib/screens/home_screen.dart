import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conduit/blocs/auth/auth_bloc.dart';
import 'package:conduit/repositories/article_repository.dart';
import 'package:conduit/models/article.dart';
import 'package:conduit/widgets/article_preview.dart';
import 'package:conduit/repositories/auth_repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Article> _globalArticles = [];
  List<Article> _feedArticles = [];
  List<String> _tags = [];
  String? _selectedTag;
  bool _isLoading = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authRepository = context.read<AuthRepository>();
      _token = await authRepository.getToken();

      final articleRepository = context.read<ArticleRepository>();
      
      // Load global articles
      _globalArticles = await articleRepository.getArticles(token: _token);
      
      // Load feed articles if authenticated
      if (_token != null) {
        _feedArticles = await articleRepository.getFeed(token: _token!);
      }
      
      // Load tags
      // This would typically be from a tag repository, simplified for this example
      _tags = _globalArticles
          .expand((article) => article.tagList)
          .toSet()
          .toList();

    } catch (e) {
      // Handle error
      print('Error loading data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectTag(String tag) {
    setState(() {
      _selectedTag = tag == _selectedTag ? null : tag;
    });
    _loadGlobalArticles();
  }

  Future<void> _loadGlobalArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articleRepository = context.read<ArticleRepository>();
      _globalArticles = await articleRepository.getArticles(
        token: _token,
        tag: _selectedTag,
      );
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conduit'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/profile');
                  },
                );
              } else {
                return TextButton(
                  child: Text('Sign in', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Global Feed'),
            Tab(text: 'Your Feed'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_tags.isNotEmpty)
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _tags.length,
                itemBuilder: (context, index) {
                  final tag = _tags[index];
                  final isSelected = tag == _selectedTag;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) => _selectTag(tag),
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Global Feed
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _globalArticles.isEmpty
                        ? Center(child: Text('No articles found'))
                        : ListView.builder(
                            itemCount: _globalArticles.length,
                            itemBuilder: (context, index) {
                              return ArticlePreview(
                                article: _globalArticles[index],
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/article',
                                    arguments: _globalArticles[index].slug,
                                  );
                                },
                              );
                            },
                          ),
                
                // Your Feed
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthUnauthenticated) {
                      return Center(
                        child: Text('Please sign in to view your feed'),
                      );
                    }
                    
                    return _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _feedArticles.isEmpty
                            ? Center(child: Text('No articles in your feed'))
                            : ListView.builder(
                                itemCount: _feedArticles.length,
                                itemBuilder: (context, index) {
                                  return ArticlePreview(
                                    article: _feedArticles[index],
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        '/article',
                                        arguments: _feedArticles[index].slug,
                                      );
                                    },
                                  );
                                },
                              );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/editor');
              },
              child: Icon(Icons.add),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
