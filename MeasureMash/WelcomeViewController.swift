//
//  WelcomeViewController.swift
//  MeasureMash
//
//  Created by Frank Gao on 4/7/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var measureMashLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var automaticButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#176087")
        
        setupLabels()
    }
    
    // MARK: Display
    
    func setupLabels() {
        setupWelcomeSection()
        setupOptionsSection()
    }
    
    func setupWelcomeSection() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        measureMashLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeLabel.textColor = Theme.GOLD
        measureMashLabel.textColor = Theme.LIGHT_BROWN
        descriptionLabel.textColor = Theme.GOLD
        
        welcomeLabel.setFontSize(Theme.SCREEN_HEIGHT / 30)
        measureMashLabel.setFontSize(Theme.SCREEN_HEIGHT / 20)
        descriptionLabel.setFontSize(Theme.SCREEN_HEIGHT / 40)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            measureMashLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: -20),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            measureMashLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: measureMashLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            descriptionLabel.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH * 3 / 4)
        ])
    }
    
    func setupOptionsSection() {
        optionsLabel.translatesAutoresizingMaskIntoConstraints = false
        manualButton.translatesAutoresizingMaskIntoConstraints = false
        automaticButton.translatesAutoresizingMaskIntoConstraints = false
        
        optionsLabel.textColor = Theme.GOLD
        optionsLabel.setFontSize(Theme.SCREEN_HEIGHT / 40)
        
        let automatic = NSAttributedString(string: "automatic",
                                            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 45),
                                                         NSAttributedString.Key.foregroundColor : UIColor.black])
        automaticButton.setAttributedTitle(automatic, for: .normal)
        automaticButton.setBackgroundColor(color: Theme.LIGHT_BROWN!, forState: .normal)
        automaticButton.titleLabel!.textAlignment = .center
        automaticButton.layer.cornerRadius = 15
        
        let manual = NSAttributedString(string: "manual",
                                            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 45),
                                                         NSAttributedString.Key.foregroundColor : UIColor.black])
        manualButton.setAttributedTitle(manual, for: .normal)
        manualButton.setBackgroundColor(color: Theme.LIGHT_BROWN!, forState: .normal)
        manualButton.titleLabel!.textAlignment = .center
        manualButton.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            optionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            optionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            manualButton.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor, constant: 10),
            manualButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            manualButton.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH / 3.5),
            automaticButton.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH / 3.5),
            automaticButton.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor, constant: 10),
            automaticButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10)
        ])
    }
    
    @IBAction func manualButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController

        navigationController!.pushViewController(vc, animated: true)
    }
}
