//
//  Meal.swift
//  FoodTracker
//
//  Created by 高橋佑太 on 2017/06/16.
//  Copyright © 2017年 高橋佑太. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        if name.isEmpty || rating < 0 {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        

    }
}
