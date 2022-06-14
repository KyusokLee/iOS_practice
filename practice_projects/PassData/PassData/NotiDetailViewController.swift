//
//  NotiDetailViewController.swift
//  PassData
//
//  Created by Kyus'lee on 2022/06/15.
//

import UIKit

// Notificationの呼び出しに関するコード
class NotiDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func notiAction(_ sender: Any) {
        let notificationName = Notification.Name("sendSomeString")
        let strDic = ["str" : "noti string"]
        // string型じゃなくてもいい -> userInfoは Any Typeだから
        
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: strDic)
        self.dismiss(animated: true, completion: nil)
    }
    

}
