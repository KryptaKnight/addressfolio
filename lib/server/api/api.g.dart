// GENERATED CODE - DO NOT MODIFY BY HAND

part of kryptaknight.server.api;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class UserSerializer
// **************************************************************************

abstract class _$UserSerializer implements Serializer<User> {
  Map toMap(User model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.name != null) {
        ret["name"] = model.name;
      }
      if (model.email != null) {
        ret["email"] = model.email;
      }
      if (model.pwdHash != null) {
        ret["pwdHash"] = model.pwdHash;
      }
      if (model.btcAddrs != null) {
        ret["btcAddrs"] = model.btcAddrs;
      }
      if (model.ltcAddrs != null) {
        ret["ltcAddrs"] = model.ltcAddrs;
      }
      if (model.ethAddrs != null) {
        ret["ethAddrs"] = model.ethAddrs;
      }
      if (model.neoAddrs != null) {
        ret["neoAddrs"] = model.neoAddrs;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  User fromMap(Map map, {User model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! User) {
      model = createModel();
    }
    model.id = map["id"];
    model.name = map["name"];
    model.email = map["email"];
    model.pwdHash = map["pwdHash"];
    model.btcAddrs = map["btcAddrs"];
    model.ltcAddrs = map["ltcAddrs"];
    model.ethAddrs = map["ethAddrs"];
    model.neoAddrs = map["neoAddrs"];
    return model;
  }

  String modelString() => "User";
}
