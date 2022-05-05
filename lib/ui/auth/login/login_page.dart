import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/model/auth/login/login_model.dart';
import 'package:norm_request/model/auth/password_state_model.dart';
import 'package:norm_request/ui/auth/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: ChangeNotifierProvider<LoginModel>(
          create: (_) => LoginModel(),
          child: Scaffold(
            body: Column(
              children: [
                LogoArea(),
                InputArea(),
              ],
            ),
          ),
        ),
      );
  }
}

class LogoArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top : BlockSize().height(context) * 7.5,
      ),
      child: Image(
        image: AssetImage('images/logo/logo-reverse.png'),
        width: BlockSize().width(context) * 60,
      ),
    );
  }
}

class InputArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<LoginModel>(builder: (context, model, child) {
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
    final LoginModel loginModel = context.watch<LoginModel>();
    final ShadePasswordModel passwordStateModel = context.watch<ShadePasswordModel>();

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom : BlockSize().height(context) * 3,
          ),
          child: TextField(
            controller: loginModel.titleController,
            decoration: InputDecoration(
              hintText: 'メールアドレス',
              labelText: 'メールアドレス',
            ),
            onChanged: (text) {
              loginModel.setEmail(text);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom : BlockSize().height(context) * 5,
          ),
          child: TextField(
            obscureText: passwordStateModel.isObsucure!,
            controller: loginModel.authorController,
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
              loginModel.setPassword(text);
            },
          ),
        ),
        SizedBox(
          width: BlockSize().width(context) * 50,
          height: BlockSize().height(context) * 5,
          child: ElevatedButton(
            onPressed: () async {
              loginModel.startLoading();
              // 追加の処理
              try {
                await loginModel.login();
                Navigator.of(context).pop();
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                    snackBar);
              } finally {
                loginModel.endLoading();
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color(RetButtonColor().gradientPurple()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'ログイン',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        ToRegisterPage(),
      ],
    );
  }
}

class ToRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top : BlockSize().height(context) * 5,
            bottom : BlockSize().height(context) * 1.5,
          ),
          child: Text('アカウントをお持ちでない方はこちら'),
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
                  builder: (context) => RegisterPage(),
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
                color: Color(RetButtonColor().gradientPurple()), //色
                width: 2, //太さ
              ),
            ),
            child: Text(
              '会員登録',
              style: TextStyle(
                color: Color(RetButtonColor().gradientPurple()),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



