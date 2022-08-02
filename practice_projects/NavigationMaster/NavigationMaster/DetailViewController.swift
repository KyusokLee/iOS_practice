//
//  DetailViewController.swift
//  NavigationMaster
//
//  Created by Kyus'lee on 2022/07/31.
//

import UIKit

class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // withAlphaComponentの値の設定で、透明度を調節可能
        self.navigationController?.navigationBar.backgroundColor = .yellow.withAlphaComponent(0.3)
        
        
        self.statusBar?.backgroundColor = .yellow.withAlphaComponent(0.3)
        
        
    }
    

    

}

extension UIViewController {
    
    var statusBar: UIView? {
        // status bar design
        // SceneDelegateへのアクセス方法
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        
        // 色の設定は、使用しているところで、各自設定する
//        sceneDelegate?.statusBarView.backgroundColor = .red
        
        // 画面に載せるのではなく,windowに載せる理由: どんな画面でも同じstatus barが見えるように設定したい
        // windowはそのようなものである
    //        sceneDelegate?.statusBarView
        
     
        
        
        //🌈考察:なぜ、first?の指定が必要なのか？
        // -> connectedScenesは、現在のアプリが連動しているすべてのsceneを管理している。
        // そのなかで、firstをすることで、最初のsceneとのつながりである、SceneDelegateへアクセスできるようになるのだ。
        // TypeCastingは必修
        // そのため、UIWindowScene.windowsを使わないといけない
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        // ios15からは、UIApplication.sharedの 'windows'はdeprecatedされた。
    //        let window = UIApplication.shared.windows.filter{ $0.isKeyWindow }.first
        
        if let hasStatusBar = sceneDelegate?.statusBarView {
            // 現在のviewだけに反映される
    //            self.view.addSubview(hasStatusBar)
            window?.addSubview(hasStatusBar)
        }
        
        return sceneDelegate?.statusBarView
    }
}
