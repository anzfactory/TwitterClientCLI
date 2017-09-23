# Twitter client CLI
CLIのツイッタークライアント  
（動作確認はmacでしかやっていない）

## インストール

[ここ](https://github.com/anzfactory/TwitterClientCLI/releases/latest)から**twcli**をダウンロード
あとは`/usr/locari/bin`などに置くなり、パスを通すなりでok

### 自分でビルドする場合

* Swiftを動く環境をととのえる
* [ここ](https://github.com/anzfactory/TwitterClientCLI/releases/latest)コードをダウンロードするか、Cloneするなりでコードゲット
* `swift build` or `swift build -c release`
* あとはお好きに

## できること

一応クライアントとして最低限なことはできる

* ユーザ認証  
* ツイート  
* リツイート  
* ツイートのいいね  
* ユーザのフォロー  
* タイムラインの表示  
* 検索  

### ユーザ認証

```
$ twcli auth
```

を実行するとTwitter認証画面をブラウザで開くので連携を許可して  
pinコードを入力すると認証ok

### ツイート

```
$ twcli tweet ツイート文
```

### リツイート

```
$ twcli retweet ツイートID
$ twcli unretweet ツイートID
```

### ツイートのいいね

```
# いいねしたツイートリスト
$ twcli favolist
$ twcli favolist --count 10

# ツイートをいいねする
$ twcli favo ツイートID
$ twcli unfavo ツイートID
```

### ユーザのフォロー

```
$ twcli follow ユーザID or スクリーンネーム
$ twcli unfollow ユーザID or スクリーンネーム
```

### タイムライン表示

```
$ twcli timeline
$ twcli timeline --count 10
```

### 検索

```
$ twcli search 検索ワード
$ twcli search 検索ワード --count 10
```

ユーザ検索

```
$ twcli search 検索ワード --fromUser
$ twcli search 検索ワード --count 10 --fromUser
```

### 特殊

**Love**

リツイートといいねをするコマンド

```
$ twcli love ツイートID
```

## TODO

* メディアのアップロード  