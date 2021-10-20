import 'package:flutter/material.dart';

class CardContainer extends StatefulWidget {
  final Widget child;

  const CardContainer({required this.child});

  @override
  _CardContainerState createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: ShapeDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        shadows: const [
          BoxShadow(color: Colors.black, offset: Offset(2, 2))
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: widget.child,
    );
  }
}