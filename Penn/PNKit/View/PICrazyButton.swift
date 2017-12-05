//
//  PNCrazyButton.swift
//  Penn
//
//  Created by SanRong on 2017/11/24.
//  Copyright © 2017年 SanRong. All rights reserved.
//

import UIKit

class PICrazyButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var image:UIImage?
    
    
    class func crazyButton(imageStr: String , title: String) -> PICrazyButton {

         let nib = UINib(nibName:"PICrazyButton", bundle: nil)
         let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! PICrazyButton
            btn.imageView.image = UIImage(named: imageStr)
            btn.titleLabel.text = title

        return btn

        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }

    
    
}
