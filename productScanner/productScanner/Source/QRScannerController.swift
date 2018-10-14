//
//  QRScannerController.swift
//  productScanner
//
//  Created by Mac on 10.10.2018.
//  Copyright © 2018 testOrg. All rights reserved.
//


import UIKit
import AVFoundation

class QRScannerController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var qrCodeView: UIView!
    
    
    @IBAction func onButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askPermission()
    }
    
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
            }
        }
    }
    
    func askPermission() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            self.startVideoCapture()
            break
        case .restricted,.denied,.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if !granted {
                    let alert = UIAlertController(title: "Allow App access to your Camera", message: "App need access to Camera to scan QR code", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Allow Access", style: .default) { action in
                        if let url = NSURL(string:UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        }
                    })
                    alert.addAction(UIAlertAction(title: "Not Now", style: .default) { action in
                    })
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    self.startVideoCapture()
                }
            }
        default: break
        }
    }
    
    func startVideoCapture() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = self.qrCodeView.bounds
            self.qrCodeView.layer.addSublayer(videoPreviewLayer!)
            self.qrCodeView.clipsToBounds = true
            // Start video capture.
            captureSession.startRunning()
            qrCodeFrameView = UIView()
            
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                self.qrCodeView.addSubview(qrCodeFrameView)
                self.qrCodeView.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Product code", message: "\(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Add to catalog", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            let groceryListviewController = self.storyboard?.instantiateViewController(withIdentifier: "groceryList") as! GroceryListController
            codeAfterScan = "\(decodedURL)"
            self.present(groceryListviewController, animated: true, completion: nil)
            print("\(decodedURL)")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
}
