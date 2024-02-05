import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:osrty/models/user_class.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'osrty_state.dart';

class OsrtyCubit extends Cubit<OsrtyState> {
  OsrtyCubit() : super(OsrtyInitial());
  var box = Hive.box<Map<dynamic, dynamic>>('users2');
  String email = '';
  List<UserModel> usersList = [];
  List<UserModel> serachedList = [];

  List<dynamic> attendanceHelper(int index, bool value, List<dynamic> mylist) {
    mylist[index] = value;
    return mylist;
  }

  int totalCount(List<dynamic> myList) {
    int counter = 0;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] == true) {
        counter++;
      }
    }
    return counter;
  }

  Future<bool> connectedToInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }

  List searchedList(String searchValue) {
    List searchedList = [];
    for (int i = 0; i < usersList.length; i++) {
      if (usersList[i].name.toLowerCase().contains(searchValue.toLowerCase())) {
        searchedList.add(usersList[i]);
      }
    }
    return searchedList;
  }
}
