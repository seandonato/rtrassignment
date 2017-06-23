//
//  SiteProducts.swift
//  RTR assignment
//
//  Created by Sean Donato on 6/20/17.
//  Copyright © 2017 Sean Donato. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SiteProducts :

UITableViewController{
    

    var savedProductNames : [NSManagedObject] = []
    var data1 = NSMutableData();
    var dataArray : [NSDictionary] = [];
    var products : [Product] = [];
    var fromSiteOrSaved : String = ""
    var heart = 0
    var didSave : Bool = false

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        products.removeAll()

        self.do_table_refresh()
            //1
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
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

        self.getData()

    }
    
    func getData(){
        
    
        // Do any additional setup after loading the view, typically from a nib.

        let url = URL(string: "https://rtr-ios-assignment-api.herokuapp.com/app/products")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                
                self.dataArray = json["products"] as? [[String: Any]] as! [NSDictionary] ?? []

                //let posts = json["posts"] as? [[String: Any]] ?? []
                
                var x = self.dataArray.count - 1
                
                
                for i in 0 ... x{
                    
                    var iProduct = Product();

                    var dic = NSDictionary();
                    
                    dic = self.dataArray[i];
                    
                    var key : String = String()
                    var nKey : Int = Int()
                    var bKey : Bool = Bool()
                    var dKey : NSDictionary = NSDictionary()

                    
                    if let key = dic.value(forKeyPath: "styleName")
                   {
                    
                    iProduct.styleName = (dic.value(forKeyPath: "styleName") as! String)
                    }
                    if let key = dic.value(forKeyPath: "displayName")
                    {
                        
                        iProduct.displayName = (dic.value(forKeyPath: "displayName") as! String);
                    }
                    if let key = dic.value(forKeyPath: "productDetail")
                    {
                        
                        iProduct.productDetail = (dic.value(forKeyPath: "productDetail") as! String);
                    }
                    if let key = dic.value(forKeyPath: "designer")
                    {
                        
                        iProduct.designer = (dic.value(forKeyPath: "designer") as! String);
                    }
                    if let key = dic.value(forKeyPath: "type")
                    {
                        
                        iProduct.type = (dic.value(forKeyPath: "type") as! String);
                    }
                    if let key = dic.value(forKeyPath: "fitNotes")
                    {
                        
                        iProduct.fitNotes = (dic.value(forKeyPath: "fitNotes") as! String);
                    }
                    if let key = dic.value(forKeyPath: "styleNotes")
                    {
                        
                        iProduct.styleNotes = (dic.value(forKeyPath: "styleNotes") as! String);
                    }
                    if let dKey = dic.value(forKeyPath: "imagesBySize")
                    {
                        
                        iProduct.imagesBySize = (dic.value(forKeyPath: "imagesBySize") as! NSDictionary);
                        
                    }
                    if let nKey = dic.value(forKeyPath: "rentalFee8Day")
                    {
                        
                        iProduct.rentalFee8Day = (dic.value(forKeyPath: "rentalFee8Day") as! Int);
                    }
                    
                    if let nKey = dic.value(forKeyPath: "rentalFee")
                    {
                        
                        iProduct.rentalFee = (dic.value(forKeyPath: "rentalFee") as! Int);
                    }
                    if let bKey = dic.value(forKeyPath: "clearance")
                    {
                        
                        iProduct.clearance = (dic.value(forKeyPath: "clearance") as! Bool);
                        
                    }


                   // iProduct.styleName = (dic.value(forKeyPath: "styleName") as! String);
                
                    if( self.fromSiteOrSaved == "site" ){
                    
                        self.products.append(iProduct);

                    
                    }else{
                        

                        if(self.savedProductNames.count > 0){
                            
                             self.didSave  = true

                        var y = self.savedProductNames.count-1
                        for j in 0...y{
                            
                            
                            var spEntity = self.savedProductNames[j]
                            
                            var dName : String = spEntity.value(forKey: "displayName") as! String
                            
                            if(iProduct.displayName == dName){
                            
                                self.products.append(iProduct);

                            }
                        }
                        
                        }
                    }
                    
                    
                    if(i == x){
                        
                        self.do_table_refresh();

                    }
                }

            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
      // do_table_refresh();
    
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.products.count;

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        
        var prod : Product = self.products[indexPath.row]
        
        cell.textLabel?.text = prod.displayName
        
        return cell

    }

    func do_table_refresh()
    {
        
            self.tableView.reloadData()
            
            return
            
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "pview") as! ProductView
        
        myVC.sentProduct = self.products[indexPath.row]
        
        myVC.heart = self.heart
        
        myVC.didSave = self.didSave
        
        navigationController?.pushViewController(myVC, animated: true)
        
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        
        products.removeAll()
        self.do_table_refresh()
    }
}

