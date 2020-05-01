//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Gerry Low on 2020-04-29.
//  Copyright © 2020 Gerry Low. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    @IBOutlet var sentMemesTableView: UITableView!
    
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        tableView.rowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemesTableViewCell", for: indexPath) as! SentMemesTableViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memeText.text = meme.topText + " " + meme.bottomText
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailView
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (UIApplication.shared.delegate as! AppDelegate).removeMeme(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func registerTableViewCells() {
        let cell = UINib(nibName: "SentMemesTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "sentMemesTableViewCell")
    }
}
