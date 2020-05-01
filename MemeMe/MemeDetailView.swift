//
//  MemeDetailView.swift
//  MemeMe
//
//  Created by Gerry Low on 2020-04-30.
//  Copyright © 2020 Gerry Low. All rights reserved.
//

import UIKit

class MemeDetailView: UIViewController {
    
    var memeIndex: Int!
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[memeIndex]
        memedImage.image = meme.memedImage
    }
    
    @objc func editMeme() {
        let memeEditorController = storyboard?.instantiateViewController(withIdentifier: "MemeMeEditorViewController") as! MemeMeEditorViewController
        memeEditorController.memeIndex = memeIndex
        navigationController?.pushViewController(memeEditorController, animated: true)
    }
}
