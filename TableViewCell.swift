//
//  TableViewCell.swift
//  AppYourBusiness
//
//  Created by Hui Guo on 16/8/14.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class TableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var posts1: [Posts] = [Posts]()
    var posts2: [Posts] = [Posts]()
    var categories: [Category] = [Category]()
    var selectedPost1: Posts?
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts1.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
       
            let imageUrlString: String = posts1[indexPath.row].postThumbnailUrlString
            let imageUrl: NSURL = NSURL(string: imageUrlString)!
        //Give Images A round cornor
       
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: collectionViewCell.postImageView.frame.size,
            radius: 20.0
        )
        
        collectionViewCell.postImageView.af_setImageWithURL(imageUrl, filter: filter)
       
        collectionViewCell.postTitleLabel.text = posts1[indexPath.row].postTite
        
       // theCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
       
        //give blur view a round corner to match the images' corner
        let path = UIBezierPath(roundedRect:collectionViewCell.bounds, byRoundingCorners:[.BottomRight, .BottomLeft, .TopRight, .TopLeft], cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
        collectionViewCell.layer.mask = maskLayer
        collectionViewCell.layer.mask = maskLayer
        
        theCollectionView.delegate = self
        
        return collectionViewCell
    }
    
   
    
    /**
     Scroll to Next Cell
     */
    func scrollToNextCell(){
        
        //get cell size
        
        let cellSize = CGSizeMake(self.theCollectionView.frame.width, self.theCollectionView.frame.height);
        
        //get current content Offset of the Collection view
        let contentOffset = theCollectionView.contentOffset;
        
        if theCollectionView.contentSize.width <= theCollectionView.contentOffset.x + cellSize.width
        {
            theCollectionView.scrollRectToVisible(CGRectMake(0, contentOffset.y, cellSize.width, cellSize.height), animated: true);
            
            
        } else {
            theCollectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
            
        }
        
    }
    
    /**
     Invokes Timer to start Automatic Animation with repeat enabled
     */
    func startTimer() {
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(TableViewCell.scrollToNextCell), userInfo: nil, repeats: true);
        
        let nextContentOffset = CGPoint( x: theCollectionView.contentOffset.x + 260,  y: theCollectionView.contentOffset.y)
        theCollectionView.setContentOffset(nextContentOffset, animated: true)
    }
    
    //get categories from JSON
    
    func getCategories(){
        
        Alamofire.request(.GET, "http://localhost:8888/wordpress/wp-json/wp/v2/categories").responseJSON { (response) in
            if let jsonFile = response.result.value {
                
                var arrayOfCategories = [Category]()
                
                for post in jsonFile as! NSArray {
                    
                    let categoryObj = Category()
                    
                    
                        categoryObj.postCategoryCode = post.valueForKeyPath("id") as! NSNumber
                        categoryObj.theDictionary = post.valueForKeyPath("_links") as! NSDictionary
                        categoryObj.theCategoryArray = (categoryObj.theDictionary.valueForKeyPath("wp:post_type") as? NSArray)!
                        categoryObj.postCategoryListUrl = categoryObj.theCategoryArray[0].valueForKeyPath("href") as! String
                    
   
                        arrayOfCategories.append(categoryObj)
                    
                }
            
                self.categories = arrayOfCategories
              
                for category in self.categories{
                   let categoryCode = category.postCategoryCode
                    let postUrl = category.postCategoryListUrl
        
                    Alamofire.request(.GET, postUrl).responseJSON(completionHandler: { (response) in
                        if let postJsonFile = response.result.value{
                            var arrayOfPosts = [Posts]()
                            for post in postJsonFile as! NSArray{
                                let postObj = Posts()
                                if !(post.valueForKeyPath("featured_image_thumbnail_url") is NSNull)
                                {
                                    postObj.postTite = post.valueForKeyPath("title.rendered") as! String
                                    postObj.postThumbnailUrlString = post.valueForKeyPath("featured_image_thumbnail_url") as! String
                                    
                                    arrayOfPosts.append(postObj)
                                }
                            }
                            if categoryCode == 2{
                            self.posts2 = arrayOfPosts
                            self.theCollectionView.reloadData()
                                
                            };if categoryCode == 1{
                                self.posts1 = arrayOfPosts
                                
                                self.theCollectionView.reloadData()
                            }
                        }
                    })
                    
                }
                   
    
                   
            }
            }
    }
   
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       // print("selected")
        self.selectedPost1 = self.posts1[indexPath.row]
        
    }
    
    
}


class Category: NSObject{
    
    var theCategoryArray = NSArray()
    var theDictionary = NSDictionary()
    var postCategoryListUrl: String = ""
    var postCategoryCode = NSNumber()
    
}

class Posts: NSObject{
    
    var postTite:String = ""
    var postContent: String = ""
    
    var postThumbnailUrlString: String = ""
    
   
}



