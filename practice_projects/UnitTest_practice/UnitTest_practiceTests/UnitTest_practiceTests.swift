//
//  UnitTest_practiceTests.swift
//  UnitTest_practiceTests
//
//  Created by Kyus'lee on 2022/07/07.
//

import XCTest
@testable import UnitTest_practice

// XCTest: Unit Testに関するものを提供するフレームワーク
// XCTestCase: Testクラス、Testメソッドなどを定義するクラス
// Unit Test コードのメリット:
// 1. コード変更に変更によるDebuggingを早くさせる
// 2. Unit Testを信じて、Refactoringを便利に行い、Refactoring後 Unit Testで再検証可能となる
// ❗️しかし、最初からModuleを分けながらコードを書いていない状態だと、既に作成したコードを最初からコードの機能ごとにModuleを分ける必要がある

class UnitTest_practiceTests: XCTestCase {

    override func setUpWithError() throws {
        // MARK: 🎖初期化コードを作成するメソッド。
        // クラスのそれぞれのテスト関数が呼び出される前に、先に呼び出される間数
    }

    override func tearDownWithError() throws {
        // MARK: 🎖解除コードを作成するメソッド。
        // それぞれのテスト間数が呼び出された後に、呼び出される間数
    }

    func testExample() throws {
        // MARK: 🎖テストケースを作成するメソッド。
        // テストが正しく結果を生成しているかどうかを確認する間数
    }

    func testPerformanceExample() throws {
        // MARK: 🎖性能のテストケースを作成するメソッド。
        // 時間を測定するコードを作成する関数である
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEven() {
        // 1. given: テストに必要な値を生成する
        let number = Even(number: 2022)
        
        // 2. when: テストするコードを実行する
        
        // 3. then: テスト結果を出力する
        XCTAssertTrue(number.isEven, "偶数のとき: True, 奇数のとき: False　だよ！") // 偶数: True, 奇数: False
    }
    
    // メソッド名が書かれている行(Line)の左の方に、ひし形がある
    // テストが成功的に行われたら -> 緑色とチェック 表示される
    // テストが失敗したら -> 赤色とバツ(X) 表示される

}
