//
//  addMemeController.swift
//  MemeMe
//
//  Created by Ben Wong on 2016-03-24.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

class AddMemeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet var topTextField: UITextField!
    
    @IBOutlet var bottomTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    var image: UIImage!
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        setUpTextfield()
        
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName :   UIFont(name: "HelveticaNeue-CondensedBlack", size : 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    func setUpTextfield(){
        
        topTextField.text = "TOP"
        topTextField.sizeToFit()
        topTextField.defaultTextAttributes = memeTextAttributes
  
        bottomTextField.text = "BOTTOM"
        bottomTextField.sizeToFit()
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
        textField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Disable share button if the image is not chosen
        if imageView.image == nil {
            shareButton.enabled = false
        } else {
            shareButton.enabled = true
        }
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillHide:" , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        view.frame.origin.y += getKeyboardHeight(notification)
            view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if bottomTextField.editing {
            return keyboardSize.CGRectValue().height
        } else {
            return 0
        }
        
    }
    
   
    @IBAction func cameraBtnTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            presentImagePicker(UIImagePickerControllerSourceType.Camera)
        } else {
            // if device doesn't have a camera button, disable the button
            cameraButton.enabled = false
        }
        
    }
    
    @IBAction func albumButtonTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){

            presentImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
        } else {
            
        }
    }
    
    func presentImagePicker(source: UIImagePickerControllerSourceType){
        let cameraViewController = UIImagePickerController()
        cameraViewController.sourceType = source
        cameraViewController.delegate = self
        
        self.presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        
        let image = takeScreenshot(imageView)
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        //If the user completes an action in the activity view controller, save the meme to the shared storage
        shareController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMemedImage()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(shareController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

    func saveMemedImage() {
        //Create the meme
        _ = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: takeScreenshot(imageView))
        
        //TODO: Add to memes array in AppDelegate
        
    }
    
    
    func takeScreenshot(theView: UIView) -> UIImage {
        
       
        imageView.addSubview(topTextField)
        imageView.addSubview(bottomTextField)
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        self.imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
}