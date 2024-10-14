import 'package:flutter/material.dart';

class Modifytodo {
  final bool isModify;
  final int? artId;
  final String? initTitle;
  final String? initContext;
  final String? initimport;
  final String? initTag;
  final TimeOfDay? initTime;
  final String? initStatus;

  Modifytodo(
      {this.isModify = false,
      this.artId,
      this.initTitle,
      this.initContext,
      this.initimport,
      this.initTag,
      this.initStatus,
      this.initTime});

  factory Modifytodo.forModify(
      int artId,
      String initTitle,
      String initContext,
      String initimport,
      String initTag,
      TimeOfDay initTime,
      String initStatus) {
    return Modifytodo(
        isModify: true,
        artId: artId,
        initTitle: initTitle,
        initContext: initContext,
        initimport: initimport,
        initTag: initTag,
        initStatus: initStatus,
        initTime: initTime);
  }
}
