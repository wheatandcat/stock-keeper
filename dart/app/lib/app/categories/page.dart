import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stockkeeper/utils/style.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stockkeeper/components/background/background.dart';
import 'package:stockkeeper/features/category/components/list.dart';
import 'package:stockkeeper/features/category/components/menu.dart';
import 'package:stockkeeper/graphql/categories.gql.dart';
import 'package:stockkeeper/graphql/deleteCategory.gql.dart';
import 'package:stockkeeper/graphql/deleteItem.gql.dart';
import 'package:stockkeeper/utils/graphql.dart';
import 'package:stockkeeper/app/categories/new/page.dart';
import 'package:stockkeeper/providers/user.dart';
import 'package:stockkeeper/features/category/hooks/useItems.dart';
import 'package:stockkeeper/features/category/components/items.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = useItems(ref);

    final selectCategoryId = useState<int>(0);

    final qcrs = useQuery$Categories(Options$Query$Categories(
        onComplete: (Map<String, dynamic>? data, Query$Categories? result) {
      List<Query$Categories$categories?> categories = result?.categories ?? [];
      if (categories.isNotEmpty) {
        selectCategoryId.value = int.tryParse(categories[0]?.id ?? '0')!;
      }
    }));

    final userDataAsyncValue = ref.watch(userDataProvider);

    useEffect(() {
      debugPrint('userDataAsyncValue: ${userDataAsyncValue.asData?.value?.id}');
      if (userDataAsyncValue.asData?.value?.id != null) {
        if (!qcrs.result.isLoading && qcrs.result.data == null) {
          qcrs.refetch();
        }
      }
      return null;
    }, [userDataAsyncValue.asData?.value?.id]);

    useEffect(() {
      items.get(selectCategoryId.value);
      return null;
    }, [selectCategoryId.value]);

    final List<Query$Categories$categories> categories = extractGraphQLDataList(
      data: qcrs.result.data,
      fieldName: "categories",
      fromJson: Query$Categories$categories.fromJson,
    );

    final mhdcr =
        useMutation$DeleteCategory(WidgetOptions$Mutation$DeleteCategory(
      onCompleted:
          (Map<String, dynamic>? data, Mutation$DeleteCategory? result) {
        context.pop();
        qcrs.refetch();
      },
    ));

    final mhdir = useMutation$DeleteItem(WidgetOptions$Mutation$DeleteItem(
      onCompleted: (Map<String, dynamic>? data, Mutation$DeleteItem? result) {
        items.get(selectCategoryId.value);
      },
    ));

    void showCustomMenu(
        BuildContext context, Query$Categories$categories category) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CategoryMenu(
              id: category.id,
              name: category.name,
              onEditCallback: () => {qcrs.refetch()},
              onDelete: (categoryId) {
                mhdcr.runMutation(Variables$Mutation$DeleteCategory(
                  id: int.tryParse(category.id) ?? 0,
                ));
              });
        },
      );
    }

    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    String categoryName = '';
    if (categories.isNotEmpty && selectCategoryId.value != 0) {
      categoryName = categories
          .firstWhere(
              (element) => element.id == selectCategoryId.value.toString())
          .name;
    }

    return BackgroundImage(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryList(
              categoryId: selectCategoryId.value,
              categories: categories,
              onAdd: () => {
                context.push("/categories/new", extra: CategoryNew(
                  onCallback: () {
                    qcrs.refetch();
                  },
                ))
              },
              onPassedItem: (categoryId) {
                selectCategoryId.value = categoryId;
              },
              onLongPressedItem: (category) {
                showCustomMenu(context, category);
              },
            ),
            Container(
              width: deviceWidth - 85,
              height: deviceHeight,
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(vertical: Spacing.lg),
              child: categories.isEmpty
                  ? const SafeArea(
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: Spacing.lg, top: Spacing.md),
                          child: Text(
                            'まずは部屋を作りましょう！\n左の＋マークを\nタップしてください。',
                            style: TextStyle(
                                fontSize: FontSize.lg,
                                fontWeight: FontWeight.bold),
                          )))
                  : CategoryItems(
                      categoryId: selectCategoryId.value,
                      categoryName: categoryName,
                      items: items.value,
                      onNewItem: () {
                        items.get(selectCategoryId.value);
                      },
                      onRefetch: () {
                        items.get(selectCategoryId.value);
                      },
                      onDelete: (int itemId) {
                        mhdir.runMutation(Variables$Mutation$DeleteItem(
                          id: itemId,
                        ));
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
