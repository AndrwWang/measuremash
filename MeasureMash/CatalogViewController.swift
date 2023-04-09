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
        var key: Int
        
        init(image: UIImage, length: Double, name: String, key: Int) {
            self.image = image
            self.length = length
            self.name = name
            self.key = key
        }
    }
    // Create an array of ImageDoublePair objects
    var pairs = [
        ImageDoublePair(image: UIImage(named: "dice")!, length: 1.6, name: "Dice", key: 1),
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
    
    var minSort = false
    var scrollViewHeight: CGFloat = 0.0
    var unitType = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.DARK_BLUE
        
        //displaying imageviews
        for i in 1..<(pairs.count+1) {
            let pair = pairs[i - 1]
            let imageView = UIImageView(image: pair.image)
            let label = UILabel()
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            let buttonAttributes = NSAttributedString(string: "Select",
                                                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 45),
                                                             NSAttributedString.Key.foregroundColor : UIColor.black])
            button.setAttributedTitle(buttonAttributes, for: .normal)
            button.setBackgroundColor(color: Theme.LIGHT_BROWN!, forState: .normal)
            button.titleLabel!.textAlignment = .center
            button.layer.cornerRadius = 15
            
            label.numberOfLines = 2
            label.text = pair.name + ":\n " + String(pair.length) + " cm"
            label.textAlignment = .center
            if (i % 2 == 1) { //left column
                imageView.frame = CGRect(x: 50, y: i * 120 - 10, width: 100, height: 100)
                label.frame = CGRect(x: 20, y: i * 120 + 90, width: 150, height: 70)
                button.frame = CGRect(x: 55, y: i * 120 + 155, width: 80, height: 40)
            } else { //right column
                imageView.frame = CGRect(x: 250, y: (i-1) * 120 - 10, width: 100, height: 100)
                label.frame = CGRect(x: 220, y: (i-1) * 120 + 90, width: 150, height: 70)
                button.frame = CGRect(x: 255, y: (i-1) * 120 + 155, width: 80, height: 40)
                
            }
            if (i == pairs.count) {
                scrollViewHeight = CGFloat((i-1) * 120 + 500)
            }
            label.textColor = Theme.GOLD
            scrollView.addSubview(button)
            scrollView.addSubview(imageView)
            scrollView.addSubview(label)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scrollViewHeight)
        
        
        let sortLabelAttributes = NSAttributedString(string: "minimum", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 50), NSAttributedString.Key.foregroundColor : Theme.GOLD as Any])
        sortButtonOutlet.setAttributedTitle(sortLabelAttributes, for: .normal)
        scrollView.addSubview(sortButtonOutlet)
        
        let unitLabelAttributes = NSAttributedString(string: "centimeters", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 50), NSAttributedString.Key.foregroundColor : Theme.GOLD as Any])
        unitButtonOutlet.setAttributedTitle(unitLabelAttributes, for: .normal)
        scrollView.addSubview(unitButtonOutlet)
        
        polishLabels()
        
        
        
        
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sortButtonOutlet: UIButton!
    @IBOutlet weak var unitButtonOutlet: UIButton!
    @IBOutlet weak var sortLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func unitButton(_ sender: UIButton) {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        var unitLabelAttributes: NSAttributedString
        
        for i in 1..<(pairs.count+1) {
            let pair = pairs[i - 1]
            let imageView = UIImageView(image: pair.image)
            let label = UILabel()
            label.numberOfLines = 2
            
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            let buttonAttributes = NSAttributedString(string: "Select",
                                                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 45),
                                                             NSAttributedString.Key.foregroundColor : UIColor.black])
            button.setAttributedTitle(buttonAttributes, for: .normal)
            button.setBackgroundColor(color: Theme.LIGHT_BROWN!, forState: .normal)
            button.titleLabel!.textAlignment = .center
            button.layer.cornerRadius = 15
            
            if (unitType % 4 == 0) { //currently cm
                let conversion = pair.length/100
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " m"
                unitLabelAttributes = NSAttributedString(string: "meters", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 50), NSAttributedString.Key.foregroundColor : Theme.GOLD as Any])
            } else if (unitType % 4 == 1) { //currently meters
                let conversion = pair.length * 0.393701
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " in"
                unitLabelAttributes = NSAttributedString(string: "inches", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 50), NSAttributedString.Key.foregroundColor : Theme.GOLD as Any])
            } else if (unitType % 4 == 2) {
                let conversion = pair.length * 0.0328
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " ft"
                unitLabelAttributes = NSAttributedString(string: "feet", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 50), NSAttributedString.Key.foregroundColor : Theme.GOLD as Any])
            } else {
                label.text = pair.name + ":\n " + String(round(pair.length*100)/100) + " cm"
                unitLabelAttributes = NSAttributedString(string: "centimeters", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 50), NSAttributedString.Key.foregroundColor : Theme.GOLD as Any])
            }
            label.textAlignment = .center
            if (i % 2 == 1) {
                imageView.frame = CGRect(x: 50, y: i * 120 - 10, width: 100, height: 100)
                label.frame = CGRect(x: 20, y: i * 120 + 90, width: 150, height: 70)
                button.frame = CGRect(x: 55, y: i * 120 + 155, width: 80, height: 40)
            } else {
                imageView.frame = CGRect(x: 250, y: (i-1) * 120 - 10, width: 100, height: 100)
                label.frame = CGRect(x: 220, y: (i-1) * 120 + 90, width: 150, height: 70)
                button.frame = CGRect(x: 255, y: (i-1) * 120 + 155, width: 80, height: 40)
            }
            if (i == pairs.count) {
                scrollViewHeight = CGFloat((i-1) * 100 + 500)
            }
            unitButtonOutlet.setAttributedTitle(unitLabelAttributes, for: .normal)
            label.textColor = Theme.GOLD
            scrollView.addSubview(button)
            scrollView.addSubview(imageView)
            scrollView.addSubview(label)
        }
    
        scrollView.addSubview(sortLabel)
        scrollView.addSubview(unitButtonOutlet)
        scrollView.addSubview(sortButtonOutlet)
        scrollView.addSubview(titleLabel)
        unitType += 1
        polishLabels()
    }
    
    @IBAction func sortButton(_ sender: UIButton) {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        var sortLabelAttributes: NSAttributedString
        
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
            sortLabelAttributes = NSAttributedString(string: "minimum", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 50), NSAttributedString.Key.foregroundColor : Theme.GOLD as Any])
            minSort = false
            
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
            sortLabelAttributes = NSAttributedString(string: "maximum", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 50), NSAttributedString.Key.foregroundColor : Theme.GOLD as Any])
            minSort = true
        }
       
        sortButtonOutlet.setAttributedTitle(sortLabelAttributes, for: .normal)
        scrollView.addSubview(sortButtonOutlet)
        
        //displaying imageviews
        for i in 1..<(pairs.count+1) {
            let pair = pairs[i - 1]
            let imageView = UIImageView(image: pair.image)
            let label = UILabel()
            label.numberOfLines = 2
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            let buttonAttributes = NSAttributedString(string: "Select",
                                                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 45),
                                                             NSAttributedString.Key.foregroundColor : UIColor.black])
            button.setAttributedTitle(buttonAttributes, for: .normal)
            button.setBackgroundColor(color: Theme.LIGHT_BROWN!, forState: .normal)
            button.titleLabel!.textAlignment = .center
            button.layer.cornerRadius = 15
            
            if (unitType % 4 == 1) { //currently cm
                let conversion = pair.length/100
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " m"
            } else if (unitType % 4 == 2) { //currently meters
                let conversion = pair.length * 0.393701
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " in"
            } else if (unitType % 4 == 3) {
                let conversion = pair.length * 0.0328
                label.text = pair.name + ":\n " + String(round(conversion*100)/100) + " ft"
            } else if (unitType % 4 == 0) {
                label.text = pair.name + ":\n " + String(round(pair.length*100)/100) + " cm"
            }
            label.textAlignment = .center
            if (i % 2 == 1) {
                imageView.frame = CGRect(x: 50, y: i * 120 - 10, width: 100, height: 100)
                label.frame = CGRect(x: 20, y: i * 120 + 90, width: 150, height: 70)
                button.frame = CGRect(x: 55, y: i * 120 + 155, width: 80, height: 40)
            } else {
                imageView.frame = CGRect(x: 250, y: (i-1) * 120 - 10, width: 100, height: 100)
                label.frame = CGRect(x: 220, y: (i-1) * 120 + 90, width: 150, height: 70)
                button.frame = CGRect(x: 255, y: (i-1) * 120 + 155, width: 80, height: 40)
            }
            if (i == pairs.count) {
                scrollViewHeight = CGFloat((i-1) * 100 + 500)
            }
            label.textColor = Theme.GOLD
            scrollView.addSubview(imageView)
            scrollView.addSubview(label)
            scrollView.addSubview(button)
        }
        
        scrollView.addSubview(sortLabel)
        scrollView.addSubview(unitButtonOutlet)
        scrollView.addSubview(titleLabel)
        polishLabels()

        
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let pairIndex = sender.tag - 1
        let pair = pairs[pairIndex]
        print(pair.key)
        //performSegue(withIdentifier: "showNewScreen", sender: pair)
    }
    
    func polishLabels() {
        
        
        titleLabel.frame = CGRect(x: Theme.SCREEN_WIDTH/3.2, y: 10, width: 200 , height: 70)
        sortLabel.textAlignment = .left
        sortButtonOutlet.titleLabel?.textAlignment = .left
        unitButtonOutlet.titleLabel?.textAlignment = .left
        
        sortLabel.frame = CGRect(x: 80, y: 36, width: 200 , height: 70)
        sortButtonOutlet.frame = CGRect(x: 130, y: 15, width: 102 , height: 70)
        unitButtonOutlet.frame = CGRect(x: 230, y: 15, width: 120 , height: 70)
        
        sortLabel.text = "sort by\t\t\t\t in"
        titleLabel.textColor = Theme.LIGHT_BROWN
        titleLabel.setFontSize(Theme.SCREEN_HEIGHT/40)
        sortLabel.textColor = Theme.LIGHT_BROWN
        sortLabel.setFontSize(Theme.SCREEN_HEIGHT/50)
        sortButtonOutlet.setTitleColor(Theme.GOLD, for: .normal)
        unitButtonOutlet.setTitleColor(Theme.GOLD, for: .normal)
        
        
    }
}
