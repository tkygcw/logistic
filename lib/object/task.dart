import 'package:driver_app/object/merchant.dart';
import 'package:intl/intl.dart';

class Task {
  String? createdAt;
  Merchant? merchant;
  int? status, pickupId, deliveryId, taskId, numOrder;

  Task({this.taskId, this.createdAt, this.status, this.pickupId, this.deliveryId, this.merchant, this.numOrder});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['driver_task_id'],
      createdAt: json['created_at'] as String,
      status: json['status'],
      pickupId: json['pickup_id'],
      deliveryId: json['delivery_id'],
      numOrder: json['num_order'],
      merchant: Merchant(company: json['company'], address: json['address'], postcode: json['postcode'], phone: json['phone']),
    );
  }

  static formatDate(date) {
    try {
      final dateFormat = DateFormat("dd-MMM-yyyy");
      DateTime todayDate = DateTime.parse(date);
      return dateFormat.format(todayDate).toString();
    } catch (e) {
      return '';
    }
  }

}
