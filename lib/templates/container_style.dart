import 'package:flutter/material.dart';

class CardContainer extends StatefulWidget {
  final Widget child;
  final bool expand;

  const CardContainer({required this.child, this.expand=false});

  @override
  _CardContainerState createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.expand) {
      return Row(
        children: [
          Expanded(
              child: createCard(context, widget.child)),
        ],
      );
    }
    return createCard(context, widget.child);
  }
}

Container createCard(context, child) {
  return Container(
    margin: const EdgeInsets.all(20),
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
    child: child,
  );
}