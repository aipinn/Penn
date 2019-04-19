//
//  JYPlaceholdView.swift
//  HomeEconomics
//
//  Created by emoji on 2019/4/10.
//  Copyright © 2019 guanjia. All rights reserved.
//

import UIKit

typealias JYPlaceholdViewBlock = ()->()

@objcMembers class JYPlaceholdView: UIView {

    /// 标题
    var title: String? {
        didSet {
            titleL?.text = title
        }
    }
    /// 子标题
    var subTitle: String? {
        didSet {
            subTitleL?.text = subTitle
        }
    }
    var btnTitle: String? {
        didSet {
            if let t = btnTitle, t.lengthOfBytes(using: .utf8)>0 {
                btn?.isHidden = true
                btn?.setTitle(t, for: .normal)
            } else {
                btn?.isHidden = false
            }
          
        }
    }
    /// 占位图
    var imgName: String? {
        didSet {
            if let name = imgName {
                imageV?.image = UIImage(named: name);
            }
        }
    }
    /// 图片的center.y距顶部偏移量,默认居中
    var offsetTop: CGFloat = 0 {
        didSet {
            imageV?.mas_updateConstraints{ make in
                make?.centerY.equalTo()(offsetTop)
            }
        }
    }
    
    var isHiddenBtn: Bool = true {
        didSet {
            btn?.isHidden = isHiddenBtn
        }
    }
    
    private var btn: UIButton?
    private var titleL: UILabel?
    private var subTitleL: UILabel?
    private var imageV: UIImageView?
    
    var closure: JYPlaceholdViewBlock?
    
    init(frame: CGRect, title: String?, subTitle: String?, imgName: String?, btnTitle: String?) {
        
        self.title = title
        self.subTitle = subTitle
        self.imgName = imgName
        self.btnTitle = btnTitle
        super.init(frame: frame)
        
        setupUI()
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        
        let imageV = UIImageView()
        imageV.image = UIImage(named: imgName ?? "")
        self.addSubview(imageV)
        self.imageV = imageV;
        if let iv = self.imageV {
            iv.mas_makeConstraints { make in
                make?.centerX.equalTo()
                make?.centerY.equalTo()(offsetTop)
            }
        }
        
        let titleL = UILabel()
        titleL.text = title
        titleL.numberOfLines = 0
        titleL.textAlignment = .center
        titleL.font = UIFont.systemFont(ofSize: 20)
        titleL.textColor = UIColor.colorRGBA(74, 53, 53)
        addSubview(titleL)
        self.titleL = titleL

        titleL.mas_makeConstraints { make in
            make?.top.equalTo()(imageV.mas_bottom)
            make?.centerX.equalTo()(imageV.mas_centerX)
            make?.right.left()?.greaterThanOrEqualTo()(10)
        }
        
        let subTitleL = UILabel()
        subTitleL.text = subTitle
        subTitleL.numberOfLines = 0
        subTitleL.textAlignment = .center
        subTitleL.font = UIFont.systemFont(ofSize: 14)
        subTitleL.textColor = UIColor.colorRGBA(117, 103, 103)
        addSubview(subTitleL)
        subTitleL.center.x = center.x
        self.subTitleL = subTitleL
        subTitleL.mas_makeConstraints { make in
            make?.top.equalTo()(titleL.mas_bottom)
            make?.centerX.equalTo()(imageV.mas_centerX)
            make?.right.left()?.greaterThanOrEqualTo()(10)
        }

        let color = UIColor.colorRGBA(252, 73, 73)
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = color.cgColor
        button.setTitleColor(.red, for: .normal)
        button.setTitle(btnTitle, for: .normal)
        button.titleLabel?.font = UIFont.medium(16)
        UIFont.boldSystemFont(ofSize: 1)
        addSubview(button)
        button.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        btn = button
        
        button.mas_makeConstraints { make in
            make?.top.equalTo()(subTitleL.mas_bottom)?.offset()(20)
            make?.centerX.equalTo()(imageV.mas_centerX)
            make?.size.mas_equalTo()(CGSize(width: 115, height: 38))
        }
    }
    //Action
    func btnAction() {
        if let block = closure {
            block()
        }
    }
    
}

extension UIColor {

    static func colorRGBA(_ red: CGFloat,
                          _ green: CGFloat,
                          _ blue: CGFloat,
                          _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

extension UIFont {
 
    static func medium(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fontSize)!
    }
    
    static func semibold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize)!
    }
    
    static func regular(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: fontSize)!
    }
    
    static func DINAlternateBold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "DINAlternate-Bold", size: fontSize)!
    }
}
