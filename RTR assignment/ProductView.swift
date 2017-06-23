//
//  ProductView.swift
//  RTR assignment
//
//  Created by Sean Donato on 6/21/17.
//  Copyright © 2017 Sean Donato. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class ProductView : UIViewController {

    @IBOutlet var heartButton: UIButton!
    
    var heart = 0;
    
    var index = 0;
    
    var sentProduct : Product = Product();
    
    var images : [UIImage] = [];
    
    var imageUrlsBySize : NSDictionary = NSDictionary();
    
    @IBOutlet var imgView1: UIImageView!

    @IBOutlet var txtView1: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()


        
        imageUrlsBySize = sentProduct.imagesBySize;
        
        var imageUrls : [String] = [];
        
        imageUrls = imageUrlsBySize.value(forKey: "183x") as! [String]
        
        var x = imageUrls.count-1
        
        var checkedUrls : [URL] = [];
        
        
        for i in 0...x{

            var url = URL(string: imageUrls[i])
            
            checkedUrls.append(url!)
            
            //self.imgView1.contentMode = .scaleAspectFit
            
            }
//
        //DispatchQueue.global(qos: .background).async { [weak self]
          //  () -> Void in
            
            for j in 0...x{
                
                var imgUrl = checkedUrls[j]
                
                self.downloadImage(url:imgUrl)
                
            }
            //            DispatchQueue.main.sync {
              //              () -> Void in
                  //      self?.imgView1.image = self?.images[0]
                //        }
            //}
        
       // downloadImage(url: checkedUrls[0])
            
    

        var text = sentProduct.displayName + "\n" + sentProduct.designer + "\n"
            + sentProduct.styleNotes
        
        self.txtView1.text = text
        
    }
    

    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() { () -> Void in
                
                var dImg = UIImage(data: data)
                
                self.images.append(dImg!)
            
                self.imgView1.image = self.images[0]

            }
        }
    }
    
    
    @IBOutlet var swiped: UISwipeGestureRecognizer!
    
    
    @IBAction func imgSwipe(_ sender: Any) {
        
        self.imgView1.image = self.images[index]
        
        index = (index < images.count-1) ? index+1 : 0

    }
    
    
    @IBAction func save(_ sender: Any) {
        
        var im : UIImage = UIImage(named:"heartred")!
        

        heartButton.setImage(im, for: UIControlState.normal)
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "SavedProduct",
                                       in: managedContext)!
        
        let savedProd = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        savedProd.setValue(sentProduct.displayName, forKeyPath: "displayName")
        
        // 4
        do {
            try managedContext.save()
            //SavedProduct.append(savedProd)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
}
