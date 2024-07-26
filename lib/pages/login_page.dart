import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanctum_mobile/blocs/auth/auth_bloc.dart';
import 'package:sanctum_mobile/blocs/auth/auth_state.dart';
import 'package:sanctum_mobile/services/shared_preferences.dart';
import 'package:sanctum_mobile/util/color.dart';
import 'package:sanctum_mobile/widgets/common/loading_indicator.dart';
import 'package:sanctum_mobile/widgets/login/login_form.dart';
import 'package:sanctum_mobile/widgets/login/login_header.dart';
import 'package:sanctum_mobile/widgets/register_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var sharedPreferences =
          SharedPreferencesProvider.of(context)?.sharedPreferences;
      var token = sharedPreferences?.getString('token');
      if (token != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 50,),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,       
                        children: [
                          LoginHeader(),
                          TabBar(  
                            labelColor: tabBarIndicator,
                            indicatorColor: tabBarIndicator,
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: labelUnselected,
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),
                            tabs: [
                              Tab(
                                text: 'Login',
                              ),
                              Tab(
                                text: 'Register',
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          LoginForm(),
                          RegisterForm()
                        ]
                      ),
                    ),
                 ],
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const LoadingIndicator();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
        )
      ),
    );
  }
}