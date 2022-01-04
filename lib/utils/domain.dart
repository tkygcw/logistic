import 'dart:convert';
import 'package:driver_app/object/driver.dart';
import 'package:driver_app/utils/share_preference.dart';
import 'package:http/http.dart' as http;

class Domain {
//  static var domain = 'https://www.logistics.lkmng.com/';
  static var domain = 'https://www.mobileapi.avis-vision.com/';

  static Uri registration = Uri.parse(domain + 'mobile_api/registration/index.php');
  static Uri task = Uri.parse(domain + 'mobile_api/task/index.php');
  static Uri proofImgPath = Uri.parse(domain + 'mobile_api/task/image/');

  /*
  * login
  * */
  login(email, password) async {
    var response = await http.post(Domain.registration, body: {
      'login': '1',
      'password': password,
      'email': email,
    });
    return jsonDecode(response.body);
  }

  /*
  * register
  * */
  register(Driver driver, password) async {
    var response = await http.post(Domain.registration, body: {
      'create': '1',
      'plate_no': driver.plateNo,
      'postcode': driver.postcode,
      'address': driver.address,
      'phone': driver.phone,
      'email': driver.email,
      'name': driver.name,
      'password': password,
    });
    return jsonDecode(response.body);
  }

  /*
  * update password
  * */
  updatePassword(String currentPassword, String newPassword) async {
    var response = await http.post(Domain.registration, body: {
      'update': '1',
      'current_password': currentPassword,
      'new_password': newPassword,
      'driver_id': Driver.fromJson(await SharePreferences().read("driver")).driverId,
    });
    return jsonDecode(response.body);
  }

  /*
  * driver profile
  * */
  driverProfile() async {
    var response = await http.post(Domain.registration, body: {
      'driver_profile': '1',
      'driver_id': Driver.fromJson(await SharePreferences().read("driver")).driverId,
    });
    return jsonDecode(response.body);
  }

  /*
  * forgot password send pac
  * */
  sendPac(email, pac) async {
    var response = await http.post(Domain.registration, body: {
      'forgot_password': '1',
      'email': email,
      'pac': pac,
    });
    return jsonDecode(response.body);
  }

  /*
  * forgot password update password
  * */
  setNewPassword(newPassword, email) async {
    var response = await http.post(Domain.registration, body: {
      'forgot_password': '1',
      'new_password': newPassword,
      'email': email,
    });
    return jsonDecode(response.body);
  }

  launchCheck() async {
    //get version
    var response = await http
        .post(Domain.registration, body: {'launch_check': '1', 'driver_id': Driver.fromJson(await SharePreferences().read("driver")).driverId});

    return jsonDecode(response.body);
  }

  /*
  * pick up task
  * */
  pickUpTask(page, itemPerPage, {status}) async {
    var response = await http.post(Domain.task, body: {
      'pick_up': '1',
      'driver_id': Driver.fromJson(await SharePreferences().read("driver")).driverId,
      'status': status ?? '',
      'page': page.toString(),
      'itemPerPage': itemPerPage.toString(),
    });
    return jsonDecode(response.body);
  }

  /*
  * pick up parcel
  * */
  pickUpParcel(driverTaskId) async {
    var response = await http.post(Domain.task, body: {
      'pick_up_parcel': '1',
      'driver_task_id': driverTaskId.toString(),
    });
    return jsonDecode(response.body);
  }

  /*
  * delivery task
  * */
  deliveryTask(page, itemPerPage, {status}) async {
    var response = await http.post(Domain.task, body: {
      'delivery': '1',
      'driver_id': Driver.fromJson(await SharePreferences().read("driver")).driverId,
      'status': status ?? '',
      'page': page.toString(),
      'itemPerPage': itemPerPage.toString(),
    });
    return jsonDecode(response.body);
  }

  /*
  * delivery task's order
  * */
  deliveryTaskOrder(driverTaskId) async {
    var response = await http.post(Domain.task, body: {
      'delivery': '1',
      'driver_task_id': driverTaskId.toString(),
    });
    return jsonDecode(response.body);
  }

  /*
  * delivery parcel
  * */
  deliveryParcel(driverTaskId) async {
    var response = await http.post(Domain.task, body: {
      'delivery_parcel': '1',
      'driver_task_id': driverTaskId.toString(),
    });
    return jsonDecode(response.body);
  }

  /*
  * reference detail
  * */
  orderDetail(referenceId) async {
    var response = await http.post(Domain.task, body: {
      'delivery_reference_detail': '1',
      'delivery_reference_id': referenceId.toString(),
    });
    return jsonDecode(response.body);
  }

  /*
  * parcel shipping status detail
  * */
  shippingStatus(parcelId) async {
    var response = await http.post(Domain.task, body: {
      'parcel_shipping': '1',
      'parcel_id': parcelId.toString(),
    });
    print(response.body);
    return jsonDecode(response.body);
  }

  /*
  * update pick up order status
  * */
  updateProfile(Driver driver) async {
    var response = await http.post(Domain.registration, body: {
      'update': '1',
      'plate_no': driver.plateNo,
      'address': driver.address,
      'postcode': driver.postcode,
      'driver_id': Driver.fromJson(await SharePreferences().read("driver")).driverId,
    });
    return jsonDecode(response.body);
  }

  /*
  * update pick up order status
  * */
  updatePickUpTaskStatus(driverTaskId) async {
    var response = await http.post(Domain.task, body: {
      'pick_up_status': '1',
      'driver_task_id': driverTaskId.toString(),
    });
    return jsonDecode(response.body);
  }

  /*
  * update delivery order status
  * */
  updateDeliveryOrderStatus(driverTaskId) async {
    var response = await http.post(Domain.task, body: {
      'delivery_order_status': '1',
      'driver_task_id': driverTaskId.toString(),
    });
    return jsonDecode(response.body);
  }

  /*
  * update reference status
  * */
  updateReferenceStatus(referenceId, status) async {
    var response = await http.post(Domain.task, body: {
      'update_reference': '1',
      'delivery_reference_id': referenceId.toString(),
      'status': status,
    });
    return jsonDecode(response.body);
  }

  /*
  * update task
  * */
  scanParcel(action, barcode, status, {referenceId, taskId}) async {
    var response = await http.post(Domain.task, body: {
      'scan_parcel': action,
      'barcode': barcode,
      'status': status.toString(),
      'reference_id': referenceId,
      'task_id': taskId,
      'driver_id': Driver.fromJson(await SharePreferences().read("driver")).driverId,
    });
    return jsonDecode(response.body);
  }

  /*
  * upload proof of delivery
  * */
  updateProofOfDelivery(deliveryReferenceId, imageCode) async {
    var response = await http
        .post(Domain.task, body: {'upload_proof_photo': '1', 'image_code': imageCode, 'delivery_reference_id': deliveryReferenceId.toString()});
    return jsonDecode(response.body);
  }

  /*
  * delete proof of delivery
  * */
  deleteProofOfDelivery(deliveryReferenceId, imageName) async {
    print(deliveryReferenceId);
    var response = await http
        .post(Domain.task, body: {'delete_image': '1', 'image_name': imageName, 'delivery_reference_id': deliveryReferenceId.toString()});
    return jsonDecode(response.body);
  }
}
