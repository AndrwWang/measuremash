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
    
    @IBOutlet weak var mashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.DARK_BLUE
        
        setupLabels()
    }
    
    // MARK: Display
    
    func setupLabels() {
        setupWelcomeSection()
        setupMashButton()
    }
    
    func setupWelcomeSection() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        measureMashLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeLabel.textColor = Theme.GOLD
        measureMashLabel.textColor = Theme.PINK
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
            logoImageView.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH / 5),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            descriptionLabel.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH * 3 / 4)
        ])
    }
    
    func setupMashButton() {
        mashButton.translatesAutoresizingMaskIntoConstraints = false
        
        let mash = NSAttributedString(string: "Mash!",
                                            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 40),
                                                         NSAttributedString.Key.foregroundColor : UIColor.black])
        mashButton.setAttributedTitle(mash, for: .normal)
        mashButton.setBackgroundColor(color: Theme.PINK!, forState: .normal)
        mashButton.titleLabel!.textAlignment = .center
        mashButton.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            mashButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mashButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mashButton.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH / 3)
        ])
    }
    
    @IBAction func mashButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController

        navigationController!.pushViewController(vc, animated: true)
    }
}
