//
//  LibraryCardViewController.swift
//  Campus
//
//  Created by Tim Gymnich on 10/16/18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit
import AVFoundation

class LibraryCardViewController: UITableViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.shadowOpacity = 0.7
            shadowView.layer.shadowColor = UIColor.gray.cgColor
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowRadius = 14
            shadowView.backgroundColor = .clear
        }
    }
    
    @IBOutlet var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 8
            cardView.layer.masksToBounds = true
        }
    }
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    lazy var studentIDFront: StudentIDFront = StudentIDFront.fromNib()
    lazy var studentIDBack: StudentIDBack = StudentIDBack.fromNib()
    
    var front = true
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentIDFront.frame = self.cardView.frame
        self.studentIDBack.frame = self.cardView.frame

        cardView.addSubview(studentIDFront)

        
//        startBarcodeScanner()
        found(code: "01234567890")
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        shadowView.addGestureRecognizer(singleTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    func startBarcodeScanner() {
        view.backgroundColor = UIColor.black
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
            metadataOutput.metadataObjectTypes = [.code39]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print(metadataObject.type)
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        let barCode = barcodeFromString(string: code)
        studentIDBack.barcodeView.image = barCode
        studentIDBack.bibliotheksnummerLabel.text = code
    }
    
    func barcodeFromString(string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
    
    @objc func flip() {
        if front {
            UIView.transition(from: studentIDFront, to: studentIDBack, duration: 1, options: [.transitionFlipFromRight]) { _ in
                self.studentIDBack.frame = self.cardView.frame
            }
            front = false
        } else {
            UIView.transition(from: studentIDBack, to: studentIDFront, duration: 1, options: [.transitionFlipFromLeft]) { _ in
                self.studentIDFront.frame = self.cardView.frame
            }
            front = true
        }
    }

}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}
