//
//  Product.swift
//  RTR assignment
//
//  Created by Sean Donato on 6/20/17.
//  Copyright © 2017 Sean Donato. All rights reserved.
//

import Foundation


class Product: NSObject{

    var styleName  = "";
    var displayName = "";
    var productDetail = "";
    var designer = "";
    var type = "";
    var fitNotes = "";
    var styleNotes = "";
    var imagesBySize: NSDictionary = NSDictionary();
    var rentalFee8Day : Int = Int();
    var rentalFee : Int = Int();
    var clearance : Bool =  Bool();
    
    }
