class Driver {
  String? driverId, name, email, phone, address, postcode, plateNo;

  int? status;

  Driver({this.driverId, this.name, this.email, this.phone, this.address, this.postcode, this.plateNo});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driver_id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'],
      address: json['address'],
      postcode: json['postcode'],
      plateNo: json['plate_no'],
    );
  }

  Map<String, dynamic> toJson() => {'driver_id': driverId, 'name': name, 'email': email};
}
