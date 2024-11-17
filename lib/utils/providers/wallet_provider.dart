import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/profile/domain/entities/wallet_entity.dart';
import '../../models/user_model.dart';


final walletProvider = StateProvider<WalletEntity?>((ref) => null);

