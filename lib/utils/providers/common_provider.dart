import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';

final authProvider = StateProvider<UserModel?>((ref) => null);
final dioProvider = Provider.autoDispose((ref) => Dio());
final modifyProfiver = StateProvider.autoDispose<bool>((ref) => false);
