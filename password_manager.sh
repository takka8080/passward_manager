#!/bin/bash

# Add Password選択時の処理
function input() {
  read -p 'サービス名を入力してください：' service
  
  # 入力されたサービス名と同じ名前がすでにあれば取得
  match=$(gpg -d --batch --quiet --passphrase=hoge manage.txt.gpg | grep -Po '^.*?(?=:.*)' | grep -x $service)
  
  if [ -z "$match" ]; then
    read -p 'ユーザー名を入力してください：' user
    read -p 'パスワードを入力してください：' password
  fi
  
  if [[ "$service" =~ .*:.* || "$user" =~ .*:.* || "$password" =~ .*:.* ]]; then
    echo ':を含む文字列は扱えません。'
  elif [ -z "$match" ]; then
    gpg -do manage.txt --batch --quiet --yes --passphrase=hoge manage.txt.gpg
    
    echo "$service:$user:$password" >> manage.txt
   
    gpg -c --batch --quiet --yes --passphrase=hoge manage.txt
    rm manage.txt
     
    echo 'パスワードの追加は成功しました。'
  else
    echo 'すでに登録されています。'
  fi
}

# Get Password選択時の処理
function output() {
  read -p 'サービス名を入力してください：' service
  
  # 一致したサービス名を取得
  service_info=$(gpg -d --batch --quiet --passphrase=hoge manage.txt.gpg | grep -Po '^.*?(?=:.*)' | grep -x $service)
  
  if [ "$service_info" = "" ]; then
    echo 'そのサービスは登録されていません。'
  else
    user_info=$(gpg -d --batch --quiet --passphrase=hoge manage.txt.gpg | grep -Po "(?<=$service_info:).*?(?=:.*)")
    password_info=$(gpg -d --batch --quiet --passphrase=hoge manage.txt.gpg | grep -Po "(?<=$service_info:$user_info:).*")
    
    echo "サービス名：$service_info"
    echo "ユーザー名：$user_info"
    echo "パスワード：$password_info"
  fi
}

echo 'パスワードマネージャーへようこそ！'

while [ "$choices" != "Exit" ]; do
  read -p '次の選択肢から入力してください(Add Password/Get Password/Exit)：' choices

  case $choices in
    "Add Password" ) input ;;
    "Get Password" ) output ;;
    "Exit" ) ;;
    *) echo '入力が間違えています。Add Password/Get Password/Exit から入力してください。' ;;
  esac
done

echo "Thank you!"
