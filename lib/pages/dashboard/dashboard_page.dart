import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:treinamento_get_it/controllers/post/post_list_controller.dart';
import 'package:treinamento_get_it/pages/post/post_list_page.dart';

import 'widgets/card_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        children: [
          CardWidget(
            title: "Posts", 
            icon: Icons.file_copy_sharp, 
            iconColor: Colors.purple, 
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => PostListPage(
                postListController: PostListController(
                  postListStore: GetIt.I.get(),
                  postRepository: GetIt.I.get(),
                ),
              )));
            }
          ),

        ],
      ),
    );
  }
}