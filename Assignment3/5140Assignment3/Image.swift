//
//  Image.swift
//  5140Assignment3
//
//  Created by hideto on 7/11/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class Image: NSObject {
    var name : String
    var url : String
    
     init(name : String,url: String) {
        self.name = name
        self.url = url
    }
}
