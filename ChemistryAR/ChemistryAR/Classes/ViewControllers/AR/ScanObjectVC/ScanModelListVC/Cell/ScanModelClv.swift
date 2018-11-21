//
//  ScanModelClv.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ScanModelClv: BaseClvCell {
    
    @IBOutlet weak var tbvContent: UITableView?
    @IBOutlet weak var lblNodata: UILabel?
    
    var tabSelected: Int?
    
    fileprivate var listDisplay: [String] = ["1", "2", "3", "4", "5"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    func setupTableView() {
        tbvContent?.delegate = self
        tbvContent?.dataSource = self
//        tbvContent?.addRefreshControl(self, action: #selector(fetchData))
    }
    
//    func updateData(tabId: TabId? = nil, search: String? = nil) {
//        strSearch = search
//        tabSelected = tabId
//        filterTenantsGroup(tabId: tabId)
//    }
//
//    func updateData(categorysList: [GroupTenantsModel.Category],
//                    tabId: TabId? = nil,
//                    search: String? = nil) {
//        strSearch = search
//        tabSelected = tabId
//
//        self.listTenant = categorysList
//        self.summary = categorysList.map({$0.count!}).reduce(0, +)
//        self.lblNodata?.isHidden = self.listTenant.count > 0
//        self.tbvContent?.reloadData()
//        self.doSearch(strSearch: self.strSearch)
//    }
//
//    @objc func fetchData() {
//        filterTenantsGroup(tabId: tabSelected)
//    }
//
//    func filterTenantsGroup(tabId: TabId? = nil) {
//
//        App().showLoadingIndicator()
//        SERVICES().API.getTenantsGroupList(tabId: _id) { [weak self] (result) in
//            App().dismissLoadingIndicator()
//            self?.tbvContent?.endRefreshControl()
//            switch result {
//            case .object(let obj):
//                self?.listTenant = obj._categories
//                self?.summary = obj._categories.map({$0.count!}).reduce(0, +)
//                self?.lblNodata?.isHidden = self?.listTenant.count > 0
//                self?.tbvContent?.reloadData()
//                self?.doSearch(strSearch: self?.strSearch)
//            case .error(let err):
//                self?.rootVC?.showAlertView(E(err.message))
//            }
//        }
//    }
}

extension ScanModelClv: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ScanModelTbv = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScanModelTbv
        
        cell.lblTitle?.text = "Item 1"
        
        return cell
    }
}

extension ScanModelClv: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: ShowModelVC = .load(SB: .AR)
        
        self.rootVC?.present(vc, animated: true, completion: nil)
    }
}
