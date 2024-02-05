import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:osrty/models/user_class.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'osrty_state.dart';

class OsrtyCubit extends Cubit<OsrtyState> {
  OsrtyCubit() : super(OsrtyInitial());

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
}
