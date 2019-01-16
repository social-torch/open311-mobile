import 'package:flutter/material.dart';

Widget _getDot(stage, idx) {
  var clr = Colors.black;
  var thk = 3.0;
  if ( idx == stage ) {
    clr = Colors.white;
  }
  else if ( idx > stage ) {
    clr = Colors.white;
    thk = 1.0;
  }
  return Container(
    width: 24.0,
    height: 24.0,
    decoration:
      BoxDecoration(
        color: clr,
        shape: BoxShape.circle,                                                                   border: new Border.all(                                                                     color: Colors.black,                                                                      width: thk,
          style: BorderStyle.solid,
        ),
      ),
    );
}

Row _getDots(stage, numStages, child) {
  List<Widget> rowChildren = new List();
  for(var i=0; i<numStages; i++) {
    rowChildren.add(_getDot(stage, i));
    if (i < (numStages-1)) {
      rowChildren.add(Container(                                                                      width: 24.0,                                                                              height: 2.0,
            decoration:  BoxDecoration(
              color: Colors.black,
          ),
        ),
      );
    }
  }
  rowChildren.add(
    Container(                                                                                  child: child
    ),
  );
  return Row(
    children: rowChildren,
  );
}

class ProgressDots extends Container {
  ProgressDots({
    @required int stage,
    @required int numStages,
    Key key,
    AlignmentGeometry alignment,
    EdgeInsetsGeometry padding,
    Color color,
    Decoration decoration,
    Decoration foregroundDecoration,
    double width,
    double height,
    BoxConstraints constraints,
    EdgeInsetsGeometry margin,
    Matrix4 transform,
    Widget child,
  }) : super(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      child:  _getDots(stage, numStages, child),
      );
}


class ColorSliverButton extends FlatButton {
  ColorSliverButton({
    Key key,
    @required VoidCallback onPressed,
    ValueChanged<bool> onHighlightChanged,
    ButtonTextTheme textTheme,
    Color textColor,
    Color disabledTextColor,
    Color color,
    Color disabledColor,
    Color highlightColor,
    Color splashColor,
    Brightness colorBrightness,
    EdgeInsetsGeometry padding,
    ShapeBorder shape,
    Clip clipBehavior = Clip.none,
    MaterialTapTargetSize materialTapTargetSize,
    @required Widget child,
  }) : super(
         key: key,
         onPressed: onPressed,
         onHighlightChanged: onHighlightChanged,
         textTheme: textTheme,
         textColor: textColor,
         disabledTextColor: disabledTextColor,
         color: Colors.grey[200],
         disabledColor: disabledColor,
         highlightColor: highlightColor,
         splashColor: splashColor,
         colorBrightness: colorBrightness,
         padding: EdgeInsets.only(left: 0.0),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
         clipBehavior: clipBehavior,
         materialTapTargetSize: materialTapTargetSize,
         child:  Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Container(
               width: 10.0,
               height: 36.0,
               decoration:
                 BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(9.0)),
                   color: Colors.red[400],
                 ),
             ),
             Container(
               width: 10.0,
               height: 36.0,
             ),
             Container(
               child: child
             ),
           ]
         ),
      );
}

