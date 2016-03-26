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
    
    var selectedItem: Meme? = nil
    
    var memes : [Meme] = []
    
    var selectedMeme: Meme? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //        makeSampleProduct()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Meme")
        
        var results: [AnyObject]?
        
        do {
            results = try context.executeFetchRequest(request)
        } catch {
            results = nil
        }
        
        if results != nil {
            self.memes = results! as! [Meme]
        }
        
        self.tableView.reloadData()
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //        cell.textLabel!.text = product.title
        //        cell.textLabel!.text = "Nike kicks"
        
        let meme = self.memes[indexPath.row]
        //
        //        cell.imageView!.image = UIImage(named: "darthvader@2x-iphone.png")
        cell.imageView!.image = UIImage(data: meme.image!)
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = self.memes[indexPath.row]
        
        self.performSegueWithIdentifier("showMemeSegue", sender: self)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMemeSegue" {
            
            let destinationVC =   segue.destinationViewController as! DetailedMemeController
            
            destinationVC.meme = self.selectedItem
            
        }
    }
    
    //    func makeSampleProduct(){
    //        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    //
    //        let meme = NSEntityDescription.insertNewObjectForEntityForName("Meme", inManagedObjectContext: context) as! Meme
    //
    //
    //        meme.image = UIImageJPEGRepresentation(UIImage(named: "darthvader@2x-iphone.png")!, 1)
    //        do {
    //            try context.save()
    //        } catch {
    //            
    //        }
    //    }
    
    
}

