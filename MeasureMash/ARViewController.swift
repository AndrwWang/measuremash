//
//  ViewController.swift
//  MeasureMash
//
//  Created by Andrew Wang on 4/7/23.
//

import UIKit
import RealityKit
import ARKit
import SpriteKit
import Combine

class ARViewController: UIViewController, ARSessionDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var arView: ARView!
    private var overlayView: OverlayView!
    private var configuration = ARImageTrackingConfiguration()
    
    private var morePointsLabel: UILabel!
    private var distanceButton: UIButton!
    private var objectsLabel: UILabel!
    private var chooseButton: UIButton!
    
    private var object = Objects.pairs[0]
    var displayDistance: Double = 0.1
    private var distanceInMeters: Double = 0.1
    private var numFit = 0
    var units: Objects.UNIT = .meters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.DARK_BLUE
        configuration.maximumNumberOfTrackedImages = 2
        setupResetButton()
        setupARView()
        setupOverlayView()
        configureBottomView()
        updateBottomView()
    }
    
    func setupResetButton() {
        
        let resetButton = UIButton()
        resetButton.setTitle("Reset", for: .normal)
        
        resetButton.setBackgroundColor(color: Theme.PINK!, forState: .normal)
        resetButton.layer.cornerRadius = 15
        
        resetButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        resetButton.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH / 5).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH / 12).isActive = true
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: resetButton)
    }
    
    @objc func resetButtonTapped() {
        overlayView.points.removeAll()
        refImages.removeAll()
        mashAnchors.removeAll()
        configuration.trackingImages.removeAll()
        arView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking, .resetSceneReconstruction])
    }
    
    func setupARView() {
        arView.session.delegate = self
        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leftAnchor.constraint(equalTo: view.leftAnchor),
            arView.rightAnchor.constraint(equalTo: view.rightAnchor),
            arView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
        ])
    }
    
    func setupOverlayView() {
        overlayView = OverlayView()
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector( handleTap(recognizer:) )))
        view.addSubview(overlayView)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: arView.centerYAnchor),
            overlayView.widthAnchor.constraint(equalTo: arView.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: arView.heightAnchor)
        ])
    }
    
    func updateObjectsLabel() {
        var name = object.name.lowercased() + "s"
        if name == "dies" { name = "dice" }
        
        let baseStr = "number of \(name) that can fit: \(numFit)"
        let attrStr = NSMutableAttributedString(string: baseStr, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 45),
            NSAttributedString.Key.foregroundColor : Theme.PINK! as UIColor
        ]
        )
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location: 10, length: name.count))
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location: baseStr.count - 2, length: 2))
        
        objectsLabel.attributedText = attrStr
    }
    
    func updateDistanceLabel() {
        var newStr = "distance: " + String(format: "%.2f", displayDistance) + " "
        switch units {
        case .meters:
            newStr += "m"
        case .centimeters:
            newStr += "cm"
        case .feet:
            newStr += "ft"
        case .inches:
            newStr += "in"
        }
        
        let attrStr = NSMutableAttributedString(string: newStr, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 40),
            NSAttributedString.Key.foregroundColor : Theme.PINK! as UIColor
        ]
        )
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location:10,length:newStr.count - 10))
        
        distanceButton.setAttributedTitle(attrStr, for: .normal)
    }
    
    func configureBottomView() {
        var baseStr: String!
        var attrStr: NSMutableAttributedString!
        morePointsLabel = UILabel()
        baseStr = "select \(2 - overlayView.points.count) more points"
        attrStr = NSMutableAttributedString(string: baseStr, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 40),
            NSAttributedString.Key.foregroundColor : Theme.PINK! as UIColor
        ]
        )
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location:7,length:baseStr.count - 19))
        
        morePointsLabel.attributedText = attrStr
        morePointsLabel.textAlignment = .center
        if morePointsLabel.superview != nil {
            morePointsLabel.removeFromSuperview()
        }
        view.addSubview(morePointsLabel)
        
        morePointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            morePointsLabel.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH * 2 / 3),
            morePointsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            morePointsLabel.topAnchor.constraint(equalTo: arView.bottomAnchor),
            morePointsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        distanceButton = UIButton()
        baseStr = "distance: " + String(format: "%.2f", displayDistance) + " m"
        attrStr = NSMutableAttributedString(string: baseStr, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 40),
            NSAttributedString.Key.foregroundColor : Theme.PINK! as UIColor
        ]
        )
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location:10,length:baseStr.count - 10))
        
        distanceButton.setAttributedTitle(attrStr, for: .normal)
        distanceButton.setBackgroundColor(color: Theme.DARK_BLUE!, forState: .normal)
        distanceButton.layer.borderWidth = 3
        distanceButton.layer.cornerRadius = 15
        distanceButton.layer.borderColor = Theme.PINK!.cgColor
        distanceButton.clipsToBounds = true
        distanceButton.addTarget(self, action: #selector(distanceButtonTapped), for: .touchUpInside)
        view.addSubview(distanceButton)
        
        objectsLabel = UILabel()
        baseStr = "number of bananas that can fit: 30"
        attrStr = NSMutableAttributedString(string: baseStr, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 40),
            NSAttributedString.Key.foregroundColor : Theme.PINK! as UIColor
        ]
        )
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location: 10, length: 7))
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location: baseStr.count - 2, length: 2))
        
        objectsLabel.attributedText = attrStr
        objectsLabel.textAlignment = .center
        view.addSubview(objectsLabel)
        
        chooseButton = UIButton()
        let choose = NSAttributedString(string: "choose object",
                                           attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 45),
                                                        NSAttributedString.Key.foregroundColor : UIColor.black])
        chooseButton.setAttributedTitle(choose, for: .normal)
        chooseButton.setBackgroundColor(color: Theme.PINK!, forState: .normal)
        chooseButton.titleLabel!.textAlignment = .center
        chooseButton.layer.cornerRadius = 15
        chooseButton.addTarget(self, action: #selector(chooseButtonTapped), for: .touchUpInside)
        view.addSubview(chooseButton)
        
        distanceButton.translatesAutoresizingMaskIntoConstraints = false
        objectsLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chooseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            chooseButton.heightAnchor.constraint(equalToConstant: Theme.SCREEN_HEIGHT / 35),
            chooseButton.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH / 2),
            chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceButton.topAnchor.constraint(equalTo: arView.bottomAnchor, constant: 10),
            distanceButton.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH * 2 / 3),
            distanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            objectsLabel.topAnchor.constraint(equalTo: distanceButton.bottomAnchor, constant: 10),
            objectsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            objectsLabel.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH)
        ])
    }
    
    @objc func distanceButtonTapped() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"DistanceViewController") {
            arView.session.pause()
            
            vc.modalTransitionStyle   = .coverVertical
            vc.modalPresentationStyle = .popover
            vc.isModalInPresentation = true
            vc.popoverPresentationController?.sourceView = self.view
            vc.popoverPresentationController?.sourceRect =
            CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
            vc.popoverPresentationController?.delegate = self
            
            vc.preferredContentSize = CGSize(width: Theme.SCREEN_WIDTH * 3 / 4, height: Theme.SCREEN_HEIGHT / 3)
            
            (vc as! DistanceViewController).delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func distancePopoverDismissed(distance: Double, units: Objects.UNIT) {
        var computedDistance = distance
        switch units {
        case .meters:
            break
        case .centimeters:
            computedDistance /= 100
        case .feet:
            computedDistance *= 0.3048
        case .inches:
            computedDistance = (computedDistance / 12) * 0.3048
        }
        
        self.distanceInMeters = computedDistance
        self.displayDistance = distance
        self.units = units
        
        updateDistanceLabel()
        updateObjectsLabel()
        
        arView.session.run(configuration)
    }
    
    func updateBottomView() {
        if overlayView.points.count < 2 {
            // not enough points, prompt user to pick more points
            chooseButton.isHidden = true
            distanceButton.isHidden = true
            objectsLabel.isHidden = true
            morePointsLabel.isHidden = false
            
            let baseStr = "select \(2 - overlayView.points.count) more points"
            let attrStr = NSMutableAttributedString(string: baseStr, attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 40),
                NSAttributedString.Key.foregroundColor : Theme.PINK! as UIColor
            ]
            )
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location:7,length:baseStr.count - 19))
            morePointsLabel.attributedText = attrStr
        } else {
            // two points have been chosen, display information regarding the points
            chooseButton.isHidden = false
            distanceButton.isHidden = false
            objectsLabel.isHidden = false
            morePointsLabel.isHidden = true
            
            updateDistanceLabel()
            updateObjectsLabel()
        }
    }
    
    @objc func chooseButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CatalogViewController") as! CatalogViewController
        
        navigationController!.pushViewController(vc, animated: true)
    }
    
    //called from CatalogViewController
    func objectChosen(_ index: Int) {
        object = Objects.pairs[index]
    }
    
    var refImages: [ARReferenceImage] = []
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        //get the coordinates of the tap
        let location = recognizer.location(in: overlayView)
        if let img = screenshot(captureRect: CGRect(x: location.x - 100, y: location.y - 100, width: 200, height: 200)).cgImage {
            let referenceImage = ARReferenceImage(img, orientation: .up, physicalWidth: 0.4)
            referenceImage.validate(completionHandler: { res in
                if (res != nil) { // reference image not high quality enough to be tracked
                    print("bad image")
                    return
                }
                
                if self.refImages.count >= 2 {
                    self.refImages.remove(at: 0)
                }
                self.refImages.append(referenceImage)
                
                self.configuration.trackingImages = Set(self.refImages.map { $0 })
                self.arView.session.run(self.configuration, options: .removeExistingAnchors)
            })
            
        }
    }
    
    private func createRealityURL(filename: String,
                                  fileExtension: String,
                                  sceneName:String) -> URL? {
        // Create a URL that points to the specified Reality file.
        guard let realityFileURL = Bundle.main.url(forResource: filename,
                                                   withExtension: fileExtension) else {
            print("Error finding Reality file \(filename).\(fileExtension)")
            return nil
        }
        
        // Append the scene name to the URL to point to
        // a single scene within the file.
        let realityFileSceneURL = realityFileURL.appendingPathComponent(sceneName,
                                                                        isDirectory: false)
        return realityFileSceneURL
    }
    
    var streams = [Combine.AnyCancellable]()
    func loadRealityComposerSceneAsync (filename: String,
                                        fileExtension: String,
                                        sceneName: String,
                                        completion: @escaping (Swift.Result<(Entity & HasAnchoring)?, Swift.Error>) -> Void) {
        
        guard let realityFileSceneURL = createRealityURL(filename: filename, fileExtension: fileExtension, sceneName: sceneName) else {
            print("Error: Unable to find specified file in application bundle")
            return
        }
        
        let loadRequest = Entity.loadAnchorAsync(contentsOf: realityFileSceneURL)
        let cancellable = loadRequest.sink(receiveCompletion: { (loadCompletion) in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
        }, receiveValue: { (entity) in
            completion(.success(entity))
        })
        cancellable.store(in: &streams)
    }
    
    var mashAnchors: [ARAnchor] = []
    func measureMash(anchor1 startAnchor: ARAnchor, anchor2 endAnchor: ARAnchor, angle: CGFloat, distanceInMeters: Double) {
        loadRealityComposerSceneAsync(filename: "Mash", fileExtension: "reality", sceneName: object.name, completion: { [self] result in
            switch result {
            case .success(let entity):
                for m in mashAnchors { arView.session.remove(anchor: m) }
                
                var bounds = entity!.visualBounds(relativeTo: .none)
                
                var current = startAnchor.transform.columns.3
                var end = endAnchor.transform.columns.3
                
                //swap two points if necessary
                if current.x > end.x {
                    let temp = current
                    current = end
                    end = temp
                }
                
                //scale the object
                let objectToLineRatio = (object.length / 100) / distanceInMeters
                let idealObjectWidth = objectToLineRatio * simd_distance(simd_double4(current), simd_double4(end))
                let scale = idealObjectWidth / Double(bounds.max.x - bounds.min.x)
                entity!.transform.scale *= Float(scale)
                
                //get rotation matrix
                var newTransform = SCNMatrix4(startAnchor.transform)
                let angleInRadians = Float(angle) * Float.pi / 180
                let rotation = SCNMatrix4MakeRotation(angleInRadians, 0, 0, 1)
                newTransform = SCNMatrix4Mult(newTransform, rotation)
                
                //calculate rotated width and height
                bounds = entity!.visualBounds(relativeTo: .none)
                let width = (bounds.max.x - bounds.min.x) * (cos(angleInRadians))
                let height = (bounds.max.x - bounds.min.x) * (sin(angleInRadians))
                
                current.x += width / 2
                current.y += height / 2

                mashAnchors = []
                while current.x < end.x && ((height < 0 && current.y > end.y) || (height > 0 && current.y < end.y)) {
                    var simdTransform = simd_float4x4(newTransform)
                    
                    simdTransform.columns.3 = current
                    mashAnchors.append(ARAnchor(transform: simdTransform))
                    
                    current.x += width
                    current.y += height
                }
                
                numFit = mashAnchors.count
                for m in mashAnchors {
                    let anchorEntity = AnchorEntity(anchor: m)
                    arView.session.add(anchor: m)
                    
                    let copy = entity!.clone(recursive: true)
                    anchorEntity.addChild(copy)
                    arView.scene.anchors.append(anchorEntity)
                }
            case .failure(let error):
                print("failed to get entity")
            }
            
        })
    }
    
    private func pointPairToBearingDegrees(startingPoint: CGPoint, secondPoint endingPoint: CGPoint) -> CGFloat {
        var start = CGPoint(x: startingPoint.x, y: startingPoint.y)
        var end = CGPoint(x: endingPoint.x, y: endingPoint.y)
        
        
        if startingPoint.y < endingPoint.y {
            // swap starting an ending points if wrong order
            let temp = start
            start = end
            end = temp
        }
        
        let originPoint = CGPoint(x: end.x - start.x, y: end.y - start.y)
        let bearingRadians = atan2f(Float(originPoint.y), Float(originPoint.x))
        var bearingDegrees = bearingRadians * (180.0 / .pi)
        bearingDegrees = bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)
        return CGFloat(bearingDegrees)
    }
    
    //delay rendering to reduce lag
    var delay = 0
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        var transformations: [CGPoint] = []
        var imageAnchors: [ARImageAnchor] = []
        for i in 0..<frame.anchors.count {
            if let imageAnchor = frame.anchors[i] as? ARImageAnchor {
                imageAnchors.append(imageAnchor)
                let translation = simd_float3(x:
                                                imageAnchor.transform.columns.3.x,
                                              y: imageAnchor.transform.columns.3.y,
                                              z: imageAnchor.transform.columns.3.z
                )
                let transformation = frame.camera.projectPoint(translation, orientation: .portrait, viewportSize: overlayView.frame.size)
                transformations.append(transformation)
            }
        }
        
        overlayView.points = []
        for t in transformations {
            overlayView.points.append(t)
        }
        
        if overlayView.points.count == 2 && !((overlayView.points[0].x - overlayView.points[1].x) < 0.001 && (overlayView.points[0].y - overlayView.points[1].y) < 0.001) && delay % 30 == 0 {
            let degrees = pointPairToBearingDegrees(startingPoint: overlayView.points[0], secondPoint: overlayView.points[1])
            var finalAngle = Double(degrees.remainder(dividingBy: 180))
            if Int(degrees) / 180 > 0 {
                finalAngle *= -1
            }
            
            measureMash(anchor1: imageAnchors[0], anchor2: imageAnchors[1], angle: finalAngle, distanceInMeters: distanceInMeters)
            delay = 1
        } else {
            delay += 1
        }
        
        updateBottomView()
    }
    
    func screenshot(captureRect: CGRect) -> UIImage {
        // Get the bounds of the view
        let bounds = view.bounds
        
        // Create a renderer that will render the view into an image
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        // Render the view into an image
        let image = renderer.image { (context) in
            view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        
        // Define the crop rect
        let cropRect = captureRect
        
        // Scale crop rect to account for image scale
        let scaledCropRect = CGRect(x: cropRect.origin.x * image.scale,
                                    y: cropRect.origin.y * image.scale,
                                    width: cropRect.size.width * image.scale,
                                    height: cropRect.size.height * image.scale)
        
        // Get the CGImage of the cropped region
        let croppedCGImage = image.cgImage!.cropping(to: scaledCropRect)
        
        // Create a new UIImage from the cropped CGImage
        let croppedImage = UIImage(cgImage: croppedCGImage!, scale: image.scale, orientation: image.imageOrientation)
        
        return croppedImage
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
