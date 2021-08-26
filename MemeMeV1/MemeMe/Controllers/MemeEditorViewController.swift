//
//  ViewController.swift
//  MemeMe
//
//  Created by D Naung Latt on 24/08/2021.
//

import UIKit

class MemeEditorViewController: UIViewController{
    
    // MARK: IBOutlets
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var actionButton: UIButton!
    
    
    // MARK: Set Up Text Fields
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!,
        NSAttributedString.Key.strokeWidth: -3.6,
        NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle()]
  
    // MARK: System Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable Share Button
        actionButton.isEnabled = false
        
        // Setting Top Text Field
        prepareTextField(textField: topTextField, text:"TOP")
        
        // Setting Bottom Text Field
        prepareTextField(textField: bottomTextField, text:"BOTTOM")
        
    }
    
    func prepareTextField(textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: IBActions
    
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    func pickImage(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareGeneratedMeme(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let shareSheet = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareSheet.completionWithItemsHandler = { (type, completed, items, error) in
            if (completed) {
                self.saveMeme()
            }
        }
        present(shareSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        actionButton.isEnabled = false
        imagePickerView.image = nil
    }
    
    // MARK : Generate Meme
    
    func generateMemedImage() -> UIImage {

        // Hide toolbar and navbar
        setToolbarState(true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        setToolbarState(false)
        
        return memedImage
    }
    
    // MARK : Save Meme
    
    func saveMeme() {
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memeImage: generateMemedImage())
    }
    
    // MARK : Set Tool Bar State
    
    func setToolbarState(_ hidden: Bool) {
        topToolBar.isHidden = hidden
        bottomToolBar.isHidden = hidden
    }
    
}

// MARK: UI ImagePicker Delegate

extension MemeEditorViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            self.imagePickerView.image = image
            self.imagePickerView.contentMode = .scaleAspectFit
            actionButton.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: Text Fields Delegate


extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "BOTTOM" || textField.text == "TOP"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MAKK : Keyboard Show / Hide

extension MemeEditorViewController {
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:   UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
