//
//  SideMenuViewController.swift
//  SideMenuSample
//
//  Created by 鈴木友也 on 2019/07/15.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit

protocol SideMenuDelegate: NSObjectProtocol {
    func changeBaseView(buttonType: Int)
}

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var forthButton: UIButton!
    
    weak var delegate: SideMenuDelegate?
    
    /*
     
     第三段階は「サイドメニューに部品を設置し、その部品へのユーザーアクションを元に特定の挙動をする」ということを実現する。
     実際にはサイドメニューから画面遷移させる場合もあると思いますが、今回はあえてベースとなるViewControllerをチェンジする方向でいきます。
     この場合、SideMenuControllerからBaseViewControllerを呼び出す必要があります。
     なぜなら、実際に画面を変更するのはBaseViewControllerだからです。
     これには
     ・protocolによるdelegateメソッドの実装
     が必要になります。
     SideMenuViewControllerではプロトコルに準拠したメソッドをアクションとして指定し、実際の処理はBaseViewControllerへ委譲します。
     ここで個人的に大事だと思うのは「デリゲートメソッド経由でボタンのタイプを渡している」という点です。
     これによってSideMenuViewControllerからBaseViewControllerへボタンタイプを渡すことができ、BaseViewController側でボタンタイプによる
     画面の出し分けが実現します。
     
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstButton.tag = ButtonType.firstButton.rawValue
        secondButton.tag = ButtonType.secondButton.rawValue
        thirdButton.tag = ButtonType.thirdButton.rawValue
        forthButton.tag = ButtonType.forthButton.rawValue
        
        // ボタンタップ時に呼び出すメソッドの内部でデリゲートメソッド（BaseViewControllerで中身を実装するメソッド）を呼び出すことで、
        // 実際の処理をBaseViewControllerに全て任せることができている。
        // ボタンの識別方法は別になんでもいいが、今回は元々のサンプルと同様にオブジェクトにタグをつける形で実装している。
        
        firstButton.addTarget(self, action: #selector(self.sideNavigationButtonTapped(sender:)), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(self.sideNavigationButtonTapped(sender:)), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(self.sideNavigationButtonTapped(sender:)), for: .touchUpInside)
        forthButton.addTarget(self, action: #selector(self.sideNavigationButtonTapped(sender:)), for: .touchUpInside)
        
    }
    
    
    @objc func sideNavigationButtonTapped(sender: UIButton) {
        
        let buttonType: Int = sender.tag
        self.delegate?.changeBaseView(buttonType: buttonType)
    }
}
