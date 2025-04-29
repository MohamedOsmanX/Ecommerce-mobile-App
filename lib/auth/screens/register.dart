import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloC/auth_bloc.dart';
import '../bloC/auth_event.dart';
import '../bloC/auth_state.dart';
import '../../core/enums/user_roles.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _selectedRole = ValueNotifier<UserRole>(UserRole.customer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<UserRole>(
                  valueListenable: _selectedRole,
                  builder: (context, role, _) {
                    return DropdownButtonFormField<UserRole>(
                      value: role,
                      decoration: const InputDecoration(
                        labelText: 'Account Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: UserRole.customer,
                          child: Text('CUSTOMER'),
                        ),
                        DropdownMenuItem(
                          value: UserRole.seller,
                          child: Text('SELLER'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _selectedRole.value = value;
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        final name = _nameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (name.isEmpty || email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
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
                      child: const Text('Register'),
                    ),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}