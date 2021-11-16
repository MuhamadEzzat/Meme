//
//  ViewController.swift
//  MEME
//
//  Created by Mohamed Ezzat on 10/12/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var camerButton: UIBarButtonItem!
    @IBOutlet weak var topTF: UITextField!
    @IBOutlet weak var imageViewPicker: UIImageView!
    @IBOutlet weak var bottomTF: UITextField!
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2
    ]
    
//    let activityinstance : UIActivityViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTextField(topTF, text: "TOP")
        setupTextField(bottomTF, text: "BOTTOM")
        
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
        
        

    }
    
    func setupTextField(_ textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        camerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func captureImage(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageViewPicker.image = image
            dismiss(animated: true, completion: nil)
                }
//        activityinstance.completionWithItemsHandler = {
//        (activity, completed, items, error) in
//        if completed {
//        self.save()
//        }
//        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTF.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y -= 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    
    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar
        
        

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar

        return memedImage
    }

}

