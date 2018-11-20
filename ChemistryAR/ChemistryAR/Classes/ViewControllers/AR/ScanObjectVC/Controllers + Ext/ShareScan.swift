//
//  ShareScan.swift
//  ChemistryAR
//
//  Created by Admin on 11/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ShareScan: UIActivityViewController {
    
    init(sourceView: UIView, sharedObject: Any) {
        super.init(activityItems: [sharedObject], applicationActivities: nil)
        
        // Set up popover presentation style
        modalPresentationStyle = .popover
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceView.bounds
        
        self.excludedActivityTypes = [.markupAsPDF, .openInIBooks, .message, .print,
                                      .addToReadingList, .saveToCameraRoll, .assignToContact,
                                      .copyToPasteboard, .postToTencentWeibo, .postToWeibo,
                                      .postToVimeo, .postToFlickr, .postToTwitter, .postToFacebook]
    }
    
    deinit {
        // Restart the session in case it was interrupted by the share sheet
        if let configuration = ScanObjectVC.instance?.sceneView.session.configuration,
            ScanObjectVC.instance?.state == .testing {
            ScanObjectVC.instance?.sceneView.session.run(configuration)
        }
    }
}
