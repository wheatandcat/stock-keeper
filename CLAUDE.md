# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Stock Keeperは食材や日用品の在庫管理を行うモバイルアプリケーションです。Flutter製のクライアントアプリとNestJS製のバックエンドAPI、そしてTiDB ServerlessをデータベースとするGraphQLベースのシステムです。

## Directory Structure

```
├── dart/app/                    # Flutter mobile application
├── typescript/backend/          # NestJS GraphQL API server  
├── typescript/tools/            # Development utilities
└── docs/                        # Documentation and assets
```

## Technology Stack

- **Frontend**: Flutter 3.2.3+ with GraphQL, Riverpod for state management
- **Backend**: NestJS with GraphQL, Prisma ORM, Fastify platform
- **Database**: TiDB Serverless with Prisma
- **Authentication**: Firebase Authentication with Google Sign-in
- **Storage**: Firebase Storage for image uploads
- **Infrastructure**: Cloud Run for deployment

## Common Development Commands

### Flutter App (dart/app/)
```bash
# Development
flutter run --dart-define-from-file=.env.development
flutter test

# Code generation
flutter packages pub run build_runner build --delete-conflicting-outputs

# Linting
flutter analyze
dart fix --apply

# Dependencies  
flutter pub get
flutter pub upgrade
```

### Backend API (typescript/backend/)
```bash
# Development
npm run dev                    # Start development server with hot reload
npm run start                  # Start production server

# Database
npm run db:push               # Push schema changes to database
npm run db:pull               # Pull schema changes from database  
npm run db:studio             # Open Prisma Studio

# Code quality
npm run lint                  # ESLint with auto-fix
npm run format                # Prettier formatting
npm run test                  # Run Jest tests
npm run test:e2e              # End-to-end tests
npm run test:cov              # Test coverage

# GraphQL
npm run codegen               # Generate TypeScript types from schema
```

## Architecture Notes

### GraphQL Schema & Code Generation
- Schema定義はbackend/src/generated/graphql.tsで管理
- Flutter側では`graphql_codegen`を使用してDartクラスを生成
- Backend側では`@graphql-codegen/cli`でTypeScript型を生成

### State Management (Flutter)
- Riverpodを使用した状態管理
- `riverpod_generator`でプロバイダーを自動生成
- GraphQLクエリは`graphql_flutter`とRiverpodを組み合わせて実装

### Authentication Flow
- Firebase Authenticationを使用
- Google Sign-inでの認証をサポート
- バックエンドでFirebase Admin SDKを使用してトークン検証
- ゲストモードでの一時利用も可能

### Image Handling
- Flutter側で`image_picker`と`image_cropper`を使用
- Firebase Storageにアップロード
- 商品画像から商品名をGoogle ML Kitで抽出
- 商品検索APIと連携して商品情報を取得

### Database Schema
- Prismaを使用したORM
- User, Category, Item, Cart, Inviteの主要エンティティ
- 家族間での在庫共有機能を実装

## Development Workflow

1. バックエンドAPIの変更時は`npm run codegen`でGraphQL型を生成
2. FlutterでGraphQLクエリを追加時は`flutter packages pub run build_runner build`を実行
3. データベーススキーマ変更時は`npm run db:push`でPrismaスキーマを反映
4. コード変更前に`flutter analyze`と`npm run lint`でコード品質を確認

## Environment Configuration

- Flutter: `.env.development`, `.env.production`ファイルでFirebase設定を管理
- Backend: 環境変数で`DATABASE_URL`、Firebase Admin設定を管理
- Cloud Runでの本番環境デプロイではSecret Managerを使用