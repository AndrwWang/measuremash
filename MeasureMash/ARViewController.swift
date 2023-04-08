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
    
    var originPoint: CGPoint = CGPoint(x: 0, y: 0)
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        //get the coordinates of the tap
        let location = recognizer.location(in: view)
        print(location)
        if let img = screenshot(captureRect: CGRect(x: location.x - 50, y: location.y - 50, width: 100, height: 100)).cgImage {
            let referenceImage = ARReferenceImage(img, orientation: .up, physicalWidth: 0.2)
            let configuration = ARImageTrackingConfiguration()
            configuration.maximumNumberOfTrackedImages = 1
            configuration.trackingImages = [referenceImage]
            arView.session.run(configuration, options: .removeExistingAnchors)
        }
        
        
        
        //displayDebugImageView(image: image)
        /*
         //get an array of all objects that were raycasted
         let vResults = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .vertical)
         let hResults = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
         
         //check if anything was hit(returned from the raycast method)
         var anchor: ARAnchor?
         if let vertical = vResults.first {
         //in order to place objects onto the scene, always create an anchor first
         anchor = ARAnchor(name: "sneaker", transform: vertical.worldTransform)
         placePoint(for: anchor!, vertical: true)
         } else if let horizontal = hResults.first {
         anchor = ARAnchor(name: "sneaker", transform: horizontal.worldTransform)
         placePoint(for: anchor!, vertical: false)
         } else {
         print("no surface found, so the object couldn't be placed")
         
         }
         */
    }
    
    private func displayDebugImageView(image: UIImage) {
        iv = UIImageView(image: image)
        view.addSubview(iv)
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            iv.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iv.widthAnchor.constraint(equalToConstant: 100),
            iv.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        print(iv.frame)
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
    
    func placePoint(for anchor: ARAnchor, vertical: Bool) {
        //make the "try" optional if unsure that the entity exists
        //let entity = try! ModelEntity.loadModel(named: "point")
        
        //entity.generateCollisionShapes(recursive: true)
        
        
        guard let realitySceneURL = createRealityURL(filename: "point",
                                                     fileExtension: "reality",
                                                     sceneName: "VerticalScene") else {
            return
        }
        let loadedScene = try! Entity.load(contentsOf: realitySceneURL)
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        arView.session.add(anchor: anchor)
        anchorEntity.addChild(loadedScene)
        //arView.scene.addAnchor(anchorEntity)
        arView.scene.anchors.append(anchorEntity)
    }
    
    var count = 0
    var translationSum = simd_float3(x: 0, y: 0, z: 0)
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("found")
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        /*print(simd_float3(x: frame.camera.transform.columns.3.x, y: frame.camera.transform.columns.3.y, z: frame.camera.transform.columns.3.z))
         if (count < 5) {
         translationSum += simd_float3(x: frame.camera.transform.columns.3.x, y: frame.camera.transform.columns.3.y, z: frame.camera.transform.columns.3.z)
         count += 1
         } else {
         print(translationSum / 5
         let projection = frame.camera.projectPoint(translationSum / 5, orientation: .portrait, viewportSize: overlayView.frame.size)
         overlayView.location = projection
         translationSum = simd_float3.zero
         count = 0
         }*/
        //print(String(format: "%.2f, %.2f, %.2f", frame.camera.transform.columns.3.x, frame.camera.transform.columns.3.y, frame.camera.transform.columns.3.z))
        let translation = simd_float3(x:
                                        frame.camera.transform.columns.3.x * 10000,
                                      y: frame.camera.transform.columns.3.y * 10000,
                                      z: frame.camera.transform.columns.3.z * 10000
        )
        let transformation = frame.camera.projectPoint(translation, orientation: .portrait, viewportSize: overlayView.frame.size)
        overlayView.location.x = transformation.x - originPoint.x
        overlayView.location.y = transformation.y - originPoint.y
        
        for anchor in frame.anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                // Image anchor found, perform additional processing/rendering
                let imageName = imageAnchor.referenceImage.name ?? "unknown image"
                print("Image anchor found for image: \(imageName)")
                
                let sphere = MeshResource.generateSphere(radius: 0.05)
                let material = SimpleMaterial(color: .red, isMetallic: true)
                let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
                
                let sphereAnchor = AnchorEntity(anchor: imageAnchor)
                sphereAnchor.addChild(sphereEntity)
                
                arView.scene.addAnchor(sphereAnchor)
            }
        }
    }
    
    func projectionOntoPlane(_ referencePoint: SIMD3<Float>, _ planeNormal: SIMD3<Float>, _ point: SIMD3<Float>) -> SIMD2<Float> {
        let d = simd_dot(referencePoint, planeNormal)
        let t = (d - simd_dot(point, planeNormal)) / simd_dot(planeNormal, planeNormal)
        let projectedPoint = point + t * planeNormal
        return SIMD2<Float>(projectedPoint.x, projectedPoint.y)
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
