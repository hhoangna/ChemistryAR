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
        updateCustomNavigationBar(.BackOnly, "Periodic Table")

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
        
        let alert = UIAlertController(title: "Select options", message: nil, preferredStyle: .actionSheet)
        
        let modeNew = UIAlertAction(title: "New Scan", style: .default) { (ok) in
            let vc: ScanObjectVC = .load(SB: .AR)
            self.present(vc, animated: true, completion: nil)
        }
        
        let modeLoad = UIAlertAction(title: "Load Object", style: .default) { (ok) in
            let vc: ScanModelListVC = .load(SB: .AR)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (ok) in
            return
        }
        
        alert.addAction(modeNew)
        alert.addAction(modeLoad)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnShowModelPressed(_ sender: UIButton) {
        let vc: ShowModelVC = .load(SB: .AR)
        self.present(vc, animated: true, completion: nil)
    }
}
