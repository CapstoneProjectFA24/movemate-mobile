import 'package:flutter/material.dart';
import 'package:movemate/utils/resources/validations.dart';

class ValidationForm extends StatefulWidget {
  const ValidationForm({super.key});

  @override
  _ValidationFormState createState() => _ValidationFormState();
}

class _ValidationFormState extends State<ValidationForm> with Validations {
  // Khai báo TextEditingController cho từng input field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Biến để chứa thông báo lỗi của từng trường dữ liệu
  String emailError = '';
  String passwordError = '';
  String phoneError = '';
  String usernameError = '';

  @override
  void initState() {
    super.initState();

    // Listener cho email
    _emailController.addListener(() {
      setState(() {
        emailError = emailRegexErrorText(_emailController.text);
      });
    });

    // Listener cho password
    _passwordController.addListener(() {
      setState(() {
        passwordError = passwordComplexityErrorText(_passwordController.text);
      });
    });

    // Listener cho số điện thoại
    _phoneController.addListener(() {
      setState(() {
        phoneError = phoneNumberErrorText(_phoneController.text);
      });
    });

    // Listener cho tên đăng nhập
    _usernameController.addListener(() {
      setState(() {
        usernameError = usernameMaxLengthErrorText(_usernameController.text);
      });
    });
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị huỷ
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-Time Validation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email input field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: emailError.isNotEmpty ? emailError : null,
              ),
            ),
            const SizedBox(height: 16),

            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                errorText: passwordError.isNotEmpty ? passwordError : null,
              ),
            ),
            const SizedBox(height: 16),

            // Phone number input field
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                errorText: phoneError.isNotEmpty ? phoneError : null,
              ),
            ),
            const SizedBox(height: 16),

            // Username input field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                errorText: usernameError.isNotEmpty ? usernameError : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
