import 'package:driver_app/object/order.dart';
import 'package:driver_app/object/parcel.dart';
import 'package:driver_app/share_widget/not_found.dart';
import 'package:driver_app/share_widget/progress_bar.dart';
import 'package:driver_app/share_widget/qr_scanner.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'delivery_reference_list_view.dart';

class DeliveryOrder extends StatefulWidget {
  final int? taskId;

  const DeliveryOrder({Key? key, required this.taskId}) : super(key: key);

  @override
  _DeliveryOrderState createState() => _DeliveryOrderState();
}

class _DeliveryOrderState extends State<DeliveryOrder> {
  bool isLoading = true;
  int pickUpParcel = 0;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<DeliveryReference> list = [];
  List<Parcel> parcels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeliveryTask();
    getDeliveryParcel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openQrScanner();
          },
          child: const Icon(Icons.qr_code),
        ),
        bottomNavigationBar: BottomAppBar(
          child: bottomNavigationLayout(),
        ),
        appBar: AppBar(
          title: Text(
            '${Utils.getText(context, 'task')} ${Utils.idPrefix(widget.taskId.toString())}',
            style: GoogleFonts.acme(
              textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: Colors.teal),
            ),
          ),
          actions: [IconButton(onPressed: () => _onRefresh(), icon: const Icon(Icons.refresh))],
        ),
        body: isLoading
            ? const CustomProgressBar()
            : list.isNotEmpty
                ? SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: const WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text(Utils.getText(context, 'pull_up_load'));
                        } else if (mode == LoadStatus.loading) {
                          body = const CustomProgressBar();
                        } else if (mode == LoadStatus.failed) {
                          body = Text(Utils.getText(context, 'load_failed'));
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text(Utils.getText(context, 'release_to_load_more'));
                        } else {
                          body = Text(Utils.getText(context, 'no_more_data'));
                        }
                        return SizedBox(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: customListView())
                : notFound());
  }

  _onRefresh() async {
    if (mounted) {
      setState(() {
        list.clear();
        isLoading = true;
        getDeliveryTask();
        getDeliveryParcel();
        _refreshController.resetNoData();
      });
    }
  }

  Widget bottomNavigationLayout() {
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    pickUpParcel.toString(),
                    style: const TextStyle(fontSize: 20, color: Colors.teal),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    Utils.getText(context, 'scanned_parcel'),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    parcels.length.toString(),
                    style: const TextStyle(fontSize: 20, color: Colors.teal),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    Utils.getText(context, 'total_parcel'),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customListView() {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return DeliveryOrderListView(
            order: list[index],
            onClick: () => null,
          );
        });
  }

  getDeliveryTask() async {
    Map data = await Domain().deliveryTaskOrder(widget.taskId);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      if (data['status'] == '1') {
        List responseJson = data['delivery_task_order'];
        list.addAll(responseJson.map((jsonObject) => DeliveryReference.fromJson(jsonObject)).toList());
      } else {
        _refreshController.loadNoData();
      }
      _refreshController.refreshCompleted();
      isLoading = false;
    });
  }

  getDeliveryParcel() async {
    parcels.clear();
    pickUpParcel = 0;
    Map data = await Domain().deliveryParcel(widget.taskId);
    await Future.delayed(const Duration(milliseconds: 500));
    if (data['status'] == '1') {
      List responseJson = data['parcel'];
      parcels.addAll(responseJson.map((jsonObject) => Parcel.fromJson(jsonObject)).toList());
      //check scanned parcel
      for (int i = 0; i < parcels.length; i++) {
        if (parcels[i].status! >= 3) pickUpParcel++;
      }
    }
    setState(() {});
  }

  openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScanner(
          action: 3,
          taskId: widget.taskId.toString(),
        ),
      ),
    );
  }

  Widget notFound() {
    return NotFound(
        title: '${Utils.getText(context, 'no_task_found')}',
        description: '${Utils.getText(context, 'no_task_found_description')}',
        showButton: true,
        refresh: () {
          setState(() {
            _onRefresh();
          });
        },
        button: '${Utils.getText(context, 'refresh')}',
        drawable: 'drawable/no_results.png');
  }
}
