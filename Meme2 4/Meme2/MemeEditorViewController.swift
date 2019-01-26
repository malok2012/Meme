//
//  MemeEditorViewController.swift
//  Meme2
//
//  Created by Malak Bassam on 11/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var imageViewPick: UIImageView!
    @IBOutlet var cameraItem: UIBarButtonItem!
    @IBOutlet var shareImageItem: UIBarButtonItem!
    
    let memeTextAttributes:[NSAttributedString.Key : Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -4.5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(textField: topTextField, withText: "Top")
        self.configure(textField: bottomTextField, withText: "Bottom")
        cameraItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareImageItem.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        subscribeToKeyboardNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImage(_ sender: Any) {
         presentImagePickerWith(sourceType: .photoLibrary)
        
    }
    
    @IBAction func pickAnImageCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
        
    }


    @IBAction func cancelImage(_ sender: Any) {
        /*imageViewPick.image = nil
        self.configure(textField: topTextField, withText: "Top")
        self.configure(textField: bottomTextField, withText: "Bottom")*/
         performSegue(withIdentifier: "canceImage", sender: (Any).self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "canceImage" {
            segue.destination as! MemeSentTableViewController
        }
    }

    @IBAction func shareImage(_ sender: Any) {
        let image = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activity, completed, items, error) in
            // on successfull completion save the meme image
            if (completed){
                self.save(memedImage: image)
            }
            
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageViewPick.contentMode = .scaleAspectFit
                imageViewPick.image = image
            }
            dismiss(animated: true, completion: nil)
            shareImageItem.isEnabled = true 
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func configure(textField :UITextField, withText text: String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = text
        textField.delegate = self
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated:true, completion:nil)
        }
        func generateMemedImage() -> UIImage {
            
            // hide the top and bottom toolbar ((Add the code for this))
            topTextField.isHidden    = true
            bottomTextField.isHidden = true
            UIGraphicsBeginImageContext(view.frame.size)
            view.drawHierarchy(in: view.frame,
                               afterScreenUpdates: true)
            let memedImage : UIImage =
                UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // unhide the top and bottom toolbar (Add the code for this)
            topTextField.isHidden    = false
            bottomTextField.isHidden = false
            return memedImage
        }
    func save(memedImage:UIImage){
        let meme = Meme( topTextField:topTextField.text!, bottomTextField: bottomTextField.text!, image:
            imageViewPick.image!, memedImage: memedImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == topTextField.text || textField.text == bottomTextField.text
        {
            textField.text = ""
            
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isFirstResponder) {
            view.frame.origin.y = -getKeyboardHeight(notification)
            
        }
        else {view.frame.origin.y  = 0}
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if (bottomTextField.isFirstResponder){
            // Implement the logic
            self.view.frame.origin.y = 0
        }
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    
}

