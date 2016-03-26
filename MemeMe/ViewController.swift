//
//  ViewController.swift
//  MemeMe
//
//  Created by Ben Wong on 2016-03-24.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    
    var memes : [Meme] = []
    
    var selectedMeme: Meme? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        makeSampleProduct()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let meme = self.memes[indexPath.row]
        //        cell.textLabel!.text = product.title
        cell.imageView!.image = UIImage(named: "darthvader@2x-iphone.png")
        cell.imageView!.image = UIImage(data: meme.image!)
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedMeme = self.memes[indexPath.row]
        
        self.performSegueWithIdentifier("tableViewToDetailSegue", sender: self)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addMemeSegue"{
            segue.destinationViewController as! addMemeController
            //            detailVC.product = self.selectedProduct
        }
    }
    
    func makeSampleProduct(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let meme = NSEntityDescription.insertNewObjectForEntityForName("Meme", inManagedObjectContext: context) as! Meme
        
        
        meme.image = UIImageJPEGRepresentation(UIImage(named: "darthvader@2x-iphone.png")!, 1)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    
}

