import 'package:driver_app/share_widget/qr_scanner.dart';
import 'package:driver_app/object/task.dart';
import 'package:driver_app/share_widget/not_found.dart';
import 'package:driver_app/share_widget/progress_bar.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'delivery_list_view.dart';

class DeliveryList extends StatefulWidget {
  final int status;

  const DeliveryList({Key? key, required this.status}) : super(key: key);

  @override
  _DeliveryListState createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  bool itemFinish = false;
  bool isLoading = true;
  int page = 1;
  int itemPerPage = 10;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<Task> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeliveryTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onLoading: _onLoading,
                    child: customListView())
                : notFound());
  }

  _onRefresh() async {
    if (mounted) {
      setState(() {
        page = 1;
        list.clear();
        isLoading = true;
        itemFinish = false;
        getDeliveryTask();
        _refreshController.resetNoData();
      });
    }
  }

  _onLoading() async {
    if (mounted && !itemFinish) {
      setState(() {
        page++;
        getDeliveryTask();
      });
    }
    _refreshController.loadComplete();
  }

  Widget customListView() {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return DeliveryListView(
            task: list[index],
            onClick: () => null,
          );
        });
  }

  openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QrScanner(action: 1),
      ),
    );
  }

  getDeliveryTask() async {
    Map data = await Domain().deliveryTask(page, itemPerPage, status: widget.status.toString());
    print(data);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        if (data['status'] == '1') {
          List responseJson = data['delivery_task'];
          list.addAll(responseJson.map((jsonObject) => Task.fromJson(jsonObject)).toList());
        } else {
          itemFinish = true;
          _refreshController.loadNoData();
        }
        _refreshController.refreshCompleted();
        isLoading = false;
      });
    }
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
