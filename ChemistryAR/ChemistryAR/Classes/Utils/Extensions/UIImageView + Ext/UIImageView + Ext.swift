//
//  UIImageView + Ext.swift
//  ChemistryAR
//
//  Created by Admin on 10/30/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func setImageWithURL(url:String?,
                         placeHolderImage:UIImage? = nil,
                         complateDownload:((UIImage?,Error?)-> Void)? = nil)  {
        
        if let _url = url {
            let manager = SDWebImageManager.shared()
            manager.imageDownloader?.setValue("Bearer \(E(Caches().token))",
                forHTTPHeaderField: "Authorization")
            
            self.sd_setImage(with: URL(string: _url),
                             placeholderImage: placeHolderImage,
                             options: [.allowInvalidSSLCertificates ,
                                       .progressiveDownload,
                                       .continueInBackground,
                                       .retryFailed],
                             progress: nil) {(image, error, cacheType, url) in
                                complateDownload?(image,error)
            }
        }else {
            self.image = placeHolderImage
        }
    }
}
