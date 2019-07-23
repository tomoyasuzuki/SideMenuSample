//
//  ForthViewController.swift
//  SideMenuSample
//
//  Created by 鈴木友也 on 2019/07/18.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit

class ForthViewController: UIViewController {

    private var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "ForthViewController"
        view.backgroundColor = UIColor.orange
        
        menuButton = UIBarButtonItem(title: "≡", style: .plain, target: self, action: #selector(self.menuButtonTapped(sender:)))
        navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc private func menuButtonTapped(sender: UIBarButtonItem) {
        
        // BaseViewControllerのメソッドを呼び出して左側コンテンツを開く
        // このコントローラーはUINavigationControllerと繋がっているので、「ViewController(親) → UINavigationController(子) → ContentListViewController(孫)」の関係となるので下記のようにたどる
        if let parentViewController = self.parent?.parent {
            let vc = parentViewController as! BaseViewController
            vc.changeSideMenuState(status: .open)
        }
    }
}
