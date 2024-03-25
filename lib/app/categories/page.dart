import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/components/appBar/common.dart';
import 'package:sampleflutter/components/icon/add.dart';
import 'package:sampleflutter/graphql/categories.gql.dart';
import 'package:sampleflutter/graphql/deleteCategory.gql.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sampleflutter/utils/graphql.dart';
import 'package:sampleflutter/app/categories/edit/page.dart';
import 'package:sampleflutter/app/categories/new/page.dart';

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final queryResult = useQuery$Categories(Options$Query$Categories());

    final result = queryResult.result;

    final List<Query$Categories$categories> categories = extractGraphQLDataList(
      data: result.data,
      fieldName: "categories",
      fromJson: Query$Categories$categories.fromJson,
    );

    final mutationHookResult =
        useMutation$DeleteCategory(WidgetOptions$Mutation$DeleteCategory(
      onCompleted:
          (Map<String, dynamic>? data, Mutation$DeleteCategory? result) {
        Navigator.of(context).pop();
        queryResult.refetch();
      },
    ));

    void _showCustomMenu(
        BuildContext context, Query$Categories$categories category) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 40.0,
                  left: 10.0,
                  right: 10.0), // 上に20、下に10の余白を追加
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    title: Text(category.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('カテゴリー名を変更する'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/categories/edit',
                          arguments: CategoryEdit(
                            id: int.tryParse(category.id) ?? 0,
                            name: category.name,
                            onCallback: () {
                              queryResult.refetch();
                            },
                          ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('カテゴリーを削除する'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('削除確認'),
                            content: Text('${category.name}を削除しますか？'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('キャンセル'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('削除'),
                                onPressed: () {
                                  mutationHookResult.runMutation(
                                      Variables$Mutation$DeleteCategory(
                                    id: int.tryParse(category.id) ?? 0,
                                  ));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ));
        },
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(title: "カテゴリ画面"),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return InkWell(
              key: Key(categories[index].id.toString()),
              onLongPress: () => _showCustomMenu(context, categories[index]),
              onTap: () {
                Navigator.pushNamed(
                    context, '/categories/${categories[index].id}');
              },
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: const Border(
                    bottom: BorderSide(color: Colors.white, width: 3)),
                child: ListTile(
                  title: Text(categories[index].name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text('${categories[index].itemCount} ITEMS',
                      style: const TextStyle(color: Colors.white)),
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          Navigator.pushNamed(context, '/categories/new',
              arguments: CategoryNew(
            onCallback: () {
              queryResult.refetch();
            },
          ));
        },
        tooltip: 'Increment',
        child: const AddIcon(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
