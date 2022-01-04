class Merchant {
  String? company, address, postcode, phone;

  int? merchantId;

  Merchant({this.merchantId, this.company, this.address, this.postcode, this.phone});

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      merchantId: json['merchant_id'],
      company: json['company'] as String,
      address: json['address'] as String,
      postcode: json['postcode'] as String,
      phone: json['phone'] as String,
    );
  }
}
