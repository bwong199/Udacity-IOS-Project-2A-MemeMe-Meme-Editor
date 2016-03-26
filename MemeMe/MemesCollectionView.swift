//
//  MemesCollectionView.swift
//  MemeMe
//
//  Created by Ben Wong on 2016-03-26.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import CoreData


class MemesCollectionView: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    
    let reuseIdentifier = "cell"
    var memes : [Meme] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.collectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        
        let meme = self.memes[indexPath.row]
        //
        //        cell.imageView!.image = UIImage(named: "darthvader@2x-iphone.png")
        cell.myImage!.image = UIImage(data: meme.image!)
        

        
        return cell
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
}