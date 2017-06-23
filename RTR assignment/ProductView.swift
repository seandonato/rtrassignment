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
    
    var savedProductNames : [NSManagedObject] = []

    var heart = 0;
    
    var index = 0;
    
    var sentProduct : Product = Product();
    
    var images : [UIImage] = [];
    
    var imageUrlsBySize : NSDictionary = NSDictionary();
    
    @IBOutlet var imgView1: UIImageView!

    @IBOutlet var txtView1: UITextView!
    
    var didSave : Bool = false
    
    let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "SavedProduct")
        
        //3
        do {
            savedProductNames = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        
        if(self.savedProductNames.count > 0){
            
            
            var y = self.savedProductNames.count-1
            for j in 0...y{
                
                
                var spEntity = self.savedProductNames[j]
                
                var dName : String = spEntity.value(forKey: "displayName") as! String
                
                if(sentProduct.displayName == dName){
                    
                    heart = 1;
                    
                    var im : UIImage = UIImage(named:"heartred")!
                    
                    
                    heartButton.setImage(im, for: UIControlState.normal)

                    didSave = true;
                }
            }
            
        }
        
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
            
    
        var clear = ""
        
        if(sentProduct.clearance == true){
            clear = "yes"
        }else{
            clear = "no"
        }
        
        var text = sentProduct.displayName + "\n" + "Designer: " + sentProduct.designer + "\n" + sentProduct.type + "\n"
            + sentProduct.styleNotes + "\n" + sentProduct.fitNotes + "\n" + "Rental Fee: " + String(sentProduct.rentalFee) + "\n" + "Rental Fee 8 day: " + String(sentProduct.rentalFee8Day) + "\n" + "Clearance: " + clear
        
        
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
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext

        if(didSave == false){
            
            didSave = true;
            
        var im : UIImage = UIImage(named:"heartred")!
        

        heartButton.setImage(im, for: UIControlState.normal)
        
        
        
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
            
        }else{
            
            didSave = false;
            
            heart = 0;
            
            var im : UIImage = UIImage(named:"heart")!
            
            
            heartButton.setImage(im, for: UIControlState.normal)
            
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "SavedProduct")
            
            //3
            do {
                savedProductNames = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }


            if(self.savedProductNames.count > 0){
                
            var y = self.savedProductNames.count-1
                
            for j in 0...y{
                
                
                var spEntity = self.savedProductNames[j]
                
                var dName : String = spEntity.value(forKey: "displayName") as! String
                
                if(sentProduct.displayName == dName){
                    //////
                    
                    // 2
                    
                    // remove your object
                    
                    
                    // save your changes
                    // remove your object
                    
                    // save your changes 
                    
                    managedContext.delete(spEntity)

                    do{
                        
                        try managedContext.save()
                        
                    }catch{
                        print(" ")
                    }
                }
            }
            }
        }
    }

    
}
