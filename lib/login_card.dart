import 'package:flutter/material.dart';

class CardLogin extends StatelessWidget {
  const CardLogin({super.key});

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
            Field(hint: "Email atau Nomor HP", icon: Icons.email_outlined),
            Field(hint: "Password", icon: Icons.lock, isPassword: true),
          ],
        ),
      ),
    );
  }
}

class Field extends StatefulWidget {
  const Field({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
  });

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
      setState(() {}); // rebuild saat fokus berubah
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
      crossAxisAlignment: CrossAxisAlignment.start, // biar rata kiri
      children: [
        TextFormField(
          focusNode: _focusNode,
          obscureText: widget.isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, size: 30),
            prefixIconColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return const Color(0xff0e86e4); // warna saat fokus
              }
              return const Color(0xff9b9bb4); // warna normal
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

// TextFormField(
//   decoration: InputDecoration(
//     prefixIcon: const Icon(Icons.phone_android),
//     hintText: "Email atau Nomor HP",
//     filled: true,
//     fillColor: Colors.grey.shade100,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(15),
//       borderSide: BorderSide.none,
//     ),
//   ),
// ),
