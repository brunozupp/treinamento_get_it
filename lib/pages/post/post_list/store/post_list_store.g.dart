// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostListStore on _PostListStoreBase, Store {
  final _$postsAtom = Atom(name: '_PostListStoreBase.posts');

  @override
  ObservableList<Post> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(ObservableList<Post> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_PostListStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$errorAtom = Atom(name: '_PostListStoreBase.error');

  @override
  BaseException? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(BaseException? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$_PostListStoreBaseActionController =
      ActionController(name: '_PostListStoreBase');

  @override
  void setPosts(List<Post> value) {
    final _$actionInfo = _$_PostListStoreBaseActionController.startAction(
        name: '_PostListStoreBase.setPosts');
    try {
      return super.setPosts(value);
    } finally {
      _$_PostListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPosts() {
    final _$actionInfo = _$_PostListStoreBaseActionController.startAction(
        name: '_PostListStoreBase.clearPosts');
    try {
      return super.clearPosts();
    } finally {
      _$_PostListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_PostListStoreBaseActionController.startAction(
        name: '_PostListStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_PostListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(BaseException value) {
    final _$actionInfo = _$_PostListStoreBaseActionController.startAction(
        name: '_PostListStoreBase.setError');
    try {
      return super.setError(value);
    } finally {
      _$_PostListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_PostListStoreBaseActionController.startAction(
        name: '_PostListStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_PostListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
posts: ${posts},
isLoading: ${isLoading},
error: ${error}
    ''';
  }
}
