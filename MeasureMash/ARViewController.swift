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

class ARViewController: UIViewController {
    
    @IBOutlet weak var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
    }
    
    func setupARView() {
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector( handleTap(recognizer:) )))
        
        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leftAnchor.constraint(equalTo: view.leftAnchor),
            arView.rightAnchor.constraint(equalTo: view.rightAnchor),
            arView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
        ])
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        //get the coordinates of the tap
        let location = recognizer.location(in: arView)
        
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
}
