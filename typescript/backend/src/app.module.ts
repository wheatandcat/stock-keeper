import { Module } from '@nestjs/common'
import { GraphQLModule } from '@nestjs/graphql'
import { MercuriusDriver, type MercuriusDriverConfig } from '@nestjs/mercurius'
import { AppController } from '@src/app.controller'
import { AppService } from '@src/app.service'
import { HelloResolver } from './hello.resolver'
import { CategoryResolver } from '@src/resolver/category'
import { ItemResolver } from '@src/resolver/item'
import { UserResolver } from '@src/resolver/user'
import { CartResolver } from '@src/resolver/cart'
import { InviteResolver } from '@src/resolver/invite'
import { GuestResolver } from '@src/resolver/guest'
import { PrismaService } from '@src/modules/prisma/prisma.service'

@Module({
  controllers: [AppController],
  providers: [
    AppService,
    HelloResolver,
    UserResolver,
    CategoryResolver,
    ItemResolver,
    CartResolver,
    InviteResolver,
    GuestResolver,
    PrismaService,
  ],
  imports: [
    GraphQLModule.forRoot<MercuriusDriverConfig>({
      driver: MercuriusDriver,
      graphiql: true,
      typePaths: ['./**/schema.graphql'],
    }),
  ],
})
export class AppModule {}
