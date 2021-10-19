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
  final double? heightFactor;
  final double? widthFactor;
  final EdgeInsets? insetPadding;
  final bool fill;
  const OverlayPopup({Key? key, required this.contents,
    this.heightFactor,
    this.widthFactor,
    this.fill = false,
    this.insetPadding}) : super(key: key);

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
            widthFactor: widget.fill ? null : (widget.widthFactor ?? 0.8),
            heightFactor: widget.fill ? null : (widget.heightFactor ?? 1),
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
                    padding: widget.insetPadding,
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
            ]
            )
        )
    );
  }
}
