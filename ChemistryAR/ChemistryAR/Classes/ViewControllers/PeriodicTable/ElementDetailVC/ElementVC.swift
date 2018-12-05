//
//  ElementVC.swift
//  ChemistryAR
//
//  Created by Admin on 11/26/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ElementVC: BaseVC {
    
    @IBOutlet weak var tbvContent: UITableView?
    
    var titleHeader = ["Atomic Number".localized, "Atomic Mass".localized, "Standard State".localized, "Density".localized, "Boiling Point".localized, "Melting Point".localized, "Electronic Configuration".localized, "Oxidation States".localized, "Information".localized, "Other info".localized]
    var arrData: [String]?
    var elementDto: ElementModel?
    var elementId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateCustomNavigationBar(.BackOnly, elementDto?.name)
        tbvContent?.addRefreshControl(self, action: #selector(fetchData))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initData()
    }
    
    @objc func fetchData() {
        App().showLoadingIndicator()
        SERVICES().API.getElementDetail(elementId: elementId ?? "") { (result) in
            App().dismissLoadingIndicator()
            if self.tbvContent?.isRefreshing() ?? false {
                self.tbvContent?.endRefreshControl()
            }
            switch result {
            case .object(let obj):
                self.elementDto = obj
                self.updateData()
            case .error(let err):
                self.showAlertView(E(err.message))
            }
        }
    }
    
    func initData() {
        if elementDto == nil {
            fetchData()
        }
    }
    
    func updateData() {
        arrData = [ String(format: "%@", elementDto?.atomicNumber?.formattedWithSeparator ?? ""),
                    String(format: "%@", elementDto?.atomicMass?.roundWithSeparator(3) ?? ""),
                    E(elementDto?.standardState),
                    String(format: "%@", elementDto?.density?.roundWithSeparator(2) ?? ""),
                    String(format: "%@", elementDto?.boilingPoint?.roundWithSeparator(3) ?? ""),
                    String(format: "%@", elementDto?.meltingPoint?.roundWithSeparator(3) ?? ""),
                    E(elementDto?.electronicConfiguration),
                    E(elementDto?.getOxitdation()),
                    E(elementDto?.summary),
                    E(elementDto?.source) ]
        self.updateCustomNavigationBar(.BackOnly, elementDto?.name)
        tbvContent?.reloadData()
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        didSelectback()
    }
}

extension ElementVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + titleHeader.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == 0 {
            return 200
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            return cellAvatar(tableView, cellForRowAt: indexPath)
        } else {
            return cellText(tableView, cellForRowAt: indexPath)
        }
    }
}

extension ElementVC: UITableViewDelegate {
    
}

extension ElementVC {
    func cellAvatar(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ElementTbvCell = tableView.dequeueReusableCell(withIdentifier: "CellAvatar", for: indexPath) as! ElementTbvCell
        
        cell.imgBanner?.setImageWithURL(url: E(elementDto?.imagePreview))
        cell.imgIcon?.setImageWithURL(url: E(elementDto?.imagePreview))
        cell.imgIcon?.roundCorners(.allCorners, radius: cell.imgIcon?.frame.height ?? 0 / 2)
        cell.lblTitle?.text = String(format: "%@ (%@)", E(elementDto?.name), E(elementDto?.symbol))
        cell.lblTitle?.textColor = elementDto?.colorStates
        
        return cell
    }
    
    func cellText(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ElementTbvCell = tableView.dequeueReusableCell(withIdentifier: "CellText", for: indexPath) as! ElementTbvCell
        
        let row = indexPath.row
        
        cell.lblTitle?.text = titleHeader[row - 1]
        cell.tvContent?.text = arrData?[row - 1]
        cell.tvContent?.layer.cornerRadius = 10
        cell.contentView.backgroundColor = elementDto?.colorCategory.withAlphaComponent(0.3)
        
        return cell
    }
}
