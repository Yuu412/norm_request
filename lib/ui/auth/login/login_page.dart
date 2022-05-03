import 'package:norm_request/model/auth/login/login_model.dart';
import 'package:norm_request/ui/auth/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _LoginContent();
  }
}

class _LoginContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<LoginModel>(
        create: (_) => LoginModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('ログイン'),
          ),
          body: InputArea(),
        ),
      ),
    );
  }
}

class InputArea extends StatefulWidget {
  @override
  _InputArea createState() => _InputArea();
}

class _InputArea extends State<InputArea> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<LoginModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.20),
              child: Column(
                children: [
                  TextField(
                    controller: model.titleController,
                    decoration: InputDecoration(hintText: 'メールアドレス'),
                    onChanged: (text) {
                      model.setEmail(text);
                    },
                  ),
                  SizedBox(height: 12),
                  TextField(
                    obscureText: _isObscure,
                    controller: model.authorController,
                    decoration: InputDecoration(
                      hintText: 'パスワード',
                      labelText: 'パスワード',
                      /* ここからアイコンの設定 */
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),

                    onChanged: (text) {
                      model.setPassword(text);
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      model.startLoading();

                      // 追加の処理
                      try {
                        await model.login();
                        Navigator.of(context).pop();
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                            snackBar);
                      } finally {
                        model.endLoading();
                      }
                    },
                    child: Text('ログイン'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // 画面遷移
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: Text('新規登録の方はこちら'),
                  ),
                ],
              ),
            ),
            if (model.isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }
}

