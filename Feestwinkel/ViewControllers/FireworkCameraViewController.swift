//
//  FireworkCameraViewController.swift
//  Feestwinkel
//
//  Created by Jeremie Van de Walle on 21/12/17.
//  Copyright © 2017 Jeremie Van de Walle. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class FireworkCameraViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var textView: UITextView!

    var code: String?
    var objCounter: Int = 0
    var objectFound: Bool = false;
    let dispatchQueueML = DispatchQueue(label: "fireworkQueue") // A Serial Queue
    var visionRequests = [VNRequest]()
    
    override func viewDidLoad() {
        sceneView.delegate = self
        sceneView.scene =  SCNScene()
        // --- ML & VISION ---
        // Setup Vision Model
        guard let selectedModel = try? VNCoreMLModel(for: Vuurwerk().model) else {
            fatalError("Could not load model.")
        }
        // Set up Vision-CoreML Request
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showVideo" else {
            fatalError("Unknown segue")
        }
        let fireworkPlayerViewController = segue.destination as! FireworkPlayerViewController
        fireworkPlayerViewController.code = code!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if(self.objectFound){
            dispatchQueueML.resume()
            self.objCounter = 0
            self.objectFound = false;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - MACHINE LEARNING
    
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML()
            // 2. Loop this function.
            self.loopCoreMLUpdate()
        }
    }
    
    func updateCoreML() {
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        if error != nil {
            return
        }
        guard let observations = request.results else {
            return
        }
        let firstObservation = observations[0] as? VNClassificationObservation
        DispatchQueue.main.async {
            if(self.objectFound == false && firstObservation?.confidence != nil && (firstObservation?.confidence)! > Float(0.30)){
                if(self.code != nil && self.code == firstObservation!.identifier){
                    self.objCounter += 1
                }else{
                    self.code = firstObservation!.identifier
                    self.objCounter = 0
                }
                if (self.objCounter == 20) {
                    self.objectFound = true;
                    self.dispatchQueueML.suspend()
                    self.foundFirework()
                }
            }
        }
        
            //text.text = "name: \(firstObservation!.identifier), confidence: \(firstObservation!.confidence)"
        /*
        if(self.objectFound == false && firstObservation?.confidence != nil && (firstObservation?.confidence)! > Float(0.40)){
            code = firstObservation!.identifier
            objectFound = true;
            dispatchQueueML.suspend()
            foundFirework()
        }*/
    }
    
    override var prefersStatusBarHidden : Bool { return false }
}

extension FireworkCameraViewController: ARSCNViewDelegate {
    func foundFirework(){
        if (Bundle.main.path(forResource: self.code!, ofType: "mp4") == nil) {
            let alert = UIAlertController(title: "Fout", message: "Voor dit vuurwerk is geen video beschikbaar, onze excuses.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Oke", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: "showVideo", sender: self)
        }
    }
}
