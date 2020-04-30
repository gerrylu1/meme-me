//
//  MemeDetailView.swift
//  MemeMe
//
//  Created by Gerry Low on 2020-04-30.
//  Copyright © 2020 Gerry Low. All rights reserved.
//

import UIKit

class MemeDetailView: UIViewController {
    
    var meme: Meme!
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memedImage.image = meme.memedImage
    }
}
