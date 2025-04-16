abstract interface class Usecase<Successtype, Params> {
  Future<Successtype> call(Params params);
}

class NoParam {}
