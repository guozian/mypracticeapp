//
//  DetailViewController.swift
//  AppYourBusiness
//
//  Created by Hui Guo on 16/8/17.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    
    var posts: [Posts] = [Posts]()
    var selectedPost: Posts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = self.selectedPost{
            let thumbnailUrlString = post.postThumbnailUrlString
            let imageUrl: NSURL = NSURL(string: thumbnailUrlString)!
            print(thumbnailUrlString)
            postImageView.af_setImageWithURL(imageUrl)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let post = self.selectedPost{
            let thumbnailUrlString = post.postThumbnailUrlString
            let imageUrl: NSURL = NSURL(string: thumbnailUrlString)!
            print(thumbnailUrlString)
            postImageView.af_setImageWithURL(imageUrl)
        }
    }
    
    
}
