enum StatusCodeType {
  exception(500),
  conflict(409),
  badrequest(400),
  notfound(404),
  unauthentication(401),
  forbidden(403);

  final int type;
  const StatusCodeType(this.type);
}

extension ConvertStatusCode on int {
  StatusCodeType toStatusCodeTypeEnum() {
    switch (this) {
      case 500:
        return StatusCodeType.exception;
      case 409:
        return StatusCodeType.conflict;
      case 400:
        return StatusCodeType.badrequest;
      case 404:
        return StatusCodeType.notfound;
      case 401:
        return StatusCodeType.unauthentication;
      case 403:
        return StatusCodeType.forbidden;
      default:
        return StatusCodeType.exception;
    }
  }
}
