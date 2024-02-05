List<bool> checkboxValues = List.generate(52, (index) => false);

class UserModel {
  final String name;
  final String phone1;
  final String phone2;
  final String address;
  final String bornDate;
  final bool isIftekad;
  List attendanceList;
  final String docId;

  UserModel(
      {required this.docId,
      required this.attendanceList,
      required this.isIftekad,
      required this.name,
      required this.phone1,
      required this.phone2,
      required this.address,
      required this.bornDate});
}
