import 'package:flutter/material.dart';
import 'package:social_medial_sample_project/bloc/auth_cubit.dart';
import 'package:social_medial_sample_project/screens/posts_screen.dart';
import 'package:social_medial_sample_project/screens/sign_in_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "/sign_up_screen";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email = "";
  String _username = "";
  String _password = "";

  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState!.save();

    context.read<AuthCubit>().signUpWithEmail(
        email: _email, username: _username, password: _password);
  }

  @override
  void initState() {
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: BlocConsumer<AuthCubit, AuthState>(
              listener: (prevState, currentState) {
            if (currentState is AuthSignedUp) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Email verification link has benn sent, verify your email and log in"),
                ),
              );
              //  Navigator.of(context).pushReplacementNamed(PostsScreen.routeName);
            }
            if (currentState is AuthError) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).errorColor,
                  content: Text(
                    currentState.message,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.onError),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }, builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(15),
              children: [
                // email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _email = value!.trim();
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_usernameFocusNode),
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: "Enter email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please provide email...";
                    }

                    if (value.length < 4) {
                      return "Please provide longer email...";
                    }
                    return null;
                  },
                ),
                // username
                TextFormField(
                  focusNode: _usernameFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                  onSaved: (value) {
                    _username = value!.trim();
                  },
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: "Enter username"),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please provide username...";
                    }

                    if (value.length < 4) {
                      return "Please provide longer username...";
                    }
                    return null;
                  },
                ),
                // password
                TextFormField(
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  onFieldSubmitted: (_) => _submit(),
                  onSaved: (value) {
                    _password = value!.trim();
                  },
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: "Enter password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please provide password...";
                    }

                    if (value.length < 4) {
                      return "Please provide longer password...";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    child: const Text("Sign Up")),

                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(SignInScreen.routeName),
                  child: const Text("Sign In Instead"),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
