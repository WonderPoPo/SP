//
//  QrcodeScannerViewController.swift
//  EstateApp
//
//  Created by Chunpo Chan on 2020/11/2.
//  Copyright © 2020 ChunPo Chan. All rights reserved.
//

import UIKit
import AVFoundation

class QrcodeScannerViewController:UIViewController ,AVCaptureMetadataOutputObjectsDelegate{
    var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var detect_Label: UILabel!
    
    
 
    
    @IBAction func confirmQRcodeAction(_ sender: Any) {
        delegate?.dismissBack(sendData: detect_Label.text )
        dismiss(animated: true)
        
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
        
    }
    
    @IBAction func cleanAction(_ sender: Any) {
        detect_Label.text = ""
        captureSession.startRunning()
        
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()

          
            captureSession = AVCaptureSession()

            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let videoInput: AVCaptureDeviceInput

            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }

            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                failed()
                return
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                failed()
                return
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = scanView.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            

            captureSession.startRunning()
        }

        func failed() {
            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            captureSession = nil
        }
    override func viewWillAppear( _ animated: Bool) {
            super.viewWillAppear(animated)

            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }

    override func viewWillDisappear( _ animated: Bool) {
            super.viewWillDisappear(animated)

            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
        }

    var delegate : DismissBackDelegate?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
                
            DispatchQueue.main.async {
                self.detect_Label.text = stringValue
            }
            
               
        }

            
        //dismiss(animated: true)
    }

        func found(code: String) {
            print(code)
        }

        override var prefersStatusBarHidden: Bool {
            return true
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }
   

 
}



