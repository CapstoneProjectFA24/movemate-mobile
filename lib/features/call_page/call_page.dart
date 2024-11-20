import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String callID;
  final String currentUserId;
  final String currentUserName;

  const CallPage({
    super.key,
    required this.callID,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    String userId = 'user_${Random().nextInt(1000)}';
    String userName = 'user_${Random().nextInt(100)}';

    return ZegoUIKitPrebuiltCall(
        appID:
            1144653605, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            "af0bcdb584b619b8f46ad4d84f8083651e1a4829d574ad82a08f8ce53132bff8", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: currentUserId,
        userName: currentUserName,
        callID: callID,
        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}
