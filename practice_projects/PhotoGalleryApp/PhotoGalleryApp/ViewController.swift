//
//  ViewController.swift
//  PhotoGalleryApp
//
//  Created by Kyus'lee on 2022/06/28.
//

import UIKit
import PhotosUI //photogalleryを表示させるPHPickerメソッドを使うためのframeWork
// しかし、PHPickerはios14以上から適応可能となる

//MARK: NavigationController基盤に作る PhotoGalleryApp

class ViewController: UIViewController {

    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo Gallery App"
        makeNavigationItem()
        
        //GridはViewを構成する際に、使われる仮想の格子状の案内線を意味する。
        //🌱 UICollectionViewFlowLayout():
        // Grid内で各組織的アイテムの各セクションのための、ヘッダーとフッターviewの Layout Objectである。
        // このクラスのLayout方式は、現在の行から埋めていくが、objectのスペースが足りなかったら、新たな行を生成して、それにCellを追加する方式である。
        // 言葉の通り, flow (流れ)を連想すればいいかも⁉️
        
        
        let layout = UICollectionViewFlowLayout()
        // CGSize: widthとheightの値を持つStructure
        //✍️それぞれのitem(cell)のサイズを決める
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 1) / 2, height: 200)
        
        //🌱隙間スペースの設定
        // ❗️ただし、上の行と下の行のspaceの値を設定するものではない
        layout.minimumInteritemSpacing = 1
        // 行と行の間のspaceの値を設定
        layout.minimumLineSpacing = 1
        
        
        //collectionViewLayout: collectionViewのアイテム(cell)を構成するときに使われるlayoutを指す
        // layoutの設定
        photoCollectionView.collectionViewLayout = layout
        
        photoCollectionView.dataSource = self
        
        
        
    }
    
    func makeNavigationItem() {
        //Custom BarButton生成: imageを載せて作るbuttonItem
        let photoItem = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle"), style: .done, target: self, action: #selector(checkPermission))
        
        // withAlpthComponent: 色の濃度を決める
        photoItem.tintColor = .black.withAlphaComponent(0.7)
        
        self.navigationItem.rightBarButtonItem = photoItem
        //複数ある場合は: rightBarButtonItems
        
        let refreshItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(refresh))
        refreshItem.tintColor = .black.withAlphaComponent(0.7)
        self.navigationItem.leftBarButtonItem = refreshItem
    }
    
    //🔥写真にアクセスするための権限の許可の設定が必要
    // photoItem　ボタンを押すと、なんの許可なしでshowGallery間数を呼び出しgalleryにアクセスするのでなく、Permission(許可)があったときのみ、アクセスできるようにしたい
    // そのため、下記のようなlogicが必要である‼️
    
    @objc func checkPermission() {
        //authorizationStatus() : 許可の状態を表す
        // .authorized: 全部許可
        // .limited: 選択的許可
        // .denied: 拒否
        // .notDetermined: まだ、権限許可に関してユーザーに聞いてない状態
        // .restricted: 外部的に制限された状態: 地域の制限とかの -> 普段は、処理logicを書かないようだ
        
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .limited {
            //全部許可の時 または、選択的許可のときだけ、 galleryを表示してもいい!
            // ❗️画面からなんらかのUIが変更されたり、作動される概念は、main threadで行わないといけない
            // そのため、DispatchQueue.main.asyncを用いて、main threadで処理するようにする
            // closureの中では、self省略はできない！
            DispatchQueue.main.async {
                self.showGallery()
            }
            
        } else if PHPhotoLibrary.authorizationStatus() == .denied {
            //許可拒否したとき: ユーザーのデバイスからgalleryアプリのアクセスを　none設定したとき
            DispatchQueue.main.async {
                self.showAuthorizationDeniedAlert()
            }
            
        } else if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            //⭐️notDetermined: まだ、聞いてない状態 -> この処理がとても重要
            // requestAuthorization: ユーザーからの許可を得るrequest発生
            // どんな許可をするかについて、messageの文句を作成する必要がある -> これは、コードではなく、info.plistに追加する
            // info.plistで追加した文句が表示される
            
            PHPhotoLibrary.requestAuthorization { status in
                //再帰的にこのfuncを呼び出すことが効率的
                self.checkPermission()
            }
            
        }
    }
    
    func showAuthorizationDeniedAlert() {
        // 1. alert(アラート)を表示させ、アクセス権限を活性化してね~!という警報を知らせるlogicが必要
        //🌱alertを表示させる
        let alert = UIAlertController(title: "このアプリから写真にアクセスしようとしています。", message: nil, preferredStyle: .alert)
        
        //❗️確認ボタンや設定にいくボタンを設ける
        // 🌱addAction: alertにボタンなどのaction objectを足すメソッド
        // 🌱handler: そのボタンをクリックして次に何をしたいのかの指定
        // style: .cancel -> キャンセルボタンの機能: 基本的にdismissされるため、handlerはnilでいい
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "設定画面へ", style: .default, handler: {
            action in
            
            // urlを外部、または、デバイス内のアプリに設定することができる。
            // openSettingsURLString: 飛設定画面に移動させる
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            // canOperURL: そのURLに飛ぶことができるか否かの確認をするメソッド
            // completionHandler: その先に飛んでから、何かを処理するとき使う
            if UIApplication.shared.canOpenURL(url) {
                // 可能なら
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //ボタンを押すと、galleryを読み込むメソッド
    func showGallery() {
        // 🌱PHPhotoLibrary: ユーザーの写真libraryへのアクセスと変更事項を管理するobject
        // configure: 構成する
        
        let library = PHPhotoLibrary.shared()
        
        // 🌱環境設定に関するobject
        var configuration = PHPickerConfiguration(photoLibrary: library)
        
        // Systemで提供するgalleryの形式を画面に表示させる
        // 🌱albumのimageを選択できる
        // なぜ、configurationを入れる？:
        // -> PHPickerConfigurationには、selectLimitという選択できる写真の枚数の設定ができる有用なものを使うために
        // selectionLimit: 0 -> 無限に可能なこと
        configuration.selectionLimit = 10
        
        
        let picker = PHPickerViewController(configuration: configuration)
        //⚠️権限を渡さなくても、すぐアクセスできるようになっている
        // リリースするとき、注意すべきである
        // simulatorで実行するときは、権限アクセスの許可なしでも行ける
        
        picker.delegate = self
        self.present(picker, animated: true)
        
        
    }
    
    @objc func refresh() {
        
    }


}


extension ViewController: UICollectionViewDataSource {
    
    // cellの数を表すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //sizeに関するメソッド --> 必ずlayoutに関する設定をしなければ、sizeに関する設定ができるわけがない
    // そのため、viedDidLoad()の方で、layoutに関する設定を行う変数を設ける
    
    
    // cellを返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // dequeueReusableCell -> TableView や collectionViewで使われる効率的メモリ管理のためのメソッド
        // ‼️メモリを効率的に管理するため、dequeueReusableCellを使う
        // cellを再使用できるようにする
        // 見える範囲を超えたcellを再利用queueに入れ、また、そのcellが見える範囲にもどったとき(scrollなどをとおして、前の位置にあったものを再び表示させるとき)、dequeueして、そのcellに入れる
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        return cell
    }
    
    
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //didFinishPicking: クリックして選んだものをreturnにする
        
        //cancelやaddは以下のdismissに渡される
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
