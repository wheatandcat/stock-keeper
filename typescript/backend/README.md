# stock-keeper-backend

## API Document

- https://wheatandcat.github.io/stock-keeper/introduction/welcome

## ローカル起動

```shell
pnpm run dev
```

## Resolver生成

```shell
npx nest g res
```

## GraphQL Code Gen

```shell
pnpm codegen
```

## Prisma

```shell
pnpm db:push
```

## デプロイ

mainブランチにマージでデプロイされる。

## CI

### レビュー環境

```shell
$ base64 -i ./src/firebase.json | pbcopy
```

### GraphQLドキュメント生成

```shell
$ magidoc generate
```

プレビュー

```shell
$ magidoc preview
```
