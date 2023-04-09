//
//  Objects.swift
//  MeasureMash
//
//  Created by Frank Gao on 4/9/23.
//

import UIKit

class Objects {
    // Create a custom object called "ImageDoublePair" that contains an image and a double property
    class ImageDoublePair {
        var image: UIImage
        var length: Double
        var name: String
        var key: Int
        
        init(image: UIImage, length: Double, name: String, key: Int) {
            self.image = image
            self.length = length
            self.name = name
            self.key = key
        }
    }
    
    // Create an array of ImageDoublePair objects
    static var pairs = [
        ImageDoublePair(image: UIImage(named: "dice")!, length: 1.6, name: "Die", key: 1),
        ImageDoublePair(image: UIImage(named: "poolball")!, length: 6, name: "Pool Ball", key: 2),
        ImageDoublePair(image: UIImage(named: "sodacan")!, length: 12, name: "Soda Can", key: 3),
        ImageDoublePair(image: UIImage(named: "basketball")!, length: 24, name: "Basketball", key: 4),
        ImageDoublePair(image: UIImage(named: "pizza")!, length: 33, name: "Pizza Slice", key: 5),
        ImageDoublePair(image: UIImage(named: "baseballbat")!, length: 84, name: "Baseball Bat", key: 6),
        ImageDoublePair(image: UIImage(named: "poolstick")!, length: 146, name: "Pool Cue", key: 7),
        ImageDoublePair(image: UIImage(named: "couch")!, length: 200, name: "3-Person Couch", key: 8),
        ImageDoublePair(image: UIImage(named: "house")!, length: 550, name: "2-Story House", key: 9),
        ImageDoublePair(image: UIImage(named: "soccergoal")!, length: 732, name: "Soccer Goal", key: 10),
        ImageDoublePair(image: UIImage(named: "fieldgoal")!, length: 1372, name: "Football Field Goal", key: 11),
    ]
}
