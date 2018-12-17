//
//  CellModel.swift
//  ChemistryAR
//
//  Created by Admin on 12/10/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

typealias ModelNameCallback = (_ success: Bool, _ name: String) -> Void
typealias ModelURLCallback = (_ success: Bool, _ url: URL) -> Void

class CellModel: BaseClvCell {
    @IBOutlet weak var clvContent: UICollectionView!
    @IBOutlet weak var lblNodata: UILabel?

    var listModel: [ARFileModel] = []
    var tabSelected: Int? {
        didSet {
            fetchData()
        }
    }
    
    var nameCallback: ModelNameCallback?
    var urlCallback: ModelURLCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        clvContent.delegate = self
        clvContent.dataSource = self
    }
    
    func fetchData() {
        if tabSelected == 0 {
            readDataJSON()
        } else {
            getAllModel()
        }
    }
    
    func readDataJSON() {
        if let path = Bundle.main.path(forResource: "models", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let models = try JSONDecoder().decode([ARFileModel].self, from: data)
                self.listModel = models
                
                DispatchQueue.main.async() { () -> Void in
                    self.clvContent.reloadData()
                }
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    func getAllModel() {
        App().showLoadingIndicator()
        SERVICES().API.getAllCompound { (results) in
            App().dismissLoadingIndicator()
            switch results {
            case .object(let obj):
                self.listModel = obj
                self.clvContent.reloadData()
            case .error(let err):
                self.rootVC?.showAlertView(E(err.message))
            }
        }
    }
}

extension CellModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.size.width - 22)/4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3;
    }
}

extension CellModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = listModel[indexPath.item]
        let cell: ModelClvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ModelClvCell
        
        cell.lblTitle?.text = model.name
        cell.imgIcon?.setImageWithURL(url: model.urlServer)
        
        return cell
    }
}

extension CellModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = listModel[indexPath.row]
        
        if tabSelected == 0 {
            self.nameCallback!(true, E(model.symbol))
        } else {
            if model.urlLocal == nil {
                model.startDownload { (success, file) in
                    if let url = file?.urlLocal {
                        self.urlCallback!(true, url)
                    }
                }
            } else {
                return
            }
        }
    }
}
