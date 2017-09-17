//
//  CameraViewController.swift
//  Hackathon
//
//  Created by Ian McDowell on 9/16/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import UIKit
import AVFoundation
import TesseractOCR

class CameraViewController: UIViewController {
    
    let session: AVCaptureSession
    let device: AVCaptureDevice
    let input: AVCaptureDeviceInput
    let output: AVCaptureStillImageOutput
    let prevLayer: AVCaptureVideoPreviewLayer
    
    init() {
        session = AVCaptureSession()
        device = AVCaptureDevice.default(for: .video)!
        input = try! AVCaptureDeviceInput(device: device)
        session.addInput(input)
        output = AVCaptureStillImageOutput()
        session.addOutput(output)
        prevLayer = AVCaptureVideoPreviewLayer(session: session)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prevLayer.frame.size = view.frame.size
        prevLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        prevLayer.connection?.videoOrientation = transformOrientation(orientation: UIApplication.shared.statusBarOrientation)
        
        view.layer.addSublayer(prevLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.stopRunning()
    }
    
    var recognizing: Bool = false {
        didSet {
            if recognizing {
                recognize()
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        recognizing = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        recognizing = false
    }
    
    func recognize() {
        if !recognizing {
            return
        }
        self.captureImage() { image in
            self.tesseractOCR(image) { result in
                if let state = try? ParkState.init(tesseractOCR: result) {
                    self.recognizing = false
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Result",
                            message: String(describing: state),
                            preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.view.isUserInteractionEnabled = true
                        }))
                        self.present(alert, animated: true)
                    }
                } else {
                    self.recognize()
                }
            }
        }
    }
    
    func captureImage(_ callback: @escaping (Data) -> Void) {
        let videoConnection = self.output.connections.first(where: { $0.inputPorts.contains(where: { $0.mediaType == .video }) })!
        videoConnection.videoOrientation = transformOrientation(orientation: UIApplication.shared.statusBarOrientation)
        
        output.captureStillImageAsynchronously(from: videoConnection) { buffer, error in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!)!
            
            callback(imageData)
        }
    }
    
    @objc private func takePhoto() {
        
        view.isUserInteractionEnabled = false
        
        let videoConnection = self.output.connections.first(where: { $0.inputPorts.contains(where: { $0.mediaType == .video }) })!
        videoConnection.videoOrientation = transformOrientation(orientation: UIApplication.shared.statusBarOrientation)
        
        output.captureStillImageAsynchronously(from: videoConnection) { buffer, error in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!)!
            
            DispatchQueue.global().async {
                let group = DispatchGroup()
                var tesseractResult: ImageOCRResult!
//                var azureResult: ImageOCRResult!
//
//                group.enter()
                group.enter()
                self.tesseractOCR(imageData) { result in
                    tesseractResult = result
                    group.leave()
                }
//                self.azureOCR(imageData) { result in
//                    azureResult = result
//                    group.leave()
//                }
                
                group.wait()
                
                let state = try! ParkState(tesseractOCR: tesseractResult)
                
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Result",
                        message: """
                            Tesseract: \(tesseractResult),
                            Result: \(state)
                         """,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.view.isUserInteractionEnabled = true
                    }))
                    self.present(alert, animated: true)
                }
            }

            
        }
    }
    
    func transformOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    func tesseractOCR(_ imageData: Data, _ callback: @escaping (ImageOCRResult) -> Void) {
        DispatchQueue.global().async {
            let image = UIImage(data: imageData)!
            
            let t = G8Tesseract(language: "eng")!
            t.image = image
            t.recognize()
            
            let result = ImageOCRResult(tesseractString: t.recognizedText)
            
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }
    
//    func azureOCR(_ imageData: Data, _ callback: @escaping (ImageOCRResult) -> Void) {
//
//        let azureURL = URL(string: "https://westus.api.cognitive.microsoft.com/vision/v1.0/ocr?language=en&detectOrientation=true")!
//        var request = URLRequest(url: azureURL)
//        request.httpMethod = "POST"
//        request.addValue("4724d9822336434c8a042b36481f0077", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//        request.httpBody = imageData
//
//        let req = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//
//            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
//
//            let result = try! ImageOCRResult.init(azureJSON: json)
//
//            DispatchQueue.main.async {
//                callback(result)
//            }
//        })
//        req.resume()
//    }
    
}
