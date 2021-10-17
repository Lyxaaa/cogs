import 'package:flutter/material.dart';
import 'dart:developer' as dev;

// onPressed: () {
//    showDialog(
//    context: context,
//    builder: (BuildContext context) => createDialog(context),
//  );
// },
class OverlayPopup extends StatefulWidget {
  final Widget contents;
  const OverlayPopup({Key? key, required this.contents}) : super(key: key);

  @override
  _OverlayPopupState createState() => _OverlayPopupState();
}

class _OverlayPopupState extends State<OverlayPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.fromLTRB(0, 10, 0, 20),
        child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 1,
            child: Stack(children: <Widget>[
              Column(children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.surface,
                    ),
                    // padding: EdgeInsets.fromLTRB(20,20,20,20),
                    child: widget.contents,
                  ),
                ),
                /*Container(height: 48)*/
              ]),
              /*Positioned.fill(
                  bottom: 0, // Half of button size, approximately?
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          onPressed: () {},
                          // TODO: Fire off session start from here
                          child: Text("Start".toUpperCase()),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder()),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(40)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber))))) */
            ])));
  }
}
