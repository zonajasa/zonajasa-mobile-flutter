import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardLogin extends StatelessWidget {
  final TextEditingController noWaController;
  final TextEditingController passwordController;
  final Map<String, String> fieldErrors;
  final Function(String field)? onClearError;
  const CardLogin({
    super.key,
    required this.noWaController,
    required this.passwordController,
    required this.fieldErrors,
    this.onClearError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 360, left: 20, right: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Field(
              hint: "Nomor WhatsApp",
              icon: Icons.phone_android,
              controller: noWaController,
              errorText: fieldErrors["nomor_whatsapp"],
              onChangedClearError: () {
                onClearError?.call("nomor_whatsapp");
              },
            ),

            Field(
              hint: "Password",
              icon: Icons.lock,
              isPassword: true,
              controller: passwordController,
              errorText: fieldErrors["password"],
              onChangedClearError: () {
                onClearError?.call("password");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Field extends StatefulWidget {
  final String? errorText;
  final Function()? onChangedClearError;
  const Field({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.errorText,
    this.onChangedClearError,
  });

  final TextEditingController controller;

  final String hint;
  final IconData icon;
  final bool isPassword;

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  bool _isPasswordVisible = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: (value) {
            if (widget.errorText != null) {
              return widget.errorText;
            }

            if (value == null || value.isEmpty) {
              return widget.hint == "Nomor WhatsApp"
                  ? "Nomor WA wajib diisi"
                  : "Password wajib diisi";
            }

            return null;
          },
          onChanged: (_) {
            if (widget.errorText != null) {
              widget.onChangedClearError?.call();
            }
          },
          obscureText: widget.isPassword && !_isPasswordVisible,
          keyboardType: widget.hint == "Nomor WhatsApp"
              ? TextInputType.number
              : TextInputType.text,

          inputFormatters: widget.hint == "Nomor WhatsApp"
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, size: 30),
            prefixIconColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return const Color(0xff0e86e4);
              }
              return const Color(0xff9b9bb4);
            }),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 10,
              minHeight: 10,
            ),
            fillColor: Color(0xff9b9bb4),
            hintText: widget.hint,
            hintStyle: TextStyle(color: Color(0xffb2b3bf)),

            contentPadding: const EdgeInsets.symmetric(vertical: 20),

            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: isFocused
                          ? const Color(0xff0e86e4)
                          : const Color(0xff9b9bb4),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,

            border: widget.isPassword
                ? InputBorder.none
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff9b9bb4)),
                  ),

            enabledBorder: widget.isPassword
                ? InputBorder.none
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff9b9bb4)),
                  ),

            focusedBorder: widget.isPassword
                ? InputBorder.none
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0e86e4), width: 2),
                  ),
          ),
        ),
      ],
    );
  }
}
