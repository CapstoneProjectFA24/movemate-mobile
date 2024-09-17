import 'package:flutter/material.dart';

class AssetsConstants {
  // Colors
  // PRIMARY
  static const primaryLighter = Color(0xffFF9B63);
  static const primaryLight = Color(0xffFF9B63);

  static const primaryMain = Color(0xffFF5C00);
  static const primaryDark = Color(0xffFF5C00);
  static const primaryDarker = Color(0xffFF5C00);

  // SECONDARY
  static const secondaryLighter = Color(0xffD1E9FC);
  static const secondaryLight = Color(0xff76B0F1);
  static const secondaryMain = Color(0xff2065D1);
  static const secondaryDark = Color(0xff103996);
  static const secondaryDarker = Color(0xff061B64);

  // INFO
  static const infoLighter = Color(0xffD6E4FF);
  static const infoLight = Color(0xff84A9FF);
  static const infoMain = Color(0xff3366FF);
  static const infoDark = Color(0xff1939B7);
  static const infoDarker = Color(0xff091A7A);

  // SUCCESS
  static const successLighter1 = Color(0xff81C784);
  static const successLighter = Color(0xffC8FACD);
  static const successLight = Color(0xff5BE584);
  static const successMain = Color(0xff00AB55);
  static const successDark = Color(0xff007B55);
  static const successDarker = Color(0xff005249);

  // WARNING
  static const warningLighter = Color(0xffFFF7CD);
  static const warningLight = Color(0xffFFE16A);
  static const warningMain = Color(0xffFFC107);
  static const warningDark = Color(0xffB78103);
  static const warningDarker = Color(0xff7A4F01);

  // ERROR
  static const errorLighter = Color(0xffFFE7D9);
  static const errorLight = Color(0xffFFA48D);
  static const errorMain = Color(0xffFF4842);
  static const errorDark = Color(0xffB72136);
  static const errorDarker = Color(0xff7A0C2E);

  // PURPLE
  static const purpleLight = Color(0xff98BAE7);
  static const purpleMain = Color(0xff7267CB);
  static const purpleDark = Color(0xff6E3CBC);

  // OTHER
  static const black_20 = Color(0xffCCCCCC);
  static const green2 = Color(0xff81C784);
  static const green3 = Color(0xff50C878);
  static const green1 = Color(0xff4CAF50);
  static const green4 = Color(0xff2D8F4E);
  static const green5 = Color(0xff228B22);
  static const green6 = Color(0xff116530);
  static const greenish = Color(0xFFC8E6C9);

  static const darkGreen1 = Color(0xff536732);
  static const darkGreen2 = Color(0xff556B2F);
  static const blue3 = Color(0xff30D5C8);
  static const blue2 = Color(0xff03A9F4);
  static const blue1 = Color(0xff2196F3);
  static const pine1 = Color(0xff009688);
  static const blue4 = Color(0xff1D8D84);
  static const red1 = Color(0xffBF4F4F);
  static const red2 = Color(0xffC85151);
  static const red3 = Color(0xffE4021B);
  static const red4 = Color(0xffbb0909);
  static const yellow3 = Color(0xffFFA500);
  static const yellow1 = Color(0xffC3941D);
  static const yellow2 = Color(0xffCC9B1E);
  static const yellow4 = Color(0xffA36A00);
  static const purple2 = Color(0xff9575CD);
  static const purple1 = Color(0xff673AB7);
  static const purple3 = Color(0xffA020F0);
  static const purple4 = Color(0xff6C0BA9);

  // other
  static const mainColor = Color(0xffFF5C00);
  static const warningColor = Color(0xffFF0000);
  static const subtitleColor = Color(0xff868C98);
  static const subtitleColorM = Color(0xff7F858D);
  static const whiteColor = Color(0xffFFFFFF);
  static const blackColor = Color(0xff000000);
  static const greyColor = Colors.grey;
  static const pinkColor = Colors.pinkAccent;
  static const scaffoldColor = Color(0xffF6F7FC);
  static const borderColor = Color(0xffB3B9C1);
  static const textBlur = Color(0xff7F858D);
  static const linearColor = Color(0xffD2D8E0);
  static const skipText = Color(0xff5B6169);
  static const cancelIconColor = Color(0xff7F858D);
  static const revenueBackground = Color(0xffFCE4EC);
  static const totalOrderBackground = Color(0xffC8FAD6);
  static const totalOrderContent = Color(0xff08660D);
  static const transparentColor = Colors.transparent;
  static const preparingColor = Color(0xffCE6147);
  static const upcomingColor = Color(0xffD5770B);
  static const completedColor = Color(0xff1AD285);
  static const discountColor = Color(0xffff8134);
  static const searchBoxColor = Color(0xffF6F7FB);
  static const descriptionColor = Color(0xff818A94);
  static const beaminColor = Color(0xff3BC6C9);
  static const grabColor = Color(0xff00B14F);
  static const shopeeColor = Color(0xffED4C2F);
  static const accountBankingBackgroundColor = Color(0xffD1E9FC);
  static const accountBankingContent = Color(0xff061B64);
  static const transactionBackgroundColor = Color(0xffFDF7D5);
  static const transactionContent = Color(0xff906D2E);
  static const backgroundInactive = Color(0xffE6E6E6);
  static const transactionIn = Color(0xff53905F);
  static const transactionOut = Color(0xffE58E74);

  // Images
  static const String spashImage = 'assets/images/splash/splash.png';
  static const String spashLogo = 'assets/images/splash/Vectortruck.png';
  static const String appLogo = 'assets/images/mbkc_logo.jpg';
  static const String welcomeImage = 'assets/images/image_welcome.png';
  static const String defaultAvatar = 'assets/images/avatar_default.png';
  static const String errorLogo = 'assets/images/error.png';

  // Sizes
  static const double defaultPadding = 20.0;
  static const double defaultFontSize = 25.0;
  static const double defaultBorder = 10.0;
  static const double defaultMargin = 10.0;

  // Title
  static const String appTitle = 'MoveMate';

  // Icons
  static const Icon iconSuccess = Icon(
    Icons.check_circle,
    size: defaultFontSize - 10.0,
  );

  //font
  static const TextStyle appFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: defaultFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    letterSpacing: -0.2,
  );
  static const TextStyle titleFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: defaultPadding,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    letterSpacing: -0.2,
  );
  static const TextStyle descriptionFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: defaultMargin,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    letterSpacing: -0.2,
  );

  // Font sizes based on the text elements in the image
  static const double filterTitleFontSize = 18.0;
  static const double sectionTitleFontSize = 16.0;
  static const double labelFontSize = 14.0;
  static const double inputFontSize = 13.0;
  static const double buttonFontSize = 15.0;
  static const double priceDetailTitleFontSize = 16.0;
  static const double priceItemFontSize = 14.0;
  static const double totalPriceFontSize = 20.0;
  static const double disclaimerFontSize = 12.0;

  // Font family settings (assuming Poppins is used)
  static const TextStyle filterTitleFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: filterTitleFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle sectionTitleFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: sectionTitleFontSize,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle labelFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: labelFontSize,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const TextStyle inputFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: inputFontSize,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const TextStyle buttonFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: buttonFontSize,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle priceDetailTitleFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: priceDetailTitleFontSize,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle priceItemFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: priceItemFontSize,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const TextStyle totalPriceFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: totalPriceFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  static const TextStyle disclaimerFont = TextStyle(
    fontFamily: 'Poppins',
    fontSize: disclaimerFontSize,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  // Others
  static const int defaultMaxline = 2;
}
