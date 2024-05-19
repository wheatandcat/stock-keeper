import 'package:flutter/material.dart';
import 'package:sampleflutter/components/appBar/menu.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'images/background.png',
          fit: BoxFit.cover, // 画像がAppBar全体に広がるように設定
        ),
      ),
      actions: <Widget>[
        IconButton(
            color: Colors.white,
            icon: const Icon(Icons.menu), // メニューアイコン
            onPressed: () {
              _showDialog(context);
            }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

void _showDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const AppBarMenu();
    },
  );
}
