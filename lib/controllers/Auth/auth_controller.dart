import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/Auth/login_model.dart';
import '../../models/Auth/user_data_model.dart';
import '../../providers/Auth_providers/login_provider.dart';
import '../../routes/routes.dart';
import '../../shared/global_functions/global_functions.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/widgets/snackbar_widgets.dart';

class AuthController extends GetxController {
  bool isCircleShown = false;
  bool isNoInternetConnection = false;
  bool isLogin = false;
  bool isObscure = true;

  GetStorage storageBox = GetStorage();

  late LoginProvider loginProvider = Get.find();

  late UserDataModel userData;

  ///////////////////
  void changeIsObscure() {
    isObscure = !isObscure;
    update();
  }

/////////////////////////
  void showCircleIndicator() {
    isCircleShown = true;
    update();
  }

////////////////////////////
  void hideCircleIndicator() {
    isCircleShown = false;
    update();
  }

///////////////////////////////////
  void showNoInternetPage() {
    isNoInternetConnection = true;
    update();
  }

  void hideNoInternetPage() {
    isNoInternetConnection = false;
    update();
  }
/////////////////////////////

  Future<void> login({required LoginModel loginModel}) async {
    showCircleIndicator();
    final failureOrLogin = await loginProvider.call(loginModel);
    failureOrLogin.fold((failure) {
      HandlingErrors.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideCircleIndicator,
          showNoInternetPage: () {});
    }, (getUserData) async {
      userData = getUserData;
      isLogin = true;
      Future.wait([
        GlobalFunctions.setFcmToken(token: userData.token),
        GlobalFunctions.setIsLoggedIn(isLoggedIn: isLogin)
      ]);
      hideCircleIndicator();
      Get.offAllNamed(Routes.orderssPage);
      SnackBarWidgets.showSuccessSnackBar('Login Succeeded', '');
    });
  }

  //////////////////
  Future<void> logOut() async {
    isLogin = false;
    Future.wait([
      storageBox.remove('token'),
      GlobalFunctions.setIsLoggedIn(isLoggedIn: isLogin)
    ]);
    Get.offAllNamed(Routes.loginPage);
  }
}
