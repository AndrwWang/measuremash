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

class ARViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet weak var arView: ARView!
    private var overlayView: OverlayView!
    private var configuration: ARImageTrackingConfiguration!
    private var distance: Double = 200
    
    private var morePointsLabel: UILabel!
    private var distanceLabel: UILabel!
    private var objectsLabel: UILabel!
    private var chooseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.DARK_BLUE
        
        setupARView()
        setupOverlayView()
        configureBottomView()
        updateBottomView()
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
        distanceLabel = UILabel()
        baseStr = "distance: " + String(format: "%.2f", distance) + " m"
        attrStr = NSMutableAttributedString(string: baseStr, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 40),
            NSAttributedString.Key.foregroundColor : Theme.PINK! as UIColor
        ]
        )
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.GOLD! as UIColor, range: NSRange(location:10,length:baseStr.count - 10))
        
        distanceLabel.attributedText = attrStr
        distanceLabel.textAlignment = .center
        view.addSubview(distanceLabel)
        
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
        let automatic = NSAttributedString(string: "choose object",
                                           attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: Theme.SCREEN_HEIGHT / 45),
                                                        NSAttributedString.Key.foregroundColor : UIColor.black])
        chooseButton.setAttributedTitle(automatic, for: .normal)
        chooseButton.setBackgroundColor(color: Theme.PINK!, forState: .normal)
        chooseButton.titleLabel!.textAlignment = .center
        chooseButton.layer.cornerRadius = 15
        chooseButton.addTarget(self, action: #selector(chooseButtonTapped), for: .touchUpInside)
        view.addSubview(chooseButton)
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        objectsLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chooseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            chooseButton.heightAnchor.constraint(equalToConstant: Theme.SCREEN_HEIGHT / 35),
            chooseButton.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH / 2),
            chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: arView.bottomAnchor, constant: 10),
            distanceLabel.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            objectsLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10),
            objectsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            objectsLabel.widthAnchor.constraint(equalToConstant: Theme.SCREEN_WIDTH)
        ])
    }
    
    func updateBottomView() {
        if overlayView.points.count < 2 {
            // not enough points, prompt user to pick more points
            chooseButton.isHidden = true
            distanceLabel.isHidden = true
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
            distanceLabel.isHidden = false
            objectsLabel.isHidden = false
            morePointsLabel.isHidden = true
        }
    }
    
    @objc func chooseButtonTapped() {
        print("hello worl;d")
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
                if self.configuration == nil {
                    self.configuration = ARImageTrackingConfiguration()
                    self.configuration.maximumNumberOfTrackedImages = 2
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
    
    //method to test anchoring at points
    var midpointAnchor: ARAnchor!
    func addObjectAtMidpoint(anchor1 startAnchor: ARAnchor, anchor2 endAnchor: ARAnchor, angle: CGFloat) {
        guard let realitySceneURL = createRealityURL(filename: "Mash",
                                                     fileExtension: "reality",
                                                     sceneName: "Scene 1") else {
            return
        }
        let loadedScene = try! Entity.load(contentsOf: realitySceneURL)
        var newTransform = SCNMatrix4(startAnchor.transform)

        let rotation = SCNMatrix4MakeRotation(Float(angle) * Float.pi / 180, 0, 0, 1)
        newTransform = SCNMatrix4Mult(newTransform, rotation)
        
        var simdTransform = simd_float4x4(newTransform)
        simdTransform.columns.3 = 0.5 * (startAnchor.transform.columns.3 + endAnchor.transform.columns.3)

        midpointAnchor = ARAnchor(transform: simdTransform)
        let anchorEntity = AnchorEntity(anchor: midpointAnchor)
        arView.session.add(anchor: midpointAnchor)
        anchorEntity.addChild(loadedScene)
        arView.scene.anchors.append(anchorEntity)
    }
    
    var mashAnchors: [ARAnchor] = []
    func measureMash(anchor1 startAnchor: ARAnchor, anchor2 endAnchor: ARAnchor, angle: CGFloat, distanceInMeters: Double) {
        guard let realitySceneURL = createRealityURL(filename: "Mash",
                                                     fileExtension: "reality",
                                                     sceneName: "Scene 1") else {
            return
        }
        var loadedScene = try! Entity.load(contentsOf: realitySceneURL)
        let bounds = loadedScene.visualBounds(relativeTo: .none)

        //get rotation matrix
        var newTransform = SCNMatrix4(startAnchor.transform)
        let angleInRadians = Float(angle) * Float.pi / 180
        let rotation = SCNMatrix4MakeRotation(angleInRadians, 0, 0, 1)
        newTransform = SCNMatrix4Mult(newTransform, rotation)

        let width = (bounds.max.x - bounds.min.x) * (cos(angleInRadians))
        let height = (bounds.max.x - bounds.min.x) * (sin(angleInRadians))

        var current = startAnchor.transform.columns.3
        var end = endAnchor.transform.columns.3
        
        //swap two points if necessary
        if current.x > end.x {
            let temp = current
            current = end
            end = temp
        }
        
        current.x += width / 2
        current.y += height / 2
        mashAnchors = []
        while current.x < end.x {
            var simdTransform = simd_float4x4(newTransform)
            
            simdTransform.columns.3 = current
            mashAnchors.append(ARAnchor(transform: simdTransform))
            
            current.x += width
            current.y += height
        }

        for m in mashAnchors {
            let anchorEntity = AnchorEntity(anchor: m)
            arView.session.add(anchor: m)
            
            loadedScene = try! Entity.load(contentsOf: realitySceneURL)
            anchorEntity.addChild(loadedScene)
            arView.scene.anchors.append(anchorEntity)
        }
    }
    
    private func pointPairToBearingDegrees(startingPoint: CGPoint, secondPoint endingPoint: CGPoint) -> CGFloat {
        var start = CGPoint(x: startingPoint.x, y: startingPoint.y)
         var end = CGPoint(x: endingPoint.x, y: endingPoint.y)
         
         if startingPoint.x > endingPoint.x {
         // swap starting an ending points if wrong order
         let temp: CGPoint = CGPoint(x: start.x, y: start.y)
         start.x = end.x
         start.y = end.y
         end.x = temp.x
         end.y = temp.y
         }
        
        let originPoint = CGPoint(x: end.x - start.x, y: end.y - start.y)
        let bearingRadians = atan2f(Float(originPoint.y), Float(originPoint.x))
        var bearingDegrees = bearingRadians * (180.0 / .pi)
        bearingDegrees = bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)
        return CGFloat(bearingDegrees)
    }
    
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
        
        if overlayView.points.count == 2 && delay % 30 == 0 {
            for m in mashAnchors { arView.session.remove(anchor: m) }
            let degrees = pointPairToBearingDegrees(startingPoint: overlayView.points[0], secondPoint: overlayView.points[1])
            var finalAngle = Double(degrees.remainder(dividingBy: 180))
            if Int(degrees) / 180 > 0 {
                finalAngle *= -1
            }
            
            measureMash(anchor1: imageAnchors[0], anchor2: imageAnchors[1], angle: finalAngle, distanceInMeters: 200)
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
}
