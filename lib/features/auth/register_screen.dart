import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking_app/core/routing/app_routes.dart';
import 'package:order_tracking_app/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking_app/features/auth/logic/auth_cubit.dart';

import '../../core/styling/app_assets.dart';
import '../../core/styling/app_colors.dart';
import '../../core/styling/app_styles.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primay_button_widget.dart';
import '../../core/widgets/spacing_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPassword = false;
  final formKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = TextEditingController();
    password = TextEditingController();
    email = TextEditingController();
    confirmPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                showAnimatedSnackDialog(
                  context,
                  message: state.message,
                  type: AnimatedSnackBarType.success,
                );
                GoRouter.of(context).pushNamed(AppRoutes.loginScreen);
                username.clear();
                password.clear();
                email.clear();
                confirmPassword.clear();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(28),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Create an account",
                        style: AppStyles.primaryHeadLinesStyle,
                      ),
                    ),
                    const HeightSpace(8),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Let’s create your account.",
                        style: AppStyles.grey12MediumStyle,
                      ),
                    ),
                    const HeightSpace(20),
                    Center(
                      child: Image.asset(
                        AppAssets.logo,
                        width: 190.w,
                        height: 190.w,
                      ),
                    ),
                    const HeightSpace(32),
                    Text("User Name", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: username,
                      hintText: "Enter Your User Name",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your User Name";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(16),
                    Text("Email", style: AppStyles.black16w500Style),
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
                        icon:
                            isPassword
                                ? Icon(Icons.visibility_off, size: 20.sp)
                                : Icon(Icons.visibility, size: 20.sp),
                        color: AppColors.greyColor,
                        onPressed: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Password";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(16),
                    Text("Confirm Password", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      hintText: "Enter Your Password",
                      controller: confirmPassword,
                      isPassword: isPassword,
                      suffixIcon: IconButton(
                        icon:
                            isPassword
                                ? Icon(Icons.visibility_off, size: 20.sp)
                                : Icon(Icons.visibility, size: 20.sp),
                        color: AppColors.greyColor,
                        onPressed: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Password";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        if (value != password.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(55),
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen:
                          (previous, current) =>
                              previous is! AuthLoading &&
                              current is AuthLoading,
                      builder: (context, state) {
                        return PrimaryButtonWidget(
                          buttonText:
                              state is AuthLoading
                                  ? "Loading..."
                                  : "Create Account",
                          onPress: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().registerUser(
                                userName: username.value.text,
                                email: email.value.text,
                                password: password.value.text,
                              );
                            }
                          },
                        );
                      },
                    ),
                    const HeightSpace(8),
                    Center(
                      child: InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Do you have account? ",
                            style: AppStyles.black16w500Style.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                            children: [
                              TextSpan(
                                text: "Login",
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
