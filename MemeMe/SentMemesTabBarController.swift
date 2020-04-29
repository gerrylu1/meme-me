//
//  SentMemesTabBarController.swift
//  MemeMe
//
//  Created by Gerry Low on 2020-04-29.
//  Copyright © 2020 Gerry Low. All rights reserved.
//

import UIKit

class sentMemesTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.createMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func createMeme() {
        let memeEditorController = storyboard?.instantiateViewController(withIdentifier: "MemeMeEditorViewController") as! MemeMeEditorViewController
        navigationController?.pushViewController(memeEditorController, animated: true)
    }
}
