# UIViewController methods
UIViewControllerのメソッドの実行タイミングと使い方まとめ

## viewDidLoad
- 実行タイミング
  - インスタンス化された直後
- 使い方
  - View Controllerに必要な追加設定を記述する

## viewWillAppear
- 実行タイミング
  - ビューコントローラのコンテンツビューがアプリケーションのビュー階層に追加される直前（画面が表示される直前）
- 使い方
  - コンテンツビューが画面上に表示される前に発生する必要のある操作をトリガーする

## viewDidAppear
- 実行タイミング
  - ビューコントローラのコンテンツビューがアプリケーションのビュー階層に追加された直後（画面が表示された直後）
- 使い方
  - データの取得やアニメーションの表示など、画面上にビューが表示されるとすぐに発生する必要がある操作をトリガーする

## viewWillDisappear
- 実行タイミング
  - 画面が消える直前
- 使い方

## viewDidDisappear
- 実行タイミング
  - 画面が消えた直後
- 使い方
