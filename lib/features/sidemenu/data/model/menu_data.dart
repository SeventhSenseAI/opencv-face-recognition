import 'dart:convert';
import 'package:equatable/equatable.dart';

class MenuData extends Equatable {
  final String? code;
  final String? message;

  const MenuData({
    this.code,
    this.message,
  });

  @override
  List<Object?> get props => [code, message];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'message': message,
    };
  }

  factory MenuData.fromMap(Map<String, dynamic> map) {
    return MenuData(
      code: map['code'] != null ? map['code'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuData.fromJson(String source) =>
      MenuData.fromMap(json.decode(source) as Map<String, dynamic>);
}
