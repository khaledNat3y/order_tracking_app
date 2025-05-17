import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/features/auth/logic/auth_cubit.dart';
import '../../core/routing/app_routes.dart';
import '../../core/styling/app_assets.dart';
import '../../core/styling/app_colors.dart';
import '../../core/styling/app_styles.dart';
import '../../core/utils/animated_snack_dialog.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primay_button_widget.dart';
import '../../core/widgets/spacing_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPassword = false;
  final formKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              showAnimatedSnackDialog(
                context,
                message: state.message,
                type: AnimatedSnackBarType.success,
              );
              GoRouter.of(context).pushNamed(AppRoutes.homeScreen);
            }
            if (state is AuthFailure) {
              showAnimatedSnackDialog(
                context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(28),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Login To Your Account",
                        style: AppStyles.primaryHeadLinesStyle,
                      ),
                    ),
                    const HeightSpace(8),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "it's great to see you again",
                        style: AppStyles.grey12MediumStyle,
                      ),
                    ),
                    const HeightSpace(20),
                    Center(
                      child: Image.asset(
                        AppAssets.order,
                        width: 190.w,
                        height: 190.w,
                      ),
                    ),
                    const HeightSpace(32),
                    Text("Email", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: email,
                      hintText: "Enter Your Email",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Email";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(16),
                    Text("Password", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      hintText: "Enter Your Password",
                      controller: password,
                      isPassword: isPassword,
                      suffixIcon: IconButton(
                        icon: isPassword ? Icon(Icons.visibility_off, size: 20.sp,) : Icon(Icons.visibility, size: 20.sp,),
                        color: AppColors.greyColor,
                        onPressed: (){
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(55),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return PrimayButtonWidget(
                          buttonText: state is AuthLoading ? "Loading..." : "Sign in",
                          onPress:
                          state is AuthLoading
                              ? (){}
                              : () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().loginUser(
                                email: email.text,
                                password: password.text,
                              );
                            }
                          },
                        );
                      },
                    ),
                    const HeightSpace(70),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.registerScreen);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: AppStyles.black16w500Style.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                            children: [
                              TextSpan(
                                text: "Join",
                                style: AppStyles.black15BoldStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const HeightSpace(16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
