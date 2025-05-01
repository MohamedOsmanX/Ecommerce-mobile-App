import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloC/auth_bloc.dart';
import '../bloC/auth_event.dart';
import '../bloC/auth_state.dart';
import '../../core/enums/user_roles.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _selectedRole = ValueNotifier<UserRole>(UserRole.customer);
  final _confirmPasswordController = TextEditingController(); // Add this
  final _showPassword = ValueNotifier<bool>(false); // Add this
  final _showConfirmPassword = ValueNotifier<bool>(false); // Add this

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // Change navigation to products page instead of home
            Navigator.pushReplacementNamed(context, '/products');
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 75,
                      child: Text(
                        'Create Account',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  SizedBox(
                    width: 400, // You can adjust this value
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 400, // You can adjust this value
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: _showPassword,
                    builder: (context, showPassword, _) {
                      return SizedBox(
                        width: 400, // You can adjust this value
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed:
                                  () => _showPassword.value = !showPassword,
                            ),
                          ),
                          obscureText: !showPassword,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: _showConfirmPassword,
                    builder: (context, showConfirmPassword, _) {
                      return SizedBox(
                        width: 400, 
                        child: TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed:
                                  () =>
                                      _showConfirmPassword.value =
                                          !showConfirmPassword,
                            ),
                          ),
                          obscureText: !showConfirmPassword,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<UserRole>(
                    valueListenable: _selectedRole,
                    builder: (context, role, _) {
                      return SizedBox(
                        width: 400, 
                        child: DropdownButtonFormField<UserRole>(
                          value: role,
                          decoration: const InputDecoration(
                            labelText: 'Account Type',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: UserRole.customer,
                              child: Text('Customer'),
                            ),
                            DropdownMenuItem(
                              value: UserRole.seller,
                              child: Text('Seller'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _selectedRole.value = value;
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = _nameController.text.trim();
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final confirmPassword =
                              _confirmPasswordController.text.trim();

                          if (name.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty ||
                              confirmPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (password != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          context.read<AuthBloc>().add(
                            RegisterRequested(
                              name,
                              email,
                              password,
                              _selectedRole.value.name,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF097969),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Register', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF097969),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),),
                      child: const Text('Already have an account? Login', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
