//
//  ViewController.swift
//  Calculator_prac
//
//  Created by Kyus'lee on 2022/08/03.
//

import UIKit


// Groupを分けて、見やすい(均等なUIを表示させたい場合)UIを表示させたいとき、まず最初にUIViewで括ってから、中にobjectを配置するとより調整しやすくなる (方法1)

// UIViewの上に、buttonを載せて、均等な位置配置を行いたいbuttonをstackViewでくくる

// ⚠️Error1: デバイスごとに、buttonの形が異なってしまう。
// MARK: Probably at least one of the constraints in the following list is one you don't want. Try this: エラーが生じた
// ✍️理由: iPhoneの縦軸が長くなるほど、buttonも自動的に伸びる必要があるのに、iPhoneの縦軸が長くなる分、buttonが占める空間が足りなくなるからである。
// 🌈 Solution: 空いてる空間、間隔をオブジェクトごとに、少しだけ使用するとかの各自の設定をする必要がある。
// -> UIViewの Priorityを設定する 1000 -> 750に変更 ---> エラーなくなった！

// ⚠️Error2: Error1でbuttonが集まっているUIViewのpriorityを750に上げると、Labelのheightが設定値よりだいぶ小さくなるデバイスがあった。
// ✍️理由: 下のUIViewのpriorityを上げたため、UIViewの配置を優先的に行い、他の配置をする流れになるから、labelの配置はUIViewの配置に後、残っている画面の空間上で配置されるからだ。
// 🌈 Solution: Labelのheightを固定するのではなく、heightの設定をし、 >= ,<= などのconstraintsを入れることで、設定した最小のheight値 ~ 最大のheight値の範囲で、デバイスの画面のsizeに合わせて配置されるようになる
// -> UIViewの Priorityを設定する 1000 -> 750に変更


class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    
    // Refactoring: Custom Button　Modelを作って、適応すること
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // labelの場合: cornerRadiusがそのまま反映されない
        // masksToBoundを用いて、trueにする
        // ただし、オブジェクトによっては、masksToBoundsの設定をしなくても、勝手に反映されるものがある (代表的例: Button)
        // masksToBounds: true -> Super (layer)領域外のsub layerにはdrawしないということ
        // つまり、角を丸くする設定(cornerRadius)をしたとき、その丸くしたものが、viewを超えてdrawしないように、最初に設定したサイズ(width, heightなど)の内で、丸くdrawするようにする
        
        // falseがdefault値
        // clipsToBoundsも同じ機能である
        // ただし、masksToBoundsは、CAlayerのpropertyであり、clipsToBoundsは UIViewのpropertyであるだけ
        
        // どっちを使っても同じ結果になるが、コードの統一性のため、layerを使う masksToBoundsを用いた
        resultLabel.text = ""
        resultLabel.layer.cornerRadius = 50
        resultLabel.layer.masksToBounds = true
//        resultLabel.clipsToBounds = true
        // MARK: ⚠️button Text 配置Error
        // ✍️理由: buttonごとにlayoutデザインが定められていない状態であるのに、textを変更しようとしたから、buttonとUIViewの配置がおかしくなる。
        //🌈 Solution: オブジェクトの要素が画面上(memory上)に載せられた後の画面表示を行うlife Cycle メソッド viewDidAppearでコードを作成すると解決できる
        //
//        buttonTextSetting()
        
        // 円を実現する方法
        // ⚠️Error: これだと、正常な円ではなく、少し縦が長い円になる
        // ✍️理由: viewDidLoad()は、あくまで、画面が描かれる前の状態で実行されるメソッドである。現在使った複数のbuttonの表示方法は、stackViewを用いて、spacingなどを調整して、自ら計算を行い、buttonを表示している。その計算の対象基準となるのは、画面の大きさ（デバイスごとに異なる）である。つまり、それぞれの画面の大きさ合わせた割合で、stackviewの計算とbuttonの配置が行われる。よって、直接それぞれのobjectのサイズを指定してないんだったら、画面が表示される前には、求める通りの形を表示してくれない。 ----> ❗️viewDidAppear()である
        // 🌈Solution: 画面が全部表示された後に実行されるlify cycleメソッドであるviewDidAppear()を用いて、正常な円を表示しましょう。
//        btn1.layer.cornerRadius = btn1.bounds.width / 2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buttonLayoutDesign()
        buttonTextSetting()
    }
    
    // buttonごとの数字をlabel textに表せる
    // ⚠️Error: すでにIBActionで連動させたやつは、comment outすると crashになってしまう
    
    // buttonを押すと、labelのtextに表示される
    @IBAction func buttonAction(_ sender: UIButton) {
        guard let buttonText = sender.title(for: .normal) else {
            return
        }
        // 一回だけの計算は可能であるlogic
        // "="を再び押すと、resetされるlogic
        if buttonText == "=" {
            if let hasLabelText = resultLabel.text {
                if hasLabelText.contains("+") && !hasLabelText.contains("=") {
                    if hasLabelText.first != "+" && hasLabelText.last != "+" {
                        let splitText = hasLabelText.split(separator: "+").map { Int(String($0))! }
                        let addResult = splitText.reduce(0, +)
                        resultLabel.text! += buttonText + String(addResult)
                    }
                } else if hasLabelText.contains("=") {
                    resultLabel.text! = ""
                }
            } else {
                return
            }

        } else {
            // 数字と + の場合
            resultLabel.text! += buttonText
        }
        
        // + = のようなtextは数字じゃなく、演算の結果を表す記号なので、分ける必要がある
    }

    func buttonLayoutDesign() {
        // ❗️縦と横が同値である円を表示するためには、cornerRadiusを設定する前の、rectが正方形でないと、width / 2をしても求める円にはならない
        btn1.layer.cornerRadius = btn1.bounds.width / 2
        btn2.layer.cornerRadius = btn2.bounds.width / 2
        btn3.layer.cornerRadius = btn3.bounds.width / 2
        btn4.layer.cornerRadius = btn4.bounds.width / 2
        btn5.layer.cornerRadius = btn5.bounds.width / 2
        btn6.layer.cornerRadius = btn6.bounds.width / 2
        btn7.layer.cornerRadius = btn7.bounds.width / 2
        btn8.layer.cornerRadius = btn8.bounds.width / 2
        btn9.layer.cornerRadius = btn9.bounds.width / 2
        btn10.layer.cornerRadius = btn10.bounds.height / 2
        btn11.layer.cornerRadius = btn11.bounds.width / 2
    }
    
    func buttonTextSetting() {
        btn1.setTitle("1", for: .normal)
        btn2.setTitle("2", for: .normal)
        btn3.setTitle("3", for: .normal)
        btn4.setTitle("4", for: .normal)
        btn5.setTitle("5", for: .normal)
        btn6.setTitle("6", for: .normal)
        btn7.setTitle("7", for: .normal)
        btn8.setTitle("8", for: .normal)
        btn9.setTitle("9", for: .normal)
        btn10.setTitle("+", for: .normal)
        btn11.setTitle("=", for: .normal)
    }
    
    


}

