//
//  ViewController.swift
//  PanGestureApp
//
//  Created by Kyus'lee on 2022/06/23.
//

//Segmented Controlを追加

import UIKit

enum DragType {
    case x
    case y
    case none //x,y軸全部動かせるdragtype指定
}

class ViewController: UIViewController {

    var dragType = DragType.none
    //直接コードの記入を通して作ったviewは、initializerを通して実行されるんだが、
    let myView = DraggableView() //ここの変数に適応する必要があるので、全域変数として設けた
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.center = self.view.center
        //基本の大きさを設定する
        //上でcenterにしたから、x,yは設定しなくていい
        myView.bounds = CGRect(x: 0, y:0, width: 100, height: 100)
        myView.dragType = .x
        myView.backgroundColor = .red
        
        //addSubview: 今の画面に載せる
        self.view.addSubview(myView)
        
        
    }

    @IBAction func selectPanType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dragType = .x
            
        case 1:
            dragType = .y
            
        case 2:
            dragType = .none
            
        default:
            break
        }
        
        // VCのSegmentedControlを通して、選択したtypeをmyView(DraggableView)にも適応させるlogic
        myView.dragType = self.dragType
        
    }
    

}

