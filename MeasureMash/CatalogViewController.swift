//
//  CatalogViewController.swift
//  MeasureMash
//
//  Created by Andrew Wang on 4/8/23.
//

import UIKit

class CatalogViewController: UIViewController {
    // Create a custom object called "ImageDoublePair" that contains an image and a double property
    class ImageDoublePair {
        var image: UIImage
        var length: Double
        var name: String
        
        init(image: UIImage, length: Double, name: String) {
            self.image = image
            self.length = length
            self.name = name
        }
    }

    // Create an array of ImageDoublePair objects
    var pairs = [
        ImageDoublePair(image: UIImage(named: "dice")!, length: 1.6, name: "Dice"),
        ImageDoublePair(image: UIImage(named: "poolball")!, length: 6, name: "Pool Ball"),
        ImageDoublePair(image: UIImage(named: "sodacan")!, length: 12, name: "Soda Can"),
        ImageDoublePair(image: UIImage(named: "basketball")!, length: 24, name: "Basketball"),
        ImageDoublePair(image: UIImage(named: "pizza")!, length: 33, name: "Pizza Slice"),
        ImageDoublePair(image: UIImage(named: "baseballbat")!, length: 84, name: "Baseball Bat"),
        ImageDoublePair(image: UIImage(named: "poolstick")!, length: 146, name: "Pool Cue"),
        ImageDoublePair(image: UIImage(named: "couch")!, length: 200, name: "3-Person Couch"),
        ImageDoublePair(image: UIImage(named: "soccergoal")!, length: 732, name: "Soccer Goal" ),
        ImageDoublePair(image: UIImage(named: "house")!, length: 1000, name: "3-Story House"),
        ImageDoublePair(image: UIImage(named: "fieldgoal")!, length: 1372, name: "Football Field Goal"),
    ]
    
    var minSort = false
    var scrollViewHeight: CGFloat = 0.0
    var unitType = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.DARK_BLUE

        // Do any additional setup after loading the view.
        
        //displaying imageviews
        for i in 1..<(pairs.count+1) {
            let pair = pairs[i - 1]
            let imageView = UIImageView(image: pair.image)
            let label = UILabel()
            label.numberOfLines = 2
            label.text = pair.name + ":\n " + String(pair.length) + " cm"
            label.textAlignment = .center
            if (i % 2 == 1) {
                imageView.frame = CGRect(x: 50, y: i * 100 + 40, width: 100, height: 100)
                label.frame = CGRect(x: 20, y: i * 100 + 140, width: 150, height: 70)
            } else {
                imageView.frame = CGRect(x: 250, y: (i-1) * 100 + 40, width: 100, height: 100)
                label.frame = CGRect(x: 220, y: (i-1) * 100 + 140, width: 150, height: 70)
            }
            if (i == pairs.count) {
                scrollViewHeight = CGFloat((i-1) * 100 + 500)
            }
            scrollView.addSubview(imageView)
            scrollView.addSubview(label)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scrollViewHeight)
        
        scrollView.addSubview(sortLabel)

        
        
       
    }
    @IBOutlet weak var sortButtonOutlet: UIButton!
    @IBOutlet weak var unitButtonOutlet: UIButton!
    @IBOutlet weak var sortLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func unitButton(_ sender: UIButton) {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        for i in 1..<(pairs.count+1) {
            let pair = pairs[i - 1]
            let imageView = UIImageView(image: pair.image)
            let label = UILabel()
            label.numberOfLines = 2
            if (unitType % 4 == 0) { //currently cm
                var conversion = pair.length/100
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " m"
                unitButtonOutlet.setTitle("meters", for: .normal)
            } else if (unitType % 4 == 1) { //currently meters
                var conversion = pair.length * 0.393701
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " in"
                unitButtonOutlet.setTitle("inches", for: .normal)
            } else if (unitType % 4 == 2) {
                var conversion = pair.length * 0.0328
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " ft"
                unitButtonOutlet.setTitle("feet", for: .normal)
            } else if (unitType % 4 == 3) {
                label.text = pair.name + ":\n " + String(round(pair.length*100)/100) + " cm"
                unitButtonOutlet.setTitle("centimeters", for: .normal)
            }
            label.textAlignment = .center
            if (i % 2 == 1) {
                imageView.frame = CGRect(x: 50, y: i * 100 + 40, width: 100, height: 100)
                label.frame = CGRect(x: 20, y: i * 100 + 140, width: 150, height: 70)
            } else {
                imageView.frame = CGRect(x: 250, y: (i-1) * 100 + 40, width: 100, height: 100)
                label.frame = CGRect(x: 220, y: (i-1) * 100 + 140, width: 150, height: 70)
            }
            if (i == pairs.count) {
                scrollViewHeight = CGFloat((i-1) * 100 + 500)
            }
            scrollView.addSubview(imageView)
            scrollView.addSubview(label)
        }
        
        scrollView.addSubview(sortLabel)
        scrollView.addSubview(unitButtonOutlet)
        scrollView.addSubview(sortButtonOutlet)
        unitType += 1
    }
    
    @IBAction func sortButton(_ sender: UIButton) {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        
        if (minSort) { //if button was min before
            pairs = pairs.sorted(by: { $0.length < $1.length })
                for subview in view.subviews {
                    if let imageView = subview as? UIImageView {
                        imageView.removeFromSuperview()
                    }
                    if let label = subview as? UILabel {
                        label.removeFromSuperview()
                    }
                }
            
            sortButtonOutlet.setTitle("minimum", for: .normal)
            minSort = false
            scrollView.addSubview(sortButtonOutlet)
            
        } else { //if button was max before
            pairs = pairs.sorted(by: { $0.length > $1.length })
                for subview in view.subviews {
                    if let imageView = subview as? UIImageView {
                        imageView.removeFromSuperview()
                    }
                    if let label = subview as? UILabel {
                        label.removeFromSuperview()
                    }
                }
            
            sortButtonOutlet.setTitle("maximum", for: .normal)
            minSort = true
            scrollView.addSubview(sortButtonOutlet)
            
            
        }
    
        //displaying imageviews
        for i in 1..<(pairs.count+1) {
            let pair = pairs[i - 1]
            let imageView = UIImageView(image: pair.image)
            let label = UILabel()
            label.numberOfLines = 2
            if (unitType % 4 == 1) { //currently cm
                var conversion = pair.length/100
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " m"
            } else if (unitType % 4 == 2) { //currently meters
                var conversion = pair.length * 0.393701
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " in"
            } else if (unitType % 4 == 3) {
                var conversion = pair.length * 0.0328
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " ft"
            } else if (unitType % 4 == 0) {
                label.text = pair.name + ":\n " + String(round(pair.length*100)/100) + " cm"
            }
            label.textAlignment = .center
            if (i % 2 == 1) {
                imageView.frame = CGRect(x: 50, y: i * 100 + 40, width: 100, height: 100)
                label.frame = CGRect(x: 20, y: i * 100 + 140, width: 150, height: 70)
            } else {
                imageView.frame = CGRect(x: 250, y: (i-1) * 100 + 40, width: 100, height: 100)
                label.frame = CGRect(x: 220, y: (i-1) * 100 + 140, width: 150, height: 70)
            }
            if (i == pairs.count) {
                scrollViewHeight = CGFloat((i-1) * 100 + 500)
            }
            scrollView.addSubview(imageView)
            scrollView.addSubview(label)
        }
        
        scrollView.addSubview(sortLabel)
        scrollView.addSubview(unitButtonOutlet)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
