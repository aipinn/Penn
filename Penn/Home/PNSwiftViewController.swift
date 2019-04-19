//
//  PNSwiftViewController.swift
//  Penn
//
//  Created by PENN on 2017/11/24.
//  Copyright © 2017年 PENN. All rights reserved.
//

import UIKit

class PNSwiftViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swift"
        view.backgroundColor = .white
        
        let plv = JYPlaceholdView(frame: kScreenBounds,
                                  title: "你好",
                                  subTitle: "Hello world !",
                                  imgName: "no_network",
                                  btnTitle: "带你回家")
        view.addSubview(plv)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            plv.title = "哈哈哈哈哈哈哈哈哈啊哈哈哈啊哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈啊哈哈"
            plv.subTitle = ""
            plv.imgName = "no_collect"
            plv.offsetTop = -100
        }

        let pp = JYPlaceholdView()
        view.addSubview(pp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
