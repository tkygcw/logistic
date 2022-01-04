class DeliveryReference {
  String? name, address, postcode, phone, remark, bidNo, pod, podTime;

  int? deliveryReferenceId, referenceId, status;

  DeliveryReference(
      {this.deliveryReferenceId,
      this.referenceId,
      this.name,
      this.address,
      this.postcode,
      this.phone,
      this.status,
      this.remark,
      this.bidNo,
      this.pod,
      this.podTime});

  factory DeliveryReference.fromJson(Map<String, dynamic> json) {
    return DeliveryReference(
      deliveryReferenceId: json['delivery_reference_id'],
      referenceId: json['referenceId'],
      name: json['receiver_name'] as String,
      address: json['receiver_address'] as String,
      postcode: json['receiver_postcode'] as String,
      phone: json['receiver_phone'] as String,
      remark: json['remark'] ?? '',
      bidNo: json['bid_no'] ?? '',
      pod: json['proof_of_delivery'] ?? '',
      podTime: json['pod_time'] ?? '',
      status: json['status'],
    );
  }

  static String orderIdPrefix(orderID) {
    String prefix = '';
    for (int i = orderID.length; i < 5; i++) {
      prefix = prefix + "0";
    }
    return '#' + prefix + orderID;
  }
}
