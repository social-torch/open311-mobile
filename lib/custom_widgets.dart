import 'package:flutter/material.dart';

class ProgressDots extends Container {
  ProgressDots({
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
      //child: child,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration:
              BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
          ),
          Container(
            width: 24.0,
            height: 2.0,
            decoration:
              BoxDecoration(
                color: Colors.black,
              ),
          ),
          Container(
            width: 24.0,
            height: 24.0,
            decoration:
              BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
          ),
          Container(
            width: 24.0,
            height: 2.0,
            decoration:
              BoxDecoration(
                color: Colors.black,
              ),
          ),
          Container(
            width: 24.0,
            height: 24.0,
            decoration:
              BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
          ),
          Container(
            width: 24.0,
            height: 2.0,
            decoration:
              BoxDecoration(
                color: Colors.black,
              ),
          ),
          Container(
            width: 24.0,
            height: 24.0,
            decoration:
              BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.black,
                  width: 3.0,
                  style: BorderStyle.solid
                ),
              ),
          ),
          Container(                                                                                  child: child
          ),
        ]
      ),
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

