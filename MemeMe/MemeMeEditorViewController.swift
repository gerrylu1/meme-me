//
//  ViewController.swift
//  MemeMe
//
//  Created by Gerry Low on 2020-04-18.
//  Copyright © 2020 Gerry Low. All rights reserved.
//

import UIKit

class MemeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let topText = "TOP"
    let bottomText = "BOTTOM"
    
    var memeIndex: Int?
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initMemeTextField(topTextField)
        initMemeTextField(bottomTextField)
        if let memeIndex = memeIndex {
            // edit mode for an already existing meme
            navBar.topItem!.title = "Edit Meme"
            let memeBeingEdited = (UIApplication.shared.delegate as! AppDelegate).memes[memeIndex]
            imagePickerView.image = memeBeingEdited.originalImage
            switchToMemeCreatingMode(topText: memeBeingEdited.topText, bottomText: memeBeingEdited.bottomText, editMode: 1)
        }
        else {
            switchToImagePickingMode()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImageFromSource(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImageFromSource(.camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
        switchToMemeCreatingMode(topText: topText, bottomText: bottomText, editMode: 0)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func initMemeTextField(_ memeTextField: UITextField) {
        memeTextField.defaultTextAttributes = memeTextAttributes
        memeTextField.textAlignment = .center
        memeTextField.delegate = self
    }
    
    func pickAnImageFromSource(_ sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    func switchToImagePickingMode() {
        toggleUIVisibilityToMemeCreatingMode(false)
    }
    
    func switchToMemeCreatingMode(topText: String, bottomText: String, editMode: Int) {
        topTextField.text = topText
        bottomTextField.text = bottomText
        topTextField.tag = editMode
        bottomTextField.tag = editMode
        toggleUIVisibilityToMemeCreatingMode(true)
    }
    
    func toggleUIVisibilityToMemeCreatingMode(_ on: Bool) {
        toolbar.isHidden = on
        shareButton.isEnabled = on
        imagePickerView.isHidden = !on
        topTextField.isHidden = !on
        bottomTextField.isHidden = !on
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        // Hide Navbar
        navBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show Navbar
        navBar.isHidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let memeIndex = memeIndex {
            appDelegate.memes[memeIndex] = meme
        }
        else {
            appDelegate.memes.append(meme)
        }
        
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:
            Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.save(memedImage: memedImage)
                self.navigationController?.popViewController(animated: true)
            }
        }
        controller.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelMemeCreation(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            textField.text = ""
            textField.tag = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
