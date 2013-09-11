rensou-ios
======================
iOSアプリ「連想げーむ」のアプリ側コードです。
サーバ側のコードも[こちら](https://github.com/u1fukui/rensou-server)で公開しています。

[https://itunes.apple.com/jp/app/minnade-jigeyou!sosharu-lian/id668351056?mt=8&ign-mpt=uo%3D4](https://itunes.apple.com/jp/app/minnade-jigeyou!sosharu-lian/id668351056?mt=8&ign-mpt=uo%3D4)


実行方法
----------
1. [サーバ側](https://github.com/u1fukui/rensou-server) のセットアップをして、Sinatraアプリを起動して下さい。
2.  CocoaPods を使用しているので、CocoaPodsの導入と pod install の実行をして下さい。
（参考：[https://github.com/mixi-inc/iOSTraining/wiki/10.2-CocoaPods](https://github.com/mixi-inc/iOSTraining/wiki/10.2-CocoaPods)）
3. 作成された rensou.xcworkspace からXcodeを起動して下さい。
4. rensou-Info.plist の "ServerHostName" に 起動したSinatraへのURLを、"SupportEmailAddress" に適当な文字列を入力して下さい。
5. これでXcodeで実行してもらえば動くはずです。


ライセンス
----------
Copyright &copy; 2013 Yuichi Kobayashi

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

   1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

   3. This notice may not be removed or altered from any source
   distribution.