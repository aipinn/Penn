//
//  PNCustomKeyboard.swift
//  Penn
//
//  Created by SanRong on 2017/12/5.
//  Copyright © 2017年 SanRong. All rights reserved.
//

import UIKit

class PNCustomKeyboard: UIView {

    let cellID = "PNCustomKeyboardCell"
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!

    class func customKeyboardView() -> PNCustomKeyboard {
    
        let nib = UINib.init(nibName: "PNCustomKeyboard", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0]
        return view as! PNCustomKeyboard
        
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
        setup()
    }
    
    func setup(){
       
        let nib = UINib.init(nibName: cellID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension PNCustomKeyboard: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  21
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        return cell
    }
    
}
