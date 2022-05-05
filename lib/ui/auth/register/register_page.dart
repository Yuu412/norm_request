import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/auth/password_state_model.dart';
import 'package:norm_request/model/auth/register/register_model.dart';
import 'package:flutter/material.dart';
import 'package:norm_request/ui/auth/login/login_page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        body: Column(
          children: [
            LogoArea(),
            InputArea(),
          ],
        ),
      ),
    );
  }
}

class InputArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<RegisterModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ChangeNotifierProvider<ShadePasswordModel>(
                create: (_) => ShadePasswordModel()..init(),
                child: InputForm(),
              ),
            ),
            if (model.isLoading)
              Container(
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

class InputForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final RegisterModel registerModel = context.watch<RegisterModel>();
    final ShadePasswordModel passwordStateModel = context.watch<ShadePasswordModel>();

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom : BlockSize().height(context) * 3,
          ),
          child: TextField(
            controller: registerModel.titleController,
            decoration: InputDecoration(
              hintText: 'メールアドレス',
              labelText: 'メールアドレス',
            ),
            onChanged: (text) {
              registerModel.setEmail(text);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom : BlockSize().height(context) * 5,
          ),
          child: TextField(
            obscureText: passwordStateModel.isObsucure!,
            controller: registerModel.authorController,
            decoration: InputDecoration(
              hintText: 'パスワード',
              labelText: 'パスワード',
              /* ここからアイコンの設定 */
              suffixIcon: IconButton(
                icon: Icon(passwordStateModel.isObsucure! ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  passwordStateModel.changeState();
                },
              ),
            ),

            onChanged: (text) {
              registerModel.setPassword(text);
            },
          ),
        ),
        SizedBox(
          width: BlockSize().width(context) * 50,
          height: BlockSize().height(context) * 5,
          child: ElevatedButton(
            onPressed: () async {
              registerModel.startLoading();
              // 追加の処理
              try {
                await registerModel.signUp();
                Navigator.of(context).pop();
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } finally {
                registerModel.endLoading();
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color(RetButtonColor().gradientBlue()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              '会員登録',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        ToLoginPage(),
      ],
    );
  }
}

class ToLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top : BlockSize().height(context) * 5,
            bottom : BlockSize().height(context) * 1.5,
          ),
          child: Text('既に登録している方はこちら'),
        ),
        SizedBox(
          width: BlockSize().width(context) * 50,
          height: BlockSize().height(context) * 5,
          child: ElevatedButton(
            onPressed: () async {
              // 画面遷移
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                  fullscreenDialog: true,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: BorderSide(
                color: Color(RetButtonColor().gradientBlue()), //色
                width: 2, //太さ
              ),
            ),
            child: Text(
              'ログイン',
              style: TextStyle(
                color: Color(RetButtonColor().gradientBlue()),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}