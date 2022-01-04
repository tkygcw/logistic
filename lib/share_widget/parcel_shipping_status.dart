import 'package:driver_app/object/parcel.dart';
import 'package:driver_app/object/shipping.dart';
import 'package:driver_app/share_widget/progress_bar.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ParcelShippingStatus extends StatefulWidget {
  final Parcel parcel;

  const ParcelShippingStatus({Key? key, required this.parcel}) : super(key: key);

  @override
  _ParcelShippingStatusState createState() => _ParcelShippingStatusState();
}

class _ParcelShippingStatusState extends State<ParcelShippingStatus> {
  int currentStep = 0;
  bool isLoad = false;
  List<Step> steps = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('haha');
    getShippingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('${Utils.getText(context, 'parcel_info')} '),
        actions: <Widget>[
          TextButton(
            child: Text(Utils.getText(context, 'close')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: SizedBox(
          height: 400,
          width: 500,
          child: isLoad
              ? Stepper(
                  margin: const EdgeInsets.all(0),
                  currentStep: currentStep,
                  steps: steps,
                  type: StepperType.vertical,
                  onStepTapped: (step) {
                    setState(() {
                      currentStep = step;
                    });
                  },
                  onStepContinue: () {
                    setState(() {
                      if (currentStep < steps.length - 1) {
                        currentStep = currentStep + 1;
                      } else {
                        currentStep = 0;
                      }
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (currentStep > 0) {
                        currentStep = currentStep - 1;
                      } else {
                        currentStep = 0;
                      }
                    });
                  },
                  controlsBuilder: (BuildContext context, ControlsDetails controls) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          '',
                          textAlign: TextAlign.left,
                        )
                      ],
                    );
                  },
                )
              : const CustomProgressBar(),
        ));
  }

  getShippingStatus() async {
    List<Shipping> list = [];
    Map data = await Domain().shippingStatus(widget.parcel.parcelId);
    await Future.delayed(const Duration(milliseconds: 500));

    //preset step
    for (int i = 0; i < 5; i++) {
      steps.add(Step(title: Text(Utils.getText(context, Parcel.getStatus(i))), content: const Text(''), state: StepState.disabled));
    }

    if (data['status'] == '1') {
      List parcel = data['parcel_shipping_status'];
      list.addAll(parcel.map((jsonObject) => Shipping.fromJson(jsonObject)).toList());
      for (int j = 0; j < list.length; j++) {
        currentStep = list.length - 1;
        steps[j] = (Step(
            title: Text(Utils.getText(context, Parcel.getStatus(j))),
            content: Text(
              '${Utils.getText(context, list[j].driver.toString() == '' ? 'admin' : 'driver')}: ${list[j].driver.toString() == '' ? list[j].admin.toString() : list[j].driver.toString()}',
              style: const TextStyle(fontSize: 12),
            ),
            subtitle: Text(list[j].date.toString()),
            isActive: true,
            state: j == list.length - 1 ? StepState.complete : StepState.indexed));
      }
    }
    setState(() {
      isLoad = true;
    });
  }
}
