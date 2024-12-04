import 'dart:convert';

class UnlockWalletRequest {
  final String? bankNumber;
  final String? bankName;

  UnlockWalletRequest({
    this.bankNumber,
    this.bankName,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'bankNumber': bankNumber});
    result.addAll({'bankName': bankName});

    return result;
  }

  factory UnlockWalletRequest.fromMap(Map<String, dynamic> map) {
    return UnlockWalletRequest(
      bankNumber: map['bankNumber'] ?? '',
      bankName: map['bankName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UnlockWalletRequest( bankNumber: $bankNumber,  bankName: $bankName,)';
  }

  factory UnlockWalletRequest.fromJson(String source) =>
      UnlockWalletRequest.fromMap(json.decode(source));
}
