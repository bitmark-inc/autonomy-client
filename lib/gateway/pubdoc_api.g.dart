// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pubdoc_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _PubdocAPI implements PubdocAPI {
  _PubdocAPI(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://raw.githubusercontent.com/thuyenBitmark/temp-release-notes/master';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<String> getVersionContent() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/versions.json',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
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
}
