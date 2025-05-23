import 'package:flutter/material.dart';
import 'package:conduit/models/article.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticlePreview extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticlePreview({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: article.author.image.isNotEmpty
                        ? NetworkImage(article.author.image)
                        : null,
                    child: article.author.image.isEmpty
                        ? Text(article.author.username[0].toUpperCase())
                        : null,
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.author.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeago.format(article.createdAt),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      article.favorited ? Icons.favorite : Icons.favorite_border,
                      color: article.favorited ? Colors.red : null,
                    ),
                    onPressed: () {
                      // Handle favorite action
                    },
                  ),
                  Text('${article.favoritesCount}'),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8.0),
              Text(
                article.description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Read more...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Wrap(
                    spacing: 4.0,
                    children: article.tagList.map((tag) {
                      return Chip(
                        label: Text(tag),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelStyle: TextStyle(fontSize: 10.0),
                        padding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
