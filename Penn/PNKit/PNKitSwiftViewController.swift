//
//  PNKitSwiftViewController.swift
//  Penn
//
//  Created by SanRong on 2017/12/5.
//  Copyright © 2017年 SanRong. All rights reserved.
//

import UIKit

class PNKitSwiftViewController: BaseViewController {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var tv1: UITextView!
    @IBOutlet weak var tv2: UITextView!
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///注册键盘监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeFrame),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {        
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 键盘与toolBar联动
    ///
    /// - Parameter notify: 接收到的键盘的通知
    @objc private func keyboardChangeFrame(notify:  Notification){
        
       guard let rect = (notify.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
        let durTime = (notify.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else{
            return
        }
        //负值
        let offset = -view.bounds.height + rect.origin.y
        toolBarBottomCons.constant = offset
        
        UIView.animate(withDuration: durTime) {
            self.view.layoutIfNeeded()
        }
        
    }

}
