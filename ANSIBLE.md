# Ansible ディレクトリ構造ガイド

このプロジェクトはAnsibleのベストプラクティスに沿ったディレクトリ構造を採用しています。

## 📁 ディレクトリ構造

```
.
├── ansible.cfg                 # Ansible設定ファイル
├── site.yaml                   # メインプレイブック
├── inventory/                  # インベントリファイル
│   ├── hosts.yaml             # ホスト定義
│   ├── group_vars/            # グループ変数
│   │   ├── all.yaml          # 全ホスト共通変数
│   │   └── nginx.yaml        # nginxグループ変数
│   └── host_vars/            # ホスト固有変数
├── playbooks/                 # 個別プレイブック
│   ├── common.yaml           # 共通設定プレイブック
│   └── nginx.yaml            # Nginx設定プレイブック
└── roles/                    # ロール定義
    ├── common/               # 共通ロール
    │   ├── README.md
    │   ├── tasks/
    │   │   └── main.yaml
    │   ├── handlers/
    │   ├── templates/
    │   ├── files/
    │   ├── vars/
    │   └── defaults/
    │       └── main.yaml
    └── nginx/                # Nginxロール
        ├── README.md
        ├── tasks/
        │   └── main.yaml
        ├── handlers/
        │   └── main.yaml
        ├── templates/
        ├── files/
        ├── vars/
        └── defaults/
            └── main.yaml
```

## 🚀 使用方法

### 1. すべてのサーバーに全設定を適用
```bash
ansible-playbook site.yaml
```

### 2. 共通設定のみ適用（全サーバー）
```bash
ansible-playbook playbooks/common.yaml
# または
ansible-playbook site.yaml --tags common
```

### 3. Nginxサーバーのみ設定
```bash
ansible-playbook playbooks/nginx.yaml
# または
ansible-playbook site.yaml --tags nginx
```

### 4. 特定のホストのみ実行
```bash
ansible-playbook site.yaml --limit nginx
ansible-playbook site.yaml --limit nginx-server-1
```

### 5. ドライラン（変更を適用せず確認のみ）
```bash
ansible-playbook site.yaml --check
```

### 6. 差分表示
```bash
ansible-playbook site.yaml --check --diff
```

## 🧪 Dry-run と検証（CI/ローカル確認用）

### 構文チェック
```bash
# 全プレイブックの構文チェック
ansible-playbook site.yaml --syntax-check
ansible-playbook playbooks/common.yaml --syntax-check
ansible-playbook playbooks/nginx.yaml --syntax-check
```

### Dry-run（変更を適用せず実行確認）
```bash
# すべての設定をdry-run
ansible-playbook site.yaml --check

# 差分も表示
ansible-playbook site.yaml --check --diff

# 個別のdry-run
ansible-playbook playbooks/common.yaml --check --diff
ansible-playbook playbooks/nginx.yaml --check --diff
```

### Lint（コード品質チェック）
```bash
# ansible-lintのインストール
pip install ansible-lint

# Lint実行
ansible-lint site.yaml
ansible-lint playbooks/*.yaml
ansible-lint roles/*/tasks/*.yaml
```
プルリクエストやプッシュ時に自動的に以下が実行されます：

- 構文チェック
- ansible-lint
- 検証サマリー

## 📋 主要なファイル

### site.yaml
メインのプレイブック。すべてのロールをオーケストレートします。

### inventory/hosts.yaml
ホストとグループの定義を記述します。

### inventory/group_vars/
グループごとの変数を定義します。`all.yaml`は全ホストに適用されます。

### roles/
再利用可能なロール定義。各ロールは以下の構造を持ちます:
- `tasks/`: 実行するタスク
- `handlers/`: イベントハンドラー
- `templates/`: Jinja2テンプレート
- `files/`: 配布する静的ファイル
- `vars/`: ロール変数（上書き不可）
- `defaults/`: デフォルト変数（上書き可能）

## 🎯 ベストプラクティス

1. **変数の優先順位**
   - `defaults/main.yaml`: デフォルト値（最も低い優先度）
   - `inventory/group_vars/`: グループ変数
   - `inventory/host_vars/`: ホスト変数
   - `vars/main.yaml`: ロール変数（最も高い優先度）

2. **ロールの設計**
   - 単一責任の原則に従う
   - 再利用可能で独立性を保つ
   - 変数を使ってカスタマイズ可能にする

3. **タグの活用**
   - プレイやタスクにタグを付けて部分実行を可能にする

4. **ドキュメント**
   - 各ロールにREADME.mdを作成
   - 変数と依存関係を明記

## 🔧 新しいロールの追加方法

1. ロールディレクトリを作成:
```bash
mkdir -p roles/newrole/{tasks,handlers,templates,files,vars,defaults}
```

2. 必要なファイルを作成:
```bash
touch roles/newrole/tasks/main.yaml
touch roles/newrole/handlers/main.yaml
touch roles/newrole/defaults/main.yaml
touch roles/newrole/README.md
```

3. `site.yaml` にプレイを追加:
```yaml
- name: Configure NewRole servers
  hosts: newrole
  become: yes
  tags:
    - newrole
  
  roles:
    - common
    - newrole
```

4. `inventory/hosts.yaml` にホストグループを追加

5. 必要に応じて `inventory/group_vars/newrole.yaml` を作成

## 📚 参考資料

- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Sample Directory Layout](https://docs.ansible.com/ansible/latest/user_guide/sample_setup.html)
