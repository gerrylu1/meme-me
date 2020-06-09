//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gerry Low on 2020-04-29.
//  Copyright © 2020 Gerry Low. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // set the desired layout
    let approximateDimensionForCellsInPhone:Int = 120
    let approximateDimensionForCellsInPad:Int = 300
    let spacingForCells:CGFloat = 3.0
    
    var approximateDimensionForCells:Int {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return approximateDimensionForCellsInPad
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            return approximateDimensionForCellsInPhone
        }
        else {
            assert(false, "The user is using an unrecognized device")
        }
    }
    
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViewCells()
        flowLayoutAdjustment(width: view.frame.size.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        flowLayoutAdjustment(width: size.width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailView
        detailController.memeIndex = (indexPath as NSIndexPath).row
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    private func registerCollectionViewCells() {
        let cell = UINib(nibName: "SentMemesCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "SentMemesCollectionViewCell")
    }
    
    private func flowLayoutAdjustment(width: CGFloat) {
        if isViewLoaded {
            let numberOfItemsInRow:Int = Int(width) / approximateDimensionForCells
            let dimension:CGFloat = width / CGFloat(numberOfItemsInRow) - spacingForCells * 2.0
            flowLayout.minimumInteritemSpacing = spacingForCells
            flowLayout.minimumLineSpacing = spacingForCells
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    }
}
