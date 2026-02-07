# Common Role

すべてのサーバーに共通で適用される基本設定を行うロール。

## 機能

- システムパッケージの更新 (apt update/upgrade)
- 共通パッケージのインストール (curl, wget, vim, git, htop)
- 再起動が必要かどうかのチェック

## 変数

このロールで使用可能な変数は `defaults/main.yaml` を参照してください。

## 依存関係

なし

## 使用例

```yaml
- hosts: all
  become: yes
  roles:
    - common
```
