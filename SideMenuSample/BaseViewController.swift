//
//  BaseViewController.swift
//  SideMenuSample
//
//  Created by 鈴木友也 on 2019/07/15.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var sideMenuView: UIView!
    
    var sideMenuStatus: SideMenuStatus = .closed
    
    var touchesBeganPositionX: CGFloat!
    
    /*
     
     まずは「画面左端をスライドするとSideMenuが表示されるという状態」を目指す。
     この状態に持っていくためには
     1. UIScreenEdgePanGestureRecognizerによるタップの検出
     2. タップ状態によって実現する処理の実装
     が必要。
     
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftEdgesGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgesTapGesture(sender:)))
        leftEdgesGesture.edges = .left
        
        baseView.addGestureRecognizer(leftEdgesGesture)
        
        baseView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        sideMenuView.frame = CGRect(x: -260, y: 0, width: 260, height: UIScreen.main.bounds.height)
    }
    
    
    // 左端のタップが検出された時の処理
    @objc private func edgesTapGesture(sender: UIScreenEdgePanGestureRecognizer) {
        sideMenuView.isUserInteractionEnabled = false
        baseView.isUserInteractionEnabled = false
        
        let move: CGPoint = sender.translation(in: baseView)
        
        baseView.frame.origin.x += move.x
        sideMenuView.frame.origin.x += move.x
        
        baseView.alpha = baseView.frame.origin.x / 260 * 0.36
        
        // メインコンテンツのx座標が0〜260の間に収まるように補正
        if baseView.frame.origin.x > 260 {
            baseView.frame.origin.x = 260
        } else if baseView.frame.origin.x < 0 {
            baseView.frame.origin.x = 0
        }
        
        if sender.state == UIGestureRecognizer.State.ended {
            if baseView.frame.origin.x < 160 {
                changeSideMenuState(status: .closed)
            } else {
                changeSideMenuState(status: .open)
            }
        }
        
        // 移動量をリセットする
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    private func changeSideMenuState(status: SideMenuStatus) {
        if status == .open {
            sideMenuStatus = status
            openSideMenu()
        } else if status == .closed {
            sideMenuStatus = status
            closeSideMenu()
        }
    }
    
    private func openSideMenu() {
        self.sideMenuView.isUserInteractionEnabled = true
        self.baseView.isUserInteractionEnabled = false
        
        // UIView.animate { ..... } の部分がサイドメニューを表示するロジック + アニメーション
        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut], animations: {
            
            // 実際に変更しているのはxの部分だけ
            self.baseView.frame = CGRect(
                x: 260,
                y: self.baseView.frame.origin.y,
                width: self.baseView.frame.width,
                height: self.baseView.frame.height)
            
        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut], animations: {
            
            // 実際に変更しているのはxの部分だけ
            self.sideMenuView.frame = CGRect(
                x: 0,
                y: self.sideMenuView.frame.origin.y,
                width: self.sideMenuView.frame.width,
                height: self.sideMenuView.frame.height)
            
        }, completion: nil)
    }
    
    private func closeSideMenu() {
        self.sideMenuView.isUserInteractionEnabled = false
        self.baseView.isUserInteractionEnabled = true
        
        // UIView.animate { ..... } の部分がサイドメニューを表示するロジック + アニメーション
        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut], animations: {
            
            // 実際に変更しているのはxの部分だけ
            self.baseView.frame = CGRect(
                x: 0,
                y: self.baseView.frame.origin.y,
                width: self.baseView.frame.width,
                height: self.baseView.frame.height)
            
        }, completion: nil)
        
        // UIView.animate { ..... } の部分がサイドメニューを表示するロジック + アニメーション
        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut], animations: {
            
            // 実際に変更しているのはxの部分だけ
            self.sideMenuView.frame = CGRect(
                x: -260,
                y: self.sideMenuView.frame.origin.y,
                width: self.sideMenuView.frame.width,
                height: self.sideMenuView.frame.height)
            
        }, completion: nil)
        
    }
    
    /*
     
     以降では、サイドメニュー画面が表示されている状態のタップ位置を検知し、適切な処理を記述する
     【タップ開始時】
     ・タップ位置を検出する
     ・タップ開始時のbaseViewの位置を検出
     【タップ中】
     ・タップ位置がサイドメニューの幅より大きければサイドメニューを動かせるようにする
     【タップ終了時】
     ・タップ終了時の位置によってサイドメニューの開閉をコントロールする
     
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touchEvent = touches.first!
        
        let beginPosition = touchEvent.previousLocation(in: self.view)
        touchesBeganPositionX = beginPosition.x
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if sideMenuStatus == .open, touchesBeganPositionX >= 260 {
            
            baseView.isUserInteractionEnabled = false
            sideMenuView.isUserInteractionEnabled = false
            
            let touchEvent = touches.first!
            
            // ドラッグ前の座標
            let preDx = touchEvent.previousLocation(in: self.view).x
            
            // ドラッグ後の座標
            let newDx = touchEvent.location(in: self.view).x
            
            // ドラッグしたx座標の移動距離
            let dx = newDx - preDx
            // 移動距離を反映
            baseView.frame.origin.x += dx
            sideMenuView.frame.origin.x += dx
            
            // メインコンテンツのx座標が0〜260の間に収まるように補正
            if baseView.frame.origin.x > 260 {
                baseView.frame.origin.x = 260
            } else if baseView.frame.origin.x < 0 {
                baseView.frame.origin.x = 0
            }
            
            baseView.alpha = baseView.frame.origin.x / 260 * 0.36
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // 1. タップ開始時点のX軸座標がサイドメニューの幅以上かつbaseViewのX軸座標が260の時（＝ 画面が開いていて、サイドメニューの外をタップした時）、またはタップ終了時のX軸座標が160未満の場合は画面を閉じる
        // 2. タップ開始時点のX軸座標がサイドメニューの幅以上かつ、タップが終了した時点でのX軸座標が160以上の場合は画面を開く
        if touchesBeganPositionX >= 260 && (baseView.frame.origin.x == 260 || baseView.frame.origin.x < 160) {
            changeSideMenuState(status: .closed)
        } else if  touchesBeganPositionX >= 260 && baseView.frame.origin.x >= 160 {
            changeSideMenuState(status: .open)
        }
    }
}
