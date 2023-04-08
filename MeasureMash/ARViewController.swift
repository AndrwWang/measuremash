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
    var iv: UIImageView!
    private var configuration: ARImageTrackingConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector( handleTap(recognizer:) )))
        setupARView()
        setupOverlayView()
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
        view.addSubview(overlayView)
        
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: arView.centerYAnchor),
            overlayView.widthAnchor.constraint(equalTo: arView.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: arView.heightAnchor)
        ])
    }
    
    var refImages: [ARReferenceImage] = []
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        //get the coordinates of the tap
        let location = recognizer.location(in: view)
        print(location)
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
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        for i in 0..<frame.anchors.count {
            if let imageAnchor = frame.anchors[i] as? ARImageAnchor {
                let translation = simd_float3(x:
                                                        imageAnchor.transform.columns.3.x,
                                                      y: imageAnchor.transform.columns.3.y,
                                                      z: imageAnchor.transform.columns.3.z
                        )
                let transformation = frame.camera.projectPoint(translation, orientation: .portrait, viewportSize: overlayView.frame.size)
                overlayView.points.append(transformation)
            }
        }
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
