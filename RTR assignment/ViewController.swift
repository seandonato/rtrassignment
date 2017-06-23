//
//  ViewController.swift
//  RTR assignment
//
//  Created by Sean Donato on 6/20/17.
//  Copyright © 2017 Sean Donato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var heart = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func push(_ sender: UIButton) {
        
        if(sender.restorationIdentifier == "fp"){
            
            let myVC = storyboard?.instantiateViewController(withIdentifier: "sp") as! SiteProducts
            
            myVC.fromSiteOrSaved = "site"
            
            navigationController?.pushViewController(myVC, animated: true)
        
        }else if(sender.restorationIdentifier == "mp")
        
        {
            
            let myVC = storyboard?.instantiateViewController(withIdentifier: "sp") as! SiteProducts
            self.heart = 1
            
            myVC.heart = self.heart

            myVC.fromSiteOrSaved = "saved"
            
            navigationController?.pushViewController(myVC, animated: true)
            
        }

    }
    
}

