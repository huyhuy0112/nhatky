import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final Color color;
  final String? icon;
  final int taskCount;

  const Category({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
    this.taskCount = 0,
  });

  @override
  List<Object?> get props => [id, name, color, icon];
}
