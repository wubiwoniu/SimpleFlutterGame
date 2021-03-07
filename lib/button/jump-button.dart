import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dinosaur/component/dinosaur.dart';

class JumpButton {
  final Dinosaur dino;

  JumpButton(this.dino);
  Widget setJumpButton({ValueChanged<bool> onHighlightChanged}) {
    Positioned pos = Positioned(
        right: 20,
        bottom: 50,
        child: MaterialButton(
          onPressed: () {},
          onHighlightChanged: onHighlightChanged,
          color: Colors.grey,
          highlightColor: Colors.black,
          child: Container(
            width: 40,
            height: 40,
            decoration: new BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border: new Border.all(width: 2, color: Colors.black),
            ),
            child: Icon(
              Icons.arrow_drop_up,
              color: Colors.black,
            ),
          ),
        ));
    return pos;
  }
}
