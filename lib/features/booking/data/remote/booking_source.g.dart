// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _BookingSource implements BookingSource {
  _BookingSource(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://dummyjson.com/c/83a0-09f3-48bb-9368';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<BookingResponse>> getAllBooking(
      String contentType) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': contentType};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<BookingResponse>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      contentType: contentType,
    )
            .compose(
              _dio.options,
              '/booking_source',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final _value = BookingResponse.fromMap(_result.data!);
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingSourceHash() => r'9b35d19e23b2637e0a9a97f757c03e31b8b5436d';

/// See also [bookingSource].
@ProviderFor(bookingSource)
final bookingSourceProvider = AutoDisposeProvider<BookingSource>.internal(
  bookingSource,
  name: r'bookingSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookingSourceRef = AutoDisposeProviderRef<BookingSource>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
