# Nginx Role

Nginxウェブサーバーのインストールと基本設定を行うロール。

## 機能

- Nginxのインストール
- Nginxサービスの起動と自動起動設定
- ファイアウォール設定 (HTTP/HTTPS)

## 変数

このロールで使用可能な変数は `defaults/main.yaml` を参照してください。

## 依存関係

- common (推奨)

## 使用例

```yaml
- hosts: nginx
  become: yes
  roles:
    - common
    - nginx
```

## ハンドラー

- `restart nginx`: Nginxサービスを再起動
- `reload nginx`: Nginx設定をリロード
