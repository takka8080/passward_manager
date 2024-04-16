#!/bin/bash

echo "パスワードマネージャーへようこそ！"

function input() {
  read -p 'サービス名を入力してください：' service
  read -p 'ユーザー名を入力してください：' user
  read -p 'パスワードを入力してください：' password
    
  echo "$service:$user:$password" >> manage.txt
}

input

echo "Thank you!"
