library kryptaknight.server.api;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar_mongo/jaguar_mongo.dart';
import 'package:jaguar_auth/jaguar_auth.dart';


part 'api.g.dart';

const mongoUrl = "mongodb://localhost:27018/kryptoknight";

class User implements AuthorizationUser {
  String id;

  String name;

  String email;

  String pwdHash;

  bool confirmed;

  String btcAddrs;

  String ltcAddrs;

  String ethAddrs;

  String neoAddrs;

  static final UserSerializer serializer = new UserSerializer();

  String get authorizationId => id;
}

@GenSerializer()
class UserSerializer extends Serializer<User> with _$UserSerializer {
  User createModel() => new User();
}

class UserManager implements AuthModelManager<User> {
  const UserManager();

  static const Sha256Hasher hasher = const Sha256Hasher(
      'dfgdfgdfer4w543645yxbcxvdfrfbadfsa456jhbfdhjnbvcddwertyhtr56ytgfdhmngbfdrtybfg');

  Future<User> fetchModelByAuthenticationId(Context ctx, String email) async {
    final mgo.Db db = ctx.getInput(MongoDb);
    final userMap =
        await db.collection('user').findOne(mgo.where.eq('email', email));
    return User.serializer.fromMap(userMap);
  }

  Future<User> fetchModelByAuthorizationId(Context ctx, String id) async {
    final mgo.Db db = ctx.getInput(MongoDb);
    final userMap =
        await db.collection('user').findOne(mgo.where.eq('_id', id));
    return User.serializer.fromMap(userMap);
  }

  Future<User> authenticate(Context ctx, String email, String keyword) async {
    final User user = await fetchModelByAuthenticationId(ctx, email);
    if (!user.confirmed) return null;
    if (email == null) return null;
    if (!hasher.verify(user.pwdHash, keyword)) return null;
    return user;
  }

  static const UserManager manager = const UserManager();
}

@Api(path: '/auth')
class Auth extends Object with JsonRoutes {
  MongoDb mongoDb(Context ctx) => new MongoDb(mongoUrl);

  JsonAuth jsonAuth(Context ctx) => new JsonAuth(UserManager.manager);

  @Post(path: '/login', mimeType: 'application/json')
  @Wrap(const [#mongoDb, #basicAuth])
  Future login(Context ctx) async {
    final User user = ctx.getInput<User>(JsonAuth);
    return toJson(user);
  }

  @Post(path: '/signup', mimeType: 'application/json')
  @Wrap(const [#mongoDb])
  Future<String> signup(Context ctx) async {
    final Map body = await ctx.req.bodyAsJson();
    final String name = body['n'];
    final String email = body['m'];
    final String pwd = body['p'];

    if (name is! String || name.trim().isEmpty || name.length > 20)
      throw new Exception('Invalid name!');
    if (email is! String || email.isEmpty || email.length > 30)
      throw new Exception('Invalid email!');
    if (pwd is! String || pwd.isEmpty || pwd.length > 100)
      throw new Exception('Invalid password!');

    // TODO validate

    final user = new User()
          ..name = name
          ..email = email
          ..pwdHash = pwd // TODO hash password
        ;

    final mgo.Db db = ctx.getInput(MongoDb);
    await db.collection('user').insert(User.serializer.toMap(user));

    return "{'Message': 'Check your email for confirmation message!'}";
  }

  Future logout(Context ctx) async {
    // Clear session data
    (await ctx.req.session).clear();
  }

  Future resetPassword(Context ctx) {
    // TODO
  }

  Future changePwd(Context ctx) {
    // TODO
  }

  Future getBasket(Context ctx) {
    // TODO
  }
}
