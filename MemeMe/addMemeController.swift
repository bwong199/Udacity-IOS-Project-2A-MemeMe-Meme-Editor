//
//  addMemeController.swift
//  MemeMe
//
//  Created by Ben Wong on 2016-03-24.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import CoreData

class addMemeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var topTextField: UITextField!
    
    @IBOutlet var bottomTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    
    var image: UIImage!
    
    var text1: String!
    var text2: String!
    
    @IBOutlet var topLabel: UILabel!
    
    @IBOutlet var bottomLabel: UILabel!
    
    @IBAction func addTopText(sender: AnyObject) {
        topTextField.text = sender.text
        topLabel.text = topTextField.text
        
    }
    
    @IBAction func addBottomText(sender: AnyObject) {
        topTextField.text = sender.text
        bottomLabel.text = bottomTextField.text
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        topTextField.textColor = UIColor.whiteColor()
        topTextField.font = UIFont.boldSystemFontOfSize(16)
        topTextField.sizeToFit()
        
        bottomTextField.textColor = UIColor.whiteColor()
        bottomTextField.font = UIFont.boldSystemFontOfSize(16)
        bottomTextField.sizeToFit()
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cameraBtnTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = UIImagePickerControllerSourceType.Camera
            cameraViewController.delegate = self
            
            self.presentViewController(cameraViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func albumButtonTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            cameraViewController.delegate = self
            
            self.presentViewController(cameraViewController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func shareButton(sender: AnyObject) {
        
        
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let meme = NSEntityDescription.insertNewObjectForEntityForName("Meme", inManagedObjectContext: context) as! Meme
        
        
        if let image: UIImage = takeScreenshot(imageView) {
            
            meme.image = UIImagePNGRepresentation(image)
            
            //on completion of the share activity, saves the image to core data
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            presentViewController(vc, animated: true, completion: {
                do {
                    try context.save()
                } catch {
                    
                }
            })
            
        }
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