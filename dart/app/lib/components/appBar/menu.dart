import 'package:flutter/material.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Dialog(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 20, bottom: 40, right: 20, left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    title: Align(
                      alignment: Alignment.center,
                      child: Text("設定",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Card(
                        margin: EdgeInsets.zero,
                        color: Colors.transparent,
                        elevation: 0,
                        shape: Border(
                            bottom:
                                BorderSide(color: Colors.black26, width: 0.0)),
                        child: ListTile(
                          title: Text("ログイン",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )),
                  const Card(
                    margin: EdgeInsets.zero,
                    color: Colors.transparent,
                    elevation: 0,
                    shape: Border(
                        bottom: BorderSide(color: Colors.black26, width: 0.0)),
                    child: ListTile(
                      title: Text("利用規約",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Card(
                    margin: EdgeInsets.zero,
                    color: Colors.transparent,
                    elevation: 0,
                    shape: Border(
                        bottom: BorderSide(color: Colors.black26, width: 0.0)),
                    child: ListTile(
                      title: Text("プライバシー・ポリシー",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8, // 位置を適切に調整
              left: 8, // 位置を適切に調整
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
