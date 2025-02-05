import 'dart:core';

class ApiResult {
  final String title;
  final String priceText;
  final String link;
  final double price;

  ApiResult({
    required this.title,
    required this.priceText,
    required this.link,
    required this.price,
  });

  factory ApiResult.fromJson(Map<String, dynamic> json) {
    String priceString = json["price"] ?? "0";
    double parsedPrice = _parsePrice(priceString);

    return ApiResult(
      title: json["title"] ?? "Bilinmeyen Ürün",
      priceText: priceString,
      price: parsedPrice,
      link: json["link"] ?? "#",
    );
  }

  // Fiyatı temizleyerek double'a çeviren fonksiyon
  static double _parsePrice(String price) {
    price = price.replaceAll(RegExp(r'[^\d.]'), ''); // Sadece sayıları al
    return double.tryParse(price) ?? 0.0; // Sayıya çevir, hata olursa 0.0 ata
  }
}
