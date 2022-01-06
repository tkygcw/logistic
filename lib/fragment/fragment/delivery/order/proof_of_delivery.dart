import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:driver_app/object/order.dart';
import 'package:driver_app/share_widget/progress_bar.dart';
import 'package:driver_app/share_widget/zoom_in.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ProofOfDelivery extends StatefulWidget {
  final DeliveryReference deliveryReference;
  final Function() refresh;

  const ProofOfDelivery({Key? key, required this.deliveryReference, required this.refresh}) : super(key: key);

  @override
  _ProofOfDeliveryState createState() => _ProofOfDeliveryState();
}

class _ProofOfDeliveryState extends State<ProofOfDelivery> {
  File? _image;
  late ImageProvider provider;
  late StreamController imageStateStream;

  late String merchantId;
  String imageCode = '-1';
  late String imageName;
  String extension = '';
  final picker = ImagePicker();

  // ignore: prefer_typing_uninitialized_variables
  var compressedFileSource;

  var key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  preData() async {
    // ignore: prefer_if_null_operators
    imageName = (widget.deliveryReference.pod != null ? widget.deliveryReference.pod : 'no-image-found.png')!;
  }

  @override
  Widget build(BuildContext context) {
    imageStateStream = StreamController();
    imageStateStream.add('display');
    preData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          child: InkWell(
            child: _imageViewWidget(),
            onTap: () {
              if (imageName == 'no-image-found.png' || imageName == 'test.png' || imageName == '') {
                _showSelectionDialog(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ZoomIn(label: widget.deliveryReference.pod.toString(), image: '${Domain.proofImgPath}${widget.deliveryReference.pod}')),
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        getText(),
        const SizedBox(
          height: 5,
        ),
        Visibility(
          visible: imageCode != '-1',
          child: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.green,
              ),
              onPressed: () => uploadImage(context),
              child: Text(
                '${Utils.getText(context, 'upload_photo')}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.deliveryReference.pod != '',
          child: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.red,
              ),
              onPressed: () => deleteProofImage(context),
              child: Text(
                '${Utils.getText(context, 'remove_photo')}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageViewWidget() {
    return StreamBuilder(
        stream: imageStateStream.stream,
        builder: (context, object) {
          if (object.data == 'display') {
            // ignore: unnecessary_null_comparison
            if (_image == null) {
              return Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('${Domain.proofImgPath}${imageName != '' ? widget.deliveryReference.pod : 'no-image-found.png'}'),
                    placeholder: NetworkImage('${Domain.proofImgPath}no-image-found.png'),
//                    imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
//                      return Container(
//                          width: 100,
//                          height: 100,
//                          color: Colors.black12,
//                          alignment: Alignment.center,
//                          child: Icon(
//                            Icons.error_outline,
//                            color: Colors.redAccent,
//                            size: 40,
//                          ));
//                    },
                  ));
            } else {
              return Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: Image(
                  image: provider,
                  fit: BoxFit.fill,
                ),
              );
            }
          }
          return Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: const Center(
              child: CustomProgressBar(),
            ),
          );
        });
  }

  //delete gallery from cloud
  uploadImage(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: Text("${Utils.getText(context, 'upload_photo_request')}"),
          content: RichText(
            maxLines: 10,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${Utils.getText(context, 'upload_photo_description_1')} ',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${Utils.getText(context, 'cancel')}'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                '${Utils.getText(context, 'confirm')}',
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                /*
              * proceed image upload
              * */
                Map data = await Domain().updateProofOfDelivery(widget.deliveryReference.deliveryReferenceId, imageCode);
                if (data['status'] == '1') {
                  _image = null;
                  imageCode = '-1';
                  widget.refresh();
                  Navigator.of(context).pop();
                  /*
                  * after delete image open back the image selection dialog
                  * */
                } else {
                  showSnackBar('something_went_wrong');
                }
              },
            ),
          ],
        );
      },
    );
  }

  //delete gallery from cloud
  deleteProofImage(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: Text("${Utils.getText(context, 'delete_request')}"),
          content: Text("${Utils.getText(context, 'delete_product_image')}"),
          actions: <Widget>[
            TextButton(
              child: Text('${Utils.getText(context, 'cancel')}'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                '${Utils.getText(context, 'confirm')}',
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                /*
              * proceed item delete from cloud
              * */
                Map data = await Domain().deleteProofOfDelivery(widget.deliveryReference.deliveryReferenceId, imageName);
                //delete success
                if (data['status'] == '1') {
                  await Future.delayed(const Duration(milliseconds: 250));
                  _image = null;
                  imageName = '';
                  widget.refresh();
                  Navigator.of(context).pop();
                } else {
                  Utils.showSnackBar(context, 'something_went_wrong');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("${Utils.getText(context, 'take_photo_from_where')}"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      label: Text('${Utils.getText(context, 'gallery')}', style: const TextStyle(color: Colors.white)),
                      icon: const Icon(
                        Icons.perm_media,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getImage(false);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                      ),
                      label: Text(
                        '${Utils.getText(context, 'camera')}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getImage(true);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ));
        });
  }

  Widget getText() {
    if (widget.deliveryReference.pod == '') {
      return Text(Utils.getText(context, 'take_photo'), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold));
    } else {
      return RichText(
        textAlign: TextAlign.center,
        maxLines: 10,
        text: TextSpan(
          children: [
            TextSpan(
              text: '${Utils.getText(context, 'taken_on')}: ',
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            TextSpan(
              text: widget.deliveryReference.podTime,
              style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    //'${Utils.getText(context, 'taken_on')} ${widget.deliveryReference.proofPhotoDate}';
  }

  showSnackBar(message) {
    Utils.showSnackBar(context, message);
  }

  /*
  * compress purpose
  * */
  Future getImage(isCamera) async {
    final pickedFile = await picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    _image = File(pickedFile!.path);

    compressFileMethod();
  }

  void compressFileMethod() async {
    imageStateStream.add('processing-image');
    await Future.delayed(const Duration(milliseconds: 300));

    Uint8List bytes = _image!.readAsBytesSync();
    final ByteData data = ByteData.view(bytes.buffer);

    final dir = await path_provider.getTemporaryDirectory();

    File file = createFile("${dir.absolute.path}/test.png");
    file.writeAsBytesSync(data.buffer.asUint8List());

    compressedFileSource = await compressFile(file);
    ImageProvider provider = MemoryImage(compressedFileSource);
    /*
    * image file
    * */
    this.provider = provider;
    imageCode = base64.encode(compressedFileSource);
    imageName = file.path.split('/').last;
    extension = imageName.split('.').last;
    setState(() {
      imageStateStream.add('display');
    });
  }

  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }

  Future<Uint8List?> compressFile(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: countQuality(file.lengthSync()),
    );
    return result;
  }

  countQuality(int quality) {
    if (quality <= 100) {
      return 60;
    } else if (quality > 100 && quality < 500) {
      return 25;
    } else {
      return 20;
    }
  }
}
