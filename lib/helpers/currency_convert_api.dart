import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modals/currency_convert.dart';

class CurrencyConvertAPI {
  CurrencyConvertAPI._();

  static final CurrencyConvertAPI weatherAPI = CurrencyConvertAPI._();

  Future<CurrencyConvert?> currencyConvertorAPI(
      {required String from, required String to, required int amt}) async {
    String url =
        "https://api.exchangerate.host/convert?from=$from&to=$to&amount=$amt";

    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      Map<String, dynamic> decodedData = jsonDecode(res.body);

      CurrencyConvert currencyConvert =
          CurrencyConvert.fromJSON(json: decodedData);
      return currencyConvert;
    }
    return null;
  }
}
