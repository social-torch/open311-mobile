import 'package:flutter/material.dart';
import 'data.dart';
import 'custom_colors.dart';

Widget _getDot(diam, stage, idx) {
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
    width: diam,
    height: diam,
    decoration:
      BoxDecoration(
        color: clr,
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.black,
          width: thk,
          style: BorderStyle.solid,
        ),
      ),
    );
}

Row _getDots(stage, numStages, child) {
  List<Widget> rowChildren = new List();

  //Each dot and line (o--) should ideally take up an 1/8 of the width, cause I said so...
  //And each dot should be 3/10 of the dot and line (o--) combo, again cause I said so...
  var dotAndLineCombo = DeviceData().DeviceWidth * 0.125;
  var dotWidth = dotAndLineCombo * 0.3;
  var lineLength = dotAndLineCombo - dotWidth;
  for(var i=0; i<numStages; i++) {
    rowChildren.add(_getDot(dotWidth, stage, i));
    if (i < (numStages-1)) {
      rowChildren.add(Container(
            width: lineLength,
            height: 2.0,
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
             Stack(
               children: [
                 Container(
                   width: 10.0,
                   height: DeviceData().ButtonHeight,
                   decoration:
                     BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(9.0)),
                       color: CustomColors.salmon,
                   ),
                 ),
                 Positioned(
                   left: 5.0,
                   child: Container(
                     width: 20.0,
                     height: DeviceData().ButtonHeight,
                     decoration: BoxDecoration(
                       color: CustomColors.salmon,
                     ),
                   ),
                 ),
               ]
             ),
             Container(
               width: 10.0,
               height: DeviceData().ButtonHeight,
             ),
             Container(
               child: child
             ),
           ]
         ),
      );
}

int _getMaxLines(maxLines) {
  if ( maxLines <= 1 ) {
    return 1;
  } else {
    return (maxLines/2).toInt();
  }
}

class ColorSliverTextField extends Container{
  ColorSliverTextField({
    Key key,
    TextEditingController controller,
    int maxLines:1,
    String labelText,
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
      child: TextField(
        keyboardType: TextInputType.multiline,
        controller: controller,
        maxLines: maxLines,
        maxLength: 200,
        decoration: InputDecoration(
          prefixIcon: 
             Stack(
               children: [
                 Container(
                   width: 10.0,
                   height: DeviceData().ButtonHeight*_getMaxLines(maxLines),
                   decoration:
                     BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(9.0)),
                       color: CustomColors.salmon,
                   ),
                 ),
                 Positioned(
                   left: 5.0,
                   child: Container(
                     width: 6.0,
                     height: DeviceData().ButtonHeight*_getMaxLines(maxLines),
                     decoration: BoxDecoration(
                       color: CustomColors.salmon,
                     ),
                   ),
                 ),
               ]
             ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9.0)),
          filled: true,
          fillColor: Colors.grey[200],
          labelText: labelText,
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey[200], width: 0.0),
            ),
          ),
        ),
      );
}
