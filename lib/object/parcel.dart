class Parcel {
  String? name, barcode;
  int? parcelId, status;

  Parcel({this.name, this.parcelId, this.barcode, this.status});

  factory Parcel.fromJson(Map<String, dynamic> json) {
    return Parcel(parcelId: json['parcel_id'], barcode: json['barcode'], name: json['name'] ?? '', status: json['status']);
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
