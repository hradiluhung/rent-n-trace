import 'dart:io';

class UpdateUserReq {
  String? id;
  String? fullName;
  String? username;
  String? divisionId;
  File? newPhoto;

  UpdateUserReq({this.id, this.fullName, this.username, this.divisionId, this.newPhoto});
}
