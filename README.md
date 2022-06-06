# dagger and docker
## 設定
- daggerのinstall <br>
- daggerのupdate<br>
- go.cueファイルに設定を書いてる<br>
```sh
dagger do 

Options

Available Actions:
 build           ローカルの./Dockerfileからimageをビルド
 test            goのtestを実行する
 load            ローカルにimageを作成する.  (注意：一回実行するとコンテナが再度作成されてしまう。直す必要ある)
 createContainer コンテナを作成
 startup         コンテナを起動
 stopContainer   コンテナをstop
 clean           作成したローカルのimageを削除する
 deploy          開発環境用のnetlifyにデプロイ

```

## できること
- コンテナ作成コンテナ内でサーバ起動
- ci
## やってないこと
- cdの設定

## 疑問
- dockerの操作をdaggerでやる意味なくね問題
