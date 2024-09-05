abstract class StringValidator {
  bool isValid(String value);
}

// Handle regex
class RegexValidator implements StringValidator {
  RegexValidator({required this.regexSource});
  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      // https://regex101.com/
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class EmailRegexValidator extends RegexValidator {
  EmailRegexValidator()
      : super(regexSource: '^[a-zA-Z0-9._%+-]+@gmail\\.com\$');
}

// Handle empty
class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength;
  }
}

class MaxLengthStringValidator extends StringValidator {
  MaxLengthStringValidator(this.maxLength);
  final int maxLength;

  @override
  bool isValid(String value) {
    return value.length <= maxLength;
  }
}

class BetweenLengthStringValidator extends StringValidator {
  BetweenLengthStringValidator(this.minLength, this.maxLength);
  final int minLength;
  final int maxLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength && value.length <= maxLength;
  }
}
