import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sampleflutter/components/appBar/common.dart';
import 'package:sampleflutter/graphql/updateCategory.gql.dart';
import 'package:sampleflutter/graphql/schema.graphql.dart';
import 'package:sampleflutter/components/background/background.dart';
import 'package:sampleflutter/features/category/components/input.dart';
import 'package:sampleflutter/graphql/category.gql.dart';
import 'package:sampleflutter/utils/graphql.dart';

class CategoryEdit extends HookWidget {
  final int id;
  final String name;
  final void Function() onCallback;

  const CategoryEdit(
      {super.key,
      required this.id,
      required this.name,
      required this.onCallback});

  @override
  Widget build(BuildContext context) {
    final queryResult = useQuery$Category(
        Options$Query$Category(variables: Variables$Query$Category(id: id)));

    final result = queryResult.result;

    if (result.isLoading) {
      return const Scaffold(
        appBar: CommonAppBar(title: ""),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final Query$Category$category category = extractGraphQLData(
      data: result.data,
      fieldName: "category",
      fromJson: Query$Category$category.fromJson,
    );

    final mutationHookResult =
        useMutation$UpdateCategory(WidgetOptions$Mutation$UpdateCategory(
      onCompleted:
          (Map<String, dynamic>? data, Mutation$UpdateCategory? result) {
        onCallback();
        Navigator.pop(context);
      },
    ));

    onPressed(InputCategory item) async {
      print("imageURL2: $item.imageUrl");

      mutationHookResult.runMutation(Variables$Mutation$UpdateCategory(
          input: Input$UpdateCategory(
        id: id,
        name: item.name,
        imageURL: item.imageURL,
        order: 0,
      )));
    }

    return BackgroundImage(
        child: Scaffold(
      appBar: const CommonAppBar(title: ""),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Input(
          loading: mutationHookResult.result.isLoading,
          defaultValue:
              InputCategory(name: category.name, imageURL: category.imageURL),
          onPressed: onPressed,
        ),
      ),
    ));
  }
}
