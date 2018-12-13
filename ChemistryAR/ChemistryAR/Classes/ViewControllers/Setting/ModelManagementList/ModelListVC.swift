//
//  ModelListVC.swift
//  ChemistryAR
//
//  Created by Admin on 12/13/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ModelListVC: BaseVC {

    @IBOutlet weak var tbvContent: UITableView?
    
    var arrDisplay: [ARFileModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        updateCustomNavigationBar(.BackOnly, "Model Management".localized)
        
    }
    
    func initData() {
        getAllModel()
        tbvContent?.addRefreshControl(self, action: #selector(getAllModel))
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        self.didSelectback()
    }
    
    @objc func getAllModel() {
        App().showLoadingIndicator()
        SERVICES().API.getAllCompound { (result) in
            if self.tbvContent?.isRefreshing() ?? true {
                self.tbvContent?.endRefreshControl()
            }
            App().dismissLoadingIndicator()
            switch result {
            case .object(let obj):
                self.arrDisplay = obj
                if (self.arrDisplay?.count ?? 0 > 0){
                    UIView.removeViewNoItemAtParentView(self.tbvContent!)
                }else {
                    UIView.addViewNoItemWithTitle("No Models".localized, intoParentView: self.tbvContent!)
                }
                self.tbvContent?.reloadData()
            case .error(let err):
                self.showAlertView(E(err.message))
            }
        }
    }
}

extension ModelListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDisplay?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellModel(tableView, indexPath)
    }
}

extension ModelListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

//Layout
extension ModelListVC {
    
    func cellModel(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for:indexPath) as! ModelListCell
        
        let model = arrDisplay?[row]
        
        cell.lblTitle?.text = E(model?.name)
        cell.lblSubtitle?.text = E(model?.symbol)
        
        return cell
    }
}
