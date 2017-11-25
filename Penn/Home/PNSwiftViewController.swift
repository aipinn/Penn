//
//  PNSwiftViewController.swift
//  Penn
//
//  Created by SanRong on 2017/11/24.
//  Copyright © 2017年 SanRong. All rights reserved.
//

import UIKit

class PNSwiftViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swift"
        let button = PICrazyButton().crazyButton(imageStr:"bicycle", title:"自行车")
        button.center = view.center
        view.addSubview(button)
        button.addTarget(self, action: #selector(nextStep), for:.touchUpInside)
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func nextStep() {
        
        let profile = PNProfileViewController()
        navigationController?.pushViewController(profile, animated: true)
    }

    
}
