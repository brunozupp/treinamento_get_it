import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:treinamento_get_it/controllers/post/post_list_controller.dart';
import 'package:treinamento_get_it/models/entities/post.dart';
import 'package:treinamento_get_it/pages/shared/loading_page.dart';

class PostListPage extends StatelessWidget {

  final PostListController postListController;

  const PostListPage({
    Key? key,
    required this.postListController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    postListController.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Posts"
        ),
      ),
      body: Observer(builder: (_) {
        
        if(postListController.store.isLoading) {
          return const LoadingPage();
        }
        
        return ListView.separated(
          separatorBuilder: (_, index) => const Divider(),
          itemCount: postListController.store.posts.length,
          itemBuilder: (_, index) {
            Post post = postListController.store.posts[index];

            return ListTile(
              title: Text(
                post.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                post.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }
        );
      }),
    );
  }
}
