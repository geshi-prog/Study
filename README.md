# Study
学習用

## コンテナ立ち上げまでの流れ

### イメージを作成

`docker image build --tag <イメージ名> .`

### コンテナを作成(jupyter用に8888ポートを開放しています。)

`docker container run -p 8888:8888 --name <コンテナ名> -it <イメージ名>`

### コンテナログイン

`docker container start <コンテナ名>`

`docker exec -it <コンテナ名> /bin/bash`

## jupyterの起動

#### jupyterの起動

`jupyter notebook --allow-root --ip=0.0.0.0`このコマンドの出力結果で?token=\<token\>の箇所があるので\<token\>をメモします。

http://127.0.0.1:8888/ に移動すると下記の画面が表示されるので\<token\>をTokenと設定したいパスワードをNew Passwordに入力するとログインが可能です。

![image](https://user-images.githubusercontent.com/66429160/212205383-66a30146-42d3-4fab-833f-d9186b0ce000.png)
