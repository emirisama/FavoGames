# GR

# 概要
- 人気・最新のゲームをチェックでき、レビュー投稿・閲覧できるアプリ
# 要件
- レビュー投稿できる
- レビューを閲覧できる
- 人気のゲームをチェックできる（評価順）
- 話題のゲームをチェックできる（お気に入り数順）　＊次回リリース予定
- お気に入りのゲームを記録できる　＊次回リリース予定
- 発売予定など最新のゲームをチェックできる
# 機能
- アプリ説明
- ログイン機能
- レビュー投稿・閲覧機能
- 人気（レビュー高評価）のゲームランキング画面（PS５、PS4,Switch,Steam）
- 話題（お気に入り数）のゲームランキング画面（PS５、PS４、Switch、Steam)　＊次回リリース予定
- いいね機能　＊次回リリース予定
- ゲーム詳細画面
- 新着情報閲覧画面
- 検索機能（直接入力、デバイスごと、ジャンルごと、発売日ごと）
- マイページ・ユーザー編集
- お問い合わせ
- フォローフォロワー機能 ＊次回リリース予定

# データベース設計
- https://docs.google.com/spreadsheets/d/1-QSy2dTsDfnsHjoCUZ8zUWizoJe7kQBLLIRLKB-XXYs/edit?usp=sharing

# ワイヤーフレーム
- https://drive.google.com/file/d/1vBi6MEztDYKMDyDR-uahodBdZjiS8Tfm/view?usp=sharing

# 画面遷移図
- https://drive.google.com/file/d/1DwlET5WXNm_4-lJP7deHsU-t7ncoiQg6/view?usp=sharing

# 画面遷移図（機能説明付き）
- https://drive.google.com/file/d/1MA5HK_GdIDi4G-ddUxA3Ka4wd7ENd-vv/view?usp=sharing

# データ取得
- ゲーム情報　https://api-docs.igdb.com/#about or https://english.api.rakuten.net/accujazz/api/rawg-video-games-database/details
- Youtube動画自動検索　https://api.rakuten.net/aidangig/api/youtube-to-mp4
- amazon商品自動検索　https://api.rakuten.net/ebappa1971/api/amazon-price