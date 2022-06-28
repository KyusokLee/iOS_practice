//
//  OnboardingPageViewController.swift
//  OnboardingViewApp
//
//  Created by Kyus'lee on 2022/06/24.
//

import UIKit

//xibファイルなしの、純粋にコードだけで再現するもの
class OnboardingPageViewController: UIPageViewController {

    //複数のページを格納できるArrayが必要
    // UIViewController　Typeの配列
    var pages = [UIViewController]()
    
    //下に表示させるボタンのconstraintに関する値を記憶させるためのインスタンス
    //
    //値がないかもしれないので、Optional 値にした
    var bottomButtonMargin: NSLayoutConstraint?
    
    //現在のpageがどの何番目のpageであるかを、視覚的に提供するUI
    //  アプリなどでよく見る ...のUIでpageが次のpageになっていることをユーザがわかるようにしたい
    var pageControl = UIPageControl()
    //最初のpageControlの位置　setting
    let startIndex = 0
    //現在のpageindexを、記憶させる。何かの処理をしたい場合に効果的
    var currentIndex = 0 {
        // didSet: 値を受け取る度にdidSet中のコードが実行される
        didSet {
            pageControl.currentPage = currentIndex
        }
    }
    
    func makePageVC() {
        // Class インスタンスを生成
        let itemVC1 = OnboardingItemViewController.init(nibName: "OnboardingItemViewController", bundle: nil)
        itemVC1.topImage = UIImage(named: "onboarding1")
        itemVC1.mainText = "First Page"
        itemVC1.subText = "This is your first App you've learned how to implement the UIPageViewController and used it. Like this, you will acquire a lot of new knowledge and skills as you proceed with development, and you will use them in many ways. However, each time, you will need a spirit of challenge and persistence to handle and solve the problems that may arise."
        //⬇️このままだと、itemVC1.mainTitleLabel は、nilになる
        // -> Debug (値のCheck)方法: commandに po itemVC1.mainTitleLabelを入力する
        //itemVC1.mainTitleLabel.text = "First Page"
        
        // なぜ？: instanceを生成したとしても、その中のものが(クラスの propertyやメソッド)同時に生成されるわけではない。その理由は、画面と連動されているIBOutlet変数の特性上、画面が生成されてから、中のObjectが生成されるまでは、ほんの少しの時間がかかる.
        // ただの変数let or var だったら、class生成されるとともに変数も生成される
        // それが、viewDidLoad()の間数である
        
        let itemVC2 = OnboardingItemViewController.init(nibName: "OnboardingItemViewController", bundle: nil)
        itemVC2.topImage = UIImage(named: "onboarding2")
        itemVC2.mainText = "Second Page"
        itemVC2.subText = "Are you ready to move forward on this road? If you are, please scroll next page."
        
        
        let itemVC3 = OnboardingItemViewController.init(nibName: "OnboardingItemViewController", bundle: nil)
        itemVC3.topImage = UIImage(named: "onboarding3")
        itemVC3.mainText = "Third Page"
        itemVC3.subText = "Alright! Okay, then, let's start with next step on finding new skills and knowledges to make creative and innovative App of your own."
        

        pages.append(itemVC1)
        pages.append(itemVC2)
        pages.append(itemVC3)
        
        //基本のPage値をSettingする必要がある
        //❗️つまり、Start　PageのSettingをする必要があるということ
        //VCはArray Type
        // direction: .forward -> 次の方にnavigation方向設定される
        
        //❗️現在見れるVC画面は、Arrayの中にある現在見ているVC 1つになる
        // ここでは、itemVC1が現在見ているVCとなる
        // 下記のコードを用いて、現在の画面が何番目の画面であるかを確認し、アクセスできるのである
        // 配列の方のparameterは, viewControllersになっている
        // 🌱表示されるべきのPageをSettingするメソッド
        setViewControllers([itemVC1], direction: .forward, animated: true)
        //PageViewControllerもtableViewControllerと同様に必ず処理しておかないといけない動作Processがある
        // TableViewControllerで、rowとか sectionのような処理が必ず必要であったのと同じ概念で、複数のpageを繋げる必要がある
        
        //dataSource: viewControllerを提供するObject
        self.dataSource =  self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.makePageVC()
        self.makeBottomButton()
        self.makePageControl()
    }
    
    //xibファイルを利用せずに、作ったクラスなので、Buttonの再現もコードで行うしかない
    func makeBottomButton() {
        let button = UIButton()
        // for: 状態をチェック
        // .normal: 基本の状態に表示されるボタン
        button.setTitle("確認", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        
        //buttonを押すときのEventと連結させる
        // for: eventの設定
        // buttonは 大体touchUpInsideが普段使われる
        // touchUpInside: buttonを押しておくEvent　（クリック）
        button.addTarget(self, action: #selector(dismissPageView), for: .touchUpInside)
        self.view.addSubview(button)
        
        //Auto Layoutを適用したいなら、translateAutoresizingMaskIntoConstraints をfalseにしなくてはならない
        button.translatesAutoresizingMaskIntoConstraints = false
        // コードでlayoutを設定する方法
        // bottomAnchor: UIViewの下部線
        // constraint: Layoutの制約を与える
        // equalTo: どこを基準にするのかを指定
        // constant: 数値の設定
        // isActive: オブジェクトを返すのに該当オブジェクトがActive状態にならないと制約条件が反映されないため、isActiveをtrueにしておく必要がある。
        
        //constant設定したくない場合は、constantなしでもよい
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        // buttonの高さの設定
        // 基準点を設定せず、ただの数値だけ与えたいなら equalToConstantでいい
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // bottomAnchorが基準であるため、constantを マイナス数値を入れないとview上に表示されない
        // safeAreaがあるdeviceの場合は、self.view.safeAreaLayoutGuideを基準にするのをおすすめする
        
        //MARK: ボタンのHIDE and Appear機能の実装
        //❗️ここで、ボタンをsafeAreaの外に置きたい場合、ボタンのbottomAnchorのconstraintを viewよりもしたに置く必要がある。そのため、constantを 100にした.
        // ⁉️しかし、いちいち変更させるのは、効率的でないし、また、コードも長くなるので、状況に応じて、変わるようなlogicを設ける必要がある
        //button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 100).isActive = true
        // 下記のコードだけを状況に応じて、変更したい場合、ここだけを記憶させるインスタンスが全域であればいいじゃん？という話
        // ✍️ 上記のbottomButtonMarginで記憶させる
        // instanceに記憶させたいときは、isActive設定は書いてはいけない
        bottomButtonMargin = button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomButtonMargin?.isActive = true
        //最初も隠さないといけないから hideButton（）実行
        hideButton()
    }
    
    func makePageControl() {
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        //現在のpageを表すときの、tintcolor
        pageControl.currentPageIndicatorTintColor = .black
        //それ以外のときの基本tintcolor
        pageControl.pageIndicatorTintColor = .lightGray
        //pageの数ほど、　.のUIを表示させる
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = startIndex
        pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        // ✍️PageControlには、その.をクリックして、当てはまるpageに移動するようなEventがある
//        // 🌱クリックによるpage移動を不可能とする:
//        //isUserInteractionEnabled = false にする
//        // 全てのtouchに関するeventは通じないようにするということ
//        pageControl.isUserInteractionEnabled = false
//
        // 🌱クリックによるpage移動を可能とする:
        // addTargetを用いて、event連結する
        // valueChanged: 値が変わることに応じて、eventを起こす
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)

    }
    
    @objc func pageControlTapped(sender: UIPageControl) {
        // pageControlのtap（クリック）によるpage移動イベント間数
        //sender.currentPage = tapしたページ
        //currentIndex = 今のページ
        
        if sender.currentPage > currentIndex {
            setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        } else {
            // forward: 左から右に移動するanimation
            setViewControllers([pages[sender.currentPage]], direction: .reverse, animated: true, completion: nil)
        }
        
        currentIndex = sender.currentPage
        buttonPresentation()
    }
    
    @objc func dismissPageView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//⁉️考察: 次のページにいくときに、紙をめくるような Animationが実現される -> これをなくすためには？

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    //前のページに関連するメソッド
    //⭐️現在のPageから以前のPageに移動するとき、前のPageを返す(移動する)メソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //現在のVCのindexを調べる
        // index値を持ってくることができなかった場合は、nilを返すように設定しておいた
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        self.currentIndex = currentIndex
        
        if currentIndex == 0 {
            // 最初のPageだったら、繋がっている一番最後のPageに移動するようにする
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
        
        // 前のPageがないなら?
        // return nil
    }
    
    //後のページに関連するメソッド
    //⭐️現在のPageから後のPageに移動するとき、後のPageを返す(移動する)メソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        self.currentIndex = currentIndex
        //最後のページである場合
        if currentIndex == pages.count - 1 {
            // Optionalを返すから、Unwrapping 必要なし
            return pages.first
        } else {
            return pages[currentIndex + 1]
        }
    }
    
}

// ❗️現在のPageがどこかを知らせるものが必要
// delegateを用いればいい
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
    //didFinishAnimatingは、画面が次の画面に移動して、その移動の動きがぴったりと止まるその時点を指す
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // first = 最初の画面
        guard let currentVC = pageViewController.viewControllers?.first else {
            return
        }
        
        guard let currentIndex = pages.firstIndex(of: currentVC) else {
            return
        }
        
        self.currentIndex = currentIndex
        buttonPresentation()
    }
    
    //同じコードを書くことを防ぐために、使い回しが可能なfuncを作る
    func buttonPresentation() {
        if currentIndex == pages.count - 1 {
            // Show Button
//            bottomButtonMargin?.constant = -50
            self.showButton()
        } else {
            // Hide Button
            // logic: Buttonが画面の外にいるような設定をすれば、画面で見えないように実装ができる
            // 画面の外にちゃんと出ているのかを上手く確認したいときは、⬇️
            // debug view hierarchyをおして、show clipped contentを見ればいい
            //数値を直接書くようなコーディングは、一目ですぐ把握できない
//            bottomButtonMargin?.constant = 100
            self.hideButton()
        }
        
//        //自然なanimation効果を与えたい場合
//        // 方法1
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
        
        // 方法2: 方法1と同様の内容 (Positionの内容の操作ができる)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showButton() {
        bottomButtonMargin?.constant = -50
    }
    
    func hideButton() {
        bottomButtonMargin?.constant = 100
    }
    
    
}
