class Shipping {
  String? driver, admin, date;
  int? shippingId, status;

  Shipping({this.driver, this.admin, this.shippingId, this.status, this.date});

  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
        shippingId: json['shipping_id'],
        driver: json['driver'] ?? '',
        admin: json['admin'] ?? '',
        status: json['status'],
        date: json['created_at'] ?? '');
  }

  static getStatus(status) {
    switch (status) {
      case 0:
        return 'assigning';
      case 1:
        return 'pick_up_by_driver';
      case 2:
        return 'in_warehouse';
      case 3:
        return 'out_of_delivery';
      case 4:
        return 'delivered';
    }
  }

//  Map<String, dynamic> toJson() => {'driver_id': driverId, 'name': name, 'email': email};
}
