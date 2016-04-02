//
//  addMemeController.swift
//  MemeMe
//
//  Created by Ben Wong on 2016-03-24.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

struct Meme {
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImage : UIImage
}

class AddMemeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var topTextField: UITextField!
    
    @IBOutlet var bottomTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    var image: UIImage!
    
    var text1: String!
    var text2: String!
    
    @IBOutlet var topLabel: UILabel!
    
    @IBOutlet var bottomLabel: UILabel!
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func addTopText(sender: AnyObject) {
        topTextField.text = sender.text
        topLabel.text = topTextField.text
        
    }
    
    @IBAction func addBottomText(sender: AnyObject) {
        bottomTextField.text = sender.text
        bottomLabel.text = bottomTextField.text
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        setUpTextfield()
        
    }
    
    func setUpTextfield(){
        topTextField.textColor = UIColor.whiteColor()
        topTextField.font = UIFont.boldSystemFontOfSize(16)
        topTextField.sizeToFit()
        
        bottomTextField.textColor = UIColor.whiteColor()
        bottomTextField.font = UIFont.boldSystemFontOfSize(16)
        bottomTextField.sizeToFit()
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
        view.frame.origin.y += getKeyboardHeight(notification)
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
    
    
    
    
    //    func keyboardWillShow(notification: NSNotification) {
    //
    //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
    //            self.view.frame.origin.y -= keyboardSize.height
    //        }
    //
    //    }
    //
    //    func keyboardWillHide(notification: NSNotification) {
    //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
    //            self.view.frame.origin.y += keyboardSize.height
    //        }
    //    }
    
       
    
    @IBAction func cameraBtnTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = UIImagePickerControllerSourceType.Camera
            cameraViewController.delegate = self
            
            self.presentViewController(cameraViewController, animated: true, completion: nil)
        } else {
            // if device doesn't have a camera button, disable the button
            cameraButton.enabled = false
        }
        
    }
    
    @IBAction func albumButtonTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            cameraViewController.delegate = self
            
            self.presentViewController(cameraViewController, animated: true, completion: nil)
        } else {
            
        }
        
    }
    
    
    @IBAction func shareButton(sender: AnyObject) {
        
        
        //        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //
        //        let meme = NSEntityDescription.insertNewObjectForEntityForName("Meme", inManagedObjectContext: context) as! Meme
        
        
        
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
    
    
    //    @IBAction func saveScreenshot(sender: AnyObject) {
    //        print("screenshot pressed")
    //        let image = takeScreenshot(imageView)
    //        UIImageWriteToSavedPhotosAlbum(image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
    //
    //    }
    
    //    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
    //        dispatch_async(dispatch_get_main_queue(), {
    //            UIAlertView(title: "Success", message: "The meme has been saved to your Camera Roll", delegate: nil, cancelButtonTitle: "Close").show()
    //        })
    //    }
    
    func saveMemedImage() {
        //Create the meme
        _ = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: takeScreenshot(imageView))
        
        //TODO: Add to memes array in AppDelegate
        
    }
    
    
    func takeScreenshot(theView: UIView) -> UIImage {
        
        //        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
        //
        //
        //        theView.drawViewHierarchyInRect(theView.bounds, afterScreenUpdates: true)
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        
        imageView.addSubview(topLabel)
        imageView.addSubview(bottomLabel)
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        self.imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //
    //        return true
    //    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
}