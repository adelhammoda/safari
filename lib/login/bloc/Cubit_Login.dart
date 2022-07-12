import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safari/login/bloc/States_Login.dart';
import 'package:safari/login/datalayer/Login_Model.dart';
import 'package:safari/login/datalayer/Login_Repository.dart';


class LoginCubit extends Cubit<LoginState>
{
  LoginModel loginModel = LoginModel();
  //final LoginRepository loginRepository;
  LoginCubit(LoginState initialState) : super(initialState);

// SendRequest(LoginModel info)async{
//
//   int status =loginRepository.Login(info);
//
//   if(status==200) {
//     print("inside bloc status 200");
//     emit(AdminLoadingSucceccState());
//   }
//
//   else
//     {
//       print("inside bloc status 400");
//       emit(LoadingErrorState(message: "An Error Occured"));
//     }
//
// }

}