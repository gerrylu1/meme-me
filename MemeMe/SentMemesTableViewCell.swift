//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Gerry Low on 2020-04-30.
//  Copyright © 2020 Gerry Low. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memedImageView: UIImageView!
    @IBOutlet weak var memeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
