//
//  PNCrazyButton.swift
//  Penn
//
//  Created by SanRong on 2017/11/24.
//  Copyright © 2017年 SanRong. All rights reserved.
//

import UIKit

class PNCrazyButton: UIControl {

    var imageView: UIImageView
    var titleLabel: UILabel
    
    
    func crazyButton(imageStr: String , title: String) -> PNCrazyButton {
        
        imageView = UIImageView(image: UIImage(named: imageStr))
        titleLabel.text = title
      
        let arr  = Bundle.main.loadNibNamed("PNCrazyButton", owner: nil, options: nil)
        return arr![0] as! PNCrazyButton
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
