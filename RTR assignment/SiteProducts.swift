//
//  SiteProducts.swift
//  RTR assignment
//
//  Created by Sean Donato on 6/20/17.
//  Copyright © 2017 Sean Donato. All rights reserved.
//

import Foundation
import UIKit

class SiteProducts :

UITableViewController{
    

    
    var data1 = NSMutableData();
    var dataArray : [NSDictionary] = [];
    var products : [Product] = [];

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
                
                    self.products.append(iProduct);
                    
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
        
        navigationController?.pushViewController(myVC, animated: true)
        
        
    }

}

