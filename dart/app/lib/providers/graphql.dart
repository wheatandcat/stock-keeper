import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stockkeeper/utils/graphql.dart';

final graphqlClientProvider = Provider<GraphQLClient>((ref) {
  return graphqlClient();
});
