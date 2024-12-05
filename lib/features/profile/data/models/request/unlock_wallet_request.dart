import 'dart:convert';

class UnlockWalletRequest {
  final String? bankNumber;
  final String? bankName;
  final String? cardHolderName;
  final String? expirdAt;

  UnlockWalletRequest({
    this.bankNumber,
    this.bankName,
    this.cardHolderName,
    this.expirdAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'bankNumber': bankNumber});
    result.addAll({'bankName': bankName});
    result.addAll({'cardHolderName': cardHolderName});
    result.addAll({'expirdAt': expirdAt});

    return result;
  }

  factory UnlockWalletRequest.fromMap(Map<String, dynamic> map) {
    return UnlockWalletRequest(
      bankNumber: map['bankNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      cardHolderName: map['cardHolderName'] ?? '',
      expirdAt: map['expirdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UnlockWalletRequest( bankNumber: $bankNumber,  bankName: $bankName, cardHolderName: $cardHolderName, expirdAt : $expirdAt)';
  }

  factory UnlockWalletRequest.fromJson(String source) =>
      UnlockWalletRequest.fromMap(json.decode(source));
}
