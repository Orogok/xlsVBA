﻿excel_vba
=========
excelをDBとして利用できるように、vbaを使ってカスタマイズ


テスト用モジュール : verify.bas
----------
これから作成する関数のテスト用モジュール。例えば`clSheet`クラスの`getAllDataAsArray(***) As Boolean`というメソッドをテストする場合、`verify_clSheet_getAllDataAsArray()`というテスト用の関数を作っています。  

ActiveXコントロール操作クラス : clAxCtrl.cls
----------
  * ActiveXコントロールのcheckBoxを指定列に複数配置する。その際checkBoxの値と、配置先のセルの値とリンクさせた状態にする。`putChkBoxesV(***) As Boolean`

Array処理クラス : clDatArr.cls
----------
  * 2次元配列(arrA)を、2次元配列(dat)に追加して返す。`addArray(***) As Boolean`
  * 2次元配列(arr)を、(newRow, newCol)の2次元配列に整形して返す。`formatArray(***) As Boolean`

シートの操作クラス : clSheet.cls
----------
  * 名前を指定してSheetの有無をチェック。`existSheet(***) As Boolean`
  * 名前を指定してSheetを作成。同名のシートが存在した場合その中身を削除する。`initSheet(***)`
  * 名前を指定してSheetを作成。同名のシートが存在した場合、シート名末尾に(#)を付けてカウントアップ。`newSheet(***)`
  * Sheet内のデータ領域をArrayに格納する。`getAllDataAsArray(***) As Boolean`
  * 指定列の最後の行までのデータを取得しArrayに格納。`getColDataAsArray(***) As Boolean`
  * 指定した文字が、指定列に存在した場合、その行を取得しArrayに格納。`getRowDataVLookUp(***) As Boolean`

シートをまたいだ処理を行うクラス : clSheets.cls
----------
  * 複数シートの中のデータを結合して、Arrayに格納。`combineSheets(***) As Boolean`
  * 無視するシート名を引数で受け、検索対象Sheetの名前Collectionを作成。`getTargetSheets(***) As Boolean`
  * 指定Sheetの指定列にAutoFilterをかける。`setFiltet(***)`



