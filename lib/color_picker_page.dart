import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'grid_card.dart';
import 'network.dart';

class ColorPickerPage extends StatefulWidget {
  final bool rgbStatus;
  final Color rgbColor;
  final Widget initialIcon;

  const ColorPickerPage({Key key, @required this.rgbStatus, @required this.rgbColor, @required this.initialIcon}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}


class _ColorPickerPageState extends State<ColorPickerPage> {
  bool rgbStatus;
  Color rgbColor;
  int rgbMode;
  bool exit = false;
  Color newColor;

  Widget get rgbModeIcon{
    switch (rgbMode){
      case 0:
        return Icon(Icons.wb_iridescent);
      case 1:
        return Icon(Icons.looks);
      case 2:
        return Icon(Icons.blur_linear);
      default: return widget.initialIcon;
    }
  }

  @override
  void initState() {
    rgbStatus = widget.rgbStatus;
    rgbColor = widget.rgbColor;
    newColor = rgbColor;
    exit = false;

    getDataField("rgbMode").then((value) {
      setState(() {
        rgbMode = value;
      });
    });

    super.initState();
  }

  void changeRgbStatus(bool newVal) {
    setState(() {
      rgbStatus = newVal;
    });
    setDataField("rgbStatus", newVal ? 1 : 0);
  }

  void changeRgbColor(Color newColor){
    setState(() {
      rgbColor = newColor;
    });
    setDataField("rgbColor", "${rgbColor.red},${rgbColor.green},${rgbColor.blue}");
  }

  void changeRgbMode(int newVal) {
    setState(() {
      rgbMode = newVal;
    });
    setDataField("rgbMode", newVal);
  }

  void pauseRefreshTimer(){

  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: exit ? 0 : 6),
      duration: const Duration(milliseconds: 300),
      builder: (context, sigma, child){
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: sigma,
            sigmaY: sigma,
          ),
          child: child,
        );
      },

      child: WillPopScope(
        onWillPop: (){
          setState(() {
            exit = true;
          });
          changeRgbColor(newColor);
          return Future.value(true);
        },
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: (){
                Navigator.of(context).maybePop(newColor);
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 128,
                          width: 128,
                          child: Hero(
                            tag: "rgbButton",
                            child: GridCardButton(
                              alpha: rgbStatus ? 255 : 180,
                              onTap: (){

                              },
                              icon: rgbModeIcon,
                              enabled: rgbStatus,
                              iconColor: rgbColor,
                            ),
                          ),
                        ),
                      ),

                      AnimatedOpacity(
                        opacity: exit ? 0 : 1,
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 300),
                        child: GridCard(
                          aspectRatio: 3/2,
                          alpha: 230,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: SlidePicker(
                              pickerColor: rgbColor,
                              onColorChanged: (color){
                                  newColor = color;
                              },
                              enableAlpha: false,
                              displayThumbColor: true,
                              paletteType: PaletteType.rgb,
                              showLabel: false,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: GridCardButton(
                              icon: ColorFiltered(
                                child: Image.asset("assets/rainbow.png", alignment: Alignment.center,),
                                colorFilter: ColorFilter.mode(Colors.blueGrey.shade800.withAlpha(140), (rgbMode!=1) ? BlendMode.srcATop : BlendMode.dst),
                              ),
                              onTap: (){
                                pauseRefreshTimer();
                                changeRgbMode(1);
                              },
                              alpha: (rgbMode==1) ? 255 : 180,
                              enabled: (rgbMode==1),
                            ),
                          ),

                          Expanded(
                            child: GridCardButton(
                              icon: Icon(Icons.wb_iridescent),
                              onTap: (){
                                pauseRefreshTimer();
                                changeRgbMode(0);
                              },
                              alpha: (rgbMode==0) ? 255 : 180,
                              enabled: (rgbMode==0),
                              iconColor: rgbColor,

                            ),
                          ),

                          Expanded(
                            child: GridCardButton(
                              icon: Icon(Icons.blur_linear),
                              onTap: (){
                                pauseRefreshTimer();
                                changeRgbMode(2);
                              },
                              alpha: (rgbMode==2) ? 255 : 180,
                              enabled: (rgbMode==2),
                              iconColor: Colors.blue,

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
