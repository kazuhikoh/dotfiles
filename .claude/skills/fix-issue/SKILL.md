---
description: "Github Issue の監視＆worktreeで対応"
---

GitHub Issue の対応を以下の手順に厳格に従って実行してください。

1. コマンド引数の確認  
   - $ARGUMENTS が数字であることを確認. 未指定/数字でない場合は、引数不正のエラー表示をして終了.
   - $ARGUMENTS が数字である場合、以後これを `ISSUE_NUMBER` とする.

2. 環境確認とブランチ/worktreeの作成
   - 作業ブランチ命名規則: `feature/{ISSUE_NUMBER}-{*:対応内容の簡潔な要約}`
   - Issue #\${ISSUE_NUMBER} に対応する作業ブランチがリモート/ローカルに存在するか, worktreeが存在するか を確認し、
     - (作業ブランチなし)
       - 作業ブランチ命名規則に従って worktree を作成し、worktree に入る.
       - `develop` ブランチ最新から派生する形で作成すること.
     - (作業ブランチあり, worktreeあり)
       - 該当の worktree を再開する.
     - (作業ブランチあり, worktreeなし)
       - 該当のブランチから worktree を作成し、worktree に入る.

3. Issue 情報の取得と実装計画の決定
   - `gh issue view ${ISSUE_NUMBER} --comments` を使用して、Issue のタイトル、説明本文、すべてのコメントを取得・分析.
   - 要求仕様を整理し、具体的な実装計画（タスク分解および実行手順）を決定する.

4. 実装
   - 実装計画に基づいてコードの変更・追加を行なう.
   - 実装完了後、適切に動作確認を実行して問題がないことを確認する.
   - 実装を確定
     - 当該ブランチのPRが既に作成済み: commit, push
     - 当該ブランチのPRが未作成: commit, push, PR作成

5. 終了処理
   - worktree を抜ける
   - PRの作成/更新に成功した場合
     - Issueのステータスを `In Review` に更新する
     - worktree を破棄する

進捗報告
- 下記に示す契機で、進捗状況を Issue へコメント投稿すること.
  - 使用コマンド: 
    - `gh issue comment $ISSUE_NUMBER --body "..."` 
    - `gh issue comment $ISSUE-NUMBER --attach "..."`
- 契機/内容:　
  - 実装計画開始時 / 作業対象ブランチ名を含めること
  - 実装計画決定時
  - 実装中(主要なフェーズや大きな変更の区切りごと)
  - UI変更を伴う場合、スクリーンショット等の画像を添付すること
  - PR作成時 / PRのリンクを含めること.

例外・未完了時の対応
- エラーや不明点により処理を途中で完了できなかった場合は、発生した問題、現在の進捗状況、および中断理由を必ず `gh issue comment` で追記してください。

