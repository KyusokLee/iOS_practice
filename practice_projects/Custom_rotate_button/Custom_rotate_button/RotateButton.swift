//
//  RotateButton.swift
//  Custom_rotate_button
//
//  Created by Kyus'lee on 2022/07/17.
//

import UIKit

//MARK: ⚠️ init(frame: CGRect), init(coder: NSCoder)の違い
// 📚init(frame: CGRect)
// -> コードで UIView Classの view インスタンスを作るために指定されたinitializer
// -> つまり、Storyboard や nibファイルのような　インタフェースビルダーを使わずに、コードでオブジェクトを作るためのinit
// 機能: frame rectangleを用いて、実装しようとするviewの中心と境界線を指定してくれる

// 📚init(coder: NSCoder)
// -> 基本的に storyboardやnibを用いると、別途のコードなして、アプリの属性を修正することが可能である。これを可能とする過程を unarchivingという
// interface builderは、コードじゃないため、アプリをコンパイルする時点でコンパイラがこれを認識することができず、それをコードで変換してくれる unarchiving過程が必要であるからだ。
// このunarchiving過程で、init(coder: NSCoder)が使用される。
// ✍️仕様:
// coder パラメータを通して、NSCoder型のオブジェクトが渡され、渡されたNSCoder型のオブジェクトがdecodingで初期化された後、コンパイル可能となったdecodingされた自分自身(self)を返す

// 構成されたViewの状態をアプリのdiskに保存する過程を serializeという。
// deserialize: diskに保存された状態を読み込む作業
// NSCodingというプロトコルを通して、この　serialize　と deserialize作業が可能となるのである。

// UIViewの宣言部分を見てみると、NSCodingプロトコルを採択している。
// また、NSCodingプロトコルの宣言部分をよくみると、失敗可能なinitializerを作成するようになっている。
// あるProtocolを遵守するクラスで、プロトコルが要求するinitializerの要求事項を実装するためには、require　キーワードを付けなければならない。

// ‼️そのため、NSCodingプロトコルを遵守する UIView, UIButtonなどのクラスを継承するCustomViewのようなクラスでは、Storyboardを使っていないとしても..
// -> init?(coder: )を作成し、また、その先頭に必ず requiredをつけないといけない

//// MARK: convenience init()の理解
//class Person {
//    var name: String
//    var age: Int
//    var gender: String
//
//    init(name: String, age: Int, gender: String) {
//        self.name = name
//        self.age = age
//        self.gender = gender
//    }
//
//    // このように、パラメータで渡さなかったもの(name)は、任意で指定し、パラメータで渡したもののみ入れたらいい
//    convenience init(age: Int, gender: String) {
//        self.init(name: "Kyulee", age: age, gender: gender)
//    }
//
//    // 他のconvenience initを通して、インスタンスを初期化することが可能
//    convenience init() {
//        self.init(age: 1, gender: "Boy")
////        // 下記のコードのような initializerはこのクラスに存在しないため、当然 Errorになる
////        self.init(name: "KYULEE")
//    }
//}

//class MyButton {
//    // convenience init()は、必ずそのクラス内の他のinitを呼び出さなきゃいけない
//    convenience init() {
//        self.init(frame: CGRect.zero)
//    }
//    // designated init(指定するinitializer)
//    // クラス内の全てのインスタンスの保存プロパティの値を初期化(割り当て)
//    init(frame: CGRect) {
//
//    }
//
//    required init(coder: NSCoder) {
//
//    }
//}
//
//class CustonButton: MyButton {
//    // ここでのinitは、親クラスのconvenience init()を指すもの
//    // 親クラスのconvenience init()を見てみると、そのクラス内のinit(frame:CGRect)を指定してることがわかる
//    // そのため、子クラスであるここでも、親クラスの init()を書く必要がある -> super.init()
//    init() {
//        super.init(frame: .zero)
//    }
//
//    // 親クラスでrequired　initを作成したから
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


// status値の設定
enum RotateType {
    case up
    case down
}

// MARK: UIButtonのクラスも、上記のようにconvenience initが設定されていると考えるといい
// finalをつけると、そのクラスを継承できなくなる
// Custom Button 生成
class RotateButton: UIButton {
    // RotateButtonのインスタンスを生成して、使おうとするとき、必ずconfigure()間数が呼び出されるようにする
    // initializer 生成
    init() {
        super.init(frame: CGRect.zero)
        configure()
    }
    
//    // frameを持つinitを使うときは、overrideでいい
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    // Storyboard または、nib ファイルで設定したとき
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var isUp = RotateType.down {
        //isUpという値に依存的なコードであれば、このような書き方でもあり
        // isUpという変数の値が設定されたら didSet以下を実行
        didSet {
            changeDesign()
        }
    }
    
    // クリックするたびに、行うイベントを設定したい
    // 普通は、closureを用いてコードを作成する
    var selectTypeCallback: ((RotateType) -> Void)?
    
    // private にした理由: 外部では、このボタンの設定に関する configure間数と、ボタンをクリックしたというselectButton()間数を知る必要がない
    // また、コード作成時、自動完成ででて来ることを防ぐ
    // クリックしたという概念をコード上で保たせる
    //❗️: RotateButtonクラスのインスタンスを使う際に、必ずconfigure()が呼び出すようにする
    // -> 理由: configure()間数は、誰かが呼び出ししてくれないと、永遠に実行されないから
    private func configure() {
        self.layer.cornerRadius = 15
        
        // touchUpInside: クリックしておいたとき -> つまり、クリックしたとたんに動くわけじゃなく、クリックしておいたときってこと
        self.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
        
    }
    
    @objc private func selectButton() {
        if isUp == .up {
            isUp = .down
        } else {
            isUp = .up
        }
        // isUpという変数自体に依存性を与える
//        changeDesign()
        selectTypeCallback?(isUp)
        
    }
    
    
    
    // 180度回るようなボタン
    private func changeDesign() {
        // すぐ変わるようなアニメーション効果じゃなく、customアニメーション効果を与えたい場合
        UIView.animate(withDuration: 0.25) {
            // up状態のとき
            if self.isUp == .up {
                self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                // backgroundColor?.withAlphaComponent: 背景色の透明度調整
                // (0.3): 70％を透明にさせ、30％だけが表示される
                // (1): 元の背景色
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.3)
            } else {
                // identity: transform(変更を与える)をしていない元の状態に戻る設定
                self.imageView?.transform = .identity
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(1)
            }
        }
    }
}
