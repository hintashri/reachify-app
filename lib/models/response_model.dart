// class ResponseModel {
//   final String status;
//   final String message;
//   final dynamic result;
//   final int tp;
//
//   bool get isSuccess => status == 'success';
//
//   ResponseModel({
//     this.status = '',
//     this.message = '',
//     this.result,
//     this.tp = 0,
//   });
//
//   factory ResponseModel.fromJson(Map<String, dynamic> json) {
//     return ResponseModel(
//       status: json['status'] ?? '',
//       message: json['msg'] ?? '',
//       result: json['result'] ?? '',
//       tp: json['tp'] ?? 0,
//     );
//   }
//
//   factory ResponseModel.fromListJson(List<dynamic> data) {
//     return ResponseModel(result: data, status: 'success');
//   }
//
//   Map<String, dynamic> toJson() => {
//     'status': status,
//     'message': message,
//     'result': result ?? '',
//     'tp': tp,
//   };
// }
