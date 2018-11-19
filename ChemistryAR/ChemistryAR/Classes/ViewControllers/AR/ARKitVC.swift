//
//  ARKitVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import AVFoundation

class ARKitVC: BaseVC, AVCaptureMetadataOutputObjectsDelegate {
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var prevLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var vCamera: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSession()
    }
    
    func setupSession() {
        session = AVCaptureSession()
        device = AVCaptureDevice.default(for: .video)
        
        let err: NSError? = nil
        do {
            if device != nil {
                input = try AVCaptureDeviceInput(device: device!)
            }
        } catch {
            print(err!)
        }
        
        if err == nil {
            if input != nil {
                session?.addInput(input!)
            }
        } else {
            print(SF("Camera input error: %@", para: err))
        }
        
        prevLayer = AVCaptureVideoPreviewLayer(session: session!)
        prevLayer?.frame = vCamera?.frame ?? CGRect.zero
        prevLayer?.videoGravity = .resizeAspectFill
        vCamera?.layer.addSublayer(prevLayer!)
        session?.startRunning()
    }
    
    @IBAction func btnScanObjectPressed(_ sender: UIButton) {
        let vc: ScanObjectVC = .load(SB: .AR)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnShowModelPressed(_ sender: UIButton) {
        
    }
}
