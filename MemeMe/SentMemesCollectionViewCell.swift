//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Gerry Low on 2020-04-30.
//  Copyright © 2020 Gerry Low. All rights reserved.
//

import UIKit

class SentMemesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setImage(_ image: UIImage) {
        memedImageView.image = image
    }
    
}
