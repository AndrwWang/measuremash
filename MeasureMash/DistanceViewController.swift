//
//  DistanceViewController.swift
//  MeasureMash
//
//  Created by Frank Gao on 4/9/23.
//

import UIKit

class DistanceViewController: UIViewController, UITextFieldDelegate {
    var delegate: ARViewController?
    var distanceLabel: UILabel!
    var distanceTextField: UITextField!
    var unitsLabel: UILabel!
    var unitsButton: UIButton!
    var confirmButton: UIButton!
    
    var popoverHeight: CGFloat = -1
    var popoverWidth: CGFloat = -1
    
    private var distance: Double = -1
    private var units: Objects.UNIT = .meters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.DARK_BLUE
        popoverWidth = preferredContentSize.width
        popoverHeight = preferredContentSize.height
        
        setup()
    }
    
    private func setup() {
        distanceLabel = UILabel()
        distanceLabel.text = "distance:"
        distanceLabel.textColor = Theme.PINK
        distanceLabel.setFontSize(popoverHeight / 10)
        distanceLabel.textAlignment = .right
        view.addSubview(distanceLabel)
        
        distanceTextField = UITextField()
        distanceTextField.font = UIFont.systemFont(ofSize: popoverHeight / 10)
        distanceTextField.backgroundColor = Theme.GOLD
        distanceTextField.borderStyle = .roundedRect
        distanceTextField.layer.borderWidth = 3
        distanceTextField.layer.cornerRadius = 15
        distanceTextField.layer.borderColor = Theme.PINK!.cgColor
        distanceTextField.clipsToBounds = true
        
        distanceTextField.delegate = self
        view.addSubview(distanceTextField)
        
        unitsLabel = UILabel()
        unitsLabel.text = "units:"
        unitsLabel.textColor = Theme.PINK
        unitsLabel.setFontSize(popoverHeight / 10)
        unitsLabel.textAlignment = .right
        view.addSubview(unitsLabel)
        
        unitsButton = UIButton()
        let units = NSAttributedString(string: "m",
                                       attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: popoverHeight / 10),
                                                    NSAttributedString.Key.foregroundColor : UIColor.black])
        unitsButton.setAttributedTitle(units, for: .normal)
        unitsButton.setBackgroundColor(color: Theme.PINK!, forState: .normal)
        unitsButton.titleLabel!.textAlignment = .center
        unitsButton.layer.cornerRadius = 15
        unitsButton.addTarget(self, action: #selector(unitsButtonTapped), for: .touchUpInside)
        view.addSubview(unitsButton)
        
        confirmButton = UIButton()
        let confirm = NSAttributedString(string: "confirm",
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: popoverHeight / 10),
                                                      NSAttributedString.Key.foregroundColor : UIColor.black])
        confirmButton.setAttributedTitle(confirm, for: .normal)
        confirmButton.setBackgroundColor(color: Theme.PINK!, forState: .normal)
        confirmButton.titleLabel!.textAlignment = .center
        confirmButton.layer.cornerRadius = 15
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.isEnabled = false
        view.addSubview(confirmButton)
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceTextField.translatesAutoresizingMaskIntoConstraints = false
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        unitsButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            distanceLabel.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            distanceLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            distanceTextField.topAnchor.constraint(equalTo: distanceLabel.topAnchor),
            distanceTextField.bottomAnchor.constraint(equalTo: distanceLabel.bottomAnchor),
            distanceTextField.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            distanceTextField.widthAnchor.constraint(equalToConstant: popoverWidth / 3),
            unitsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            unitsLabel.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            unitsLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            unitsButton.topAnchor.constraint(equalTo: unitsLabel.topAnchor, constant: 5),
            unitsButton.bottomAnchor.constraint(equalTo: unitsLabel.bottomAnchor, constant: -5),
            unitsButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            unitsButton.widthAnchor.constraint(equalToConstant: popoverWidth / 4),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: popoverWidth / 2),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func unitsButtonTapped() {
        switch units {
        case .meters:
            units = .centimeters
            unitsButton.setAttributedTitle(NSAttributedString(string: "cm", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: popoverHeight / 10)
            ]), for: .normal)
        case .centimeters:
            units = .feet
            unitsButton.setAttributedTitle(NSAttributedString(string: "ft", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: popoverHeight / 10)
            ]), for: .normal)
        case .feet:
            units = .inches
            unitsButton.setAttributedTitle(NSAttributedString(string: "in", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: popoverHeight / 10)
            ]), for: .normal)
        case .inches:
            units = .meters
            unitsButton.setAttributedTitle(NSAttributedString(string: "m", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: popoverHeight / 10)
            ]), for: .normal)
        }
    }
    
    @objc func confirmButtonTapped() {
        self.delegate?.distancePopoverDismissed(distance: distance, units: units)
        dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let newDistance = (Double(distanceTextField.text!)) {
            confirmButton.isEnabled = newDistance > 0
            if confirmButton.isEnabled { distance = newDistance }
        } else {
            confirmButton.isEnabled = false
        }
    }
}
