# Chuke! <img src="https://user-images.githubusercontent.com/51669998/72270445-812e1100-3668-11ea-87ba-528ee3c93daa.png" width="35px">

![Group-83 5x2](https://user-images.githubusercontent.com/51669998/72270445-812e1100-3668-11ea-87ba-528ee3c93daa.png)  
<p align="center">
 <a href="https://github.com/apple/swift"><img src="https://camo.githubusercontent.com/de32b354687f1cd9b05a89e4aa03c7f2d311f294/68747470733a2f2f73776966742e6f72672f6173736574732f696d616765732f73776966742e737667" width="180px"; /></a><br>
 <a href="https://firebase.google.com/?hl=ja"><img src="https://firebase.google.com/downloads/brand-guidelines/PNG/logo-built_white.png?hl=ja" width="150px" /></a>&emsp;<a href="https://github.com/MessageKit/MessageKit"><img src="https://raw.githubusercontent.com/MessageKit/MessageKit/master/Assets/mklogo.png" width="150px" height="50px"; /></a>&emsp;<a href="https://github.com/IBAnimatable/IBAnimatable"><img src="https://raw.githubusercontent.com/IBAnimatable/IBAnimatable-Misc/master/IBAnimatable/Hero.png" width="200px" height="50px"; /></a>
 </p>
<br>
<br>
<br>
<br>



## アプリの機能


### 1.匿名ログイン

* firebaseの匿名ログインにてnameバーに名前を入力することでチャット機能を使用できます。

### 2.ランダムマッチング

* ログインしているユーザーが奇数である場合、マッチング相手が不在のため待機する。ログインしているユーザーが偶数の場合マッチング相手がいることが確認できるためマッチングします。(新規ユーザー同士がマッチングするシンプルな仕組みです)

### 3.チャット機能

* マッチングしたユーザーとチャットすることができます。
* トークルームを離れるとチャット履歴は保持しない。


<img src="https://user-images.githubusercontent.com/51669998/72281002-f4418280-367c-11ea-9fb7-f54add03a3c2.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/72281328-a2e5c300-367d-11ea-8516-2739da0ff5f0.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/72281547-20113800-367e-11ea-889f-c2aaf17bf514.png" width="200px">
&emsp;
<img src="https://user-images.githubusercontent.com/51669998/72281727-5fd81f80-367e-11ea-8f2e-e8f7e5cb197a.png" width="200px">


## 改善点

* シンプルな構造のためUI.UXにもっと時間を割いてよかったと思う。


## 感想

* 今回はシンプルなランダムマッチングチャットアプリを作成した。qiitaの記事にrealtime databaseを用いて作成した記事を参考にDatabaseをfirestoreへ、JSQMessagesViewControllerをMessageKitへ、他のUIライブラリを使用してフォークのような形となった。今回firestoreを使用したのは初めてだったし他のライブラリを使用したのは初めてだったため理解を深めることができた。さらにチャットする際のデータ構造、ランダムなマッチングも学ぶことができqiitaの記事を書いてくれた投稿者に感謝です。


## Requirement
 
 * Firestore  
 * Messagekit  
 * NVActivityIndicatorView  
 * IBAnimatable  


## Installation

```
pod "target" install
```

## License

 * MIT
