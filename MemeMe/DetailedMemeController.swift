//
//  DetailedMemeController.swift
//  MemeMe
//
//  Created by Ben Wong on 2016-03-26.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import CoreData

class DetailedMemeController: UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    
    var meme : Meme? = nil
    
    override func viewDidLoad() {
        self.imageView.image = UIImage(data: self.meme!.image!)
    }
}