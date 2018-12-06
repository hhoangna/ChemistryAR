//
//  ElementListVC.swift
//  ChemistryAR
//
//  Created by Admin on 11/26/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ElementListVC: BaseVC {

    @IBOutlet weak var tbvContent: UITableView?
    @IBOutlet weak var sbSearch: UISearchBar?
    
    var arrDisplay: [ElementModel]?
    var strSearch: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateCustomNavigationBar(.Cancel, "Search".localized)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
    }
    
    func updateData() {
        tbvContent?.isHidden = arrDisplay?.count ?? 0 < 0
        tbvContent?.reloadData()
    }
    
    func filterElements(with text: String) {
        App().showLoadingIndicator()
        SERVICES().API.filterElement(text: E(strSearch)) { (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object(let obj):
                self.arrDisplay = obj
                self.updateData()
            case .error(let err):
                self.showAlertView(E(err.message))
            }
        }
    }
    
    override func onNavigationClickRightButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: false)
    }
}

extension ElementListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("String: \(String(describing: searchBar.text))")
        if !isEmpty(searchBar.text) {
            strSearch = searchBar.text
            filterElements(with: E(strSearch))
        }
        searchBar.endEditing(true)
    }
}

extension ElementListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = arrDisplay?[indexPath.row]
        
        let vc: ElementVC = .load(SB: .Periodic)
        vc.elementId = element?._id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ElementListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PeriodicListCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PeriodicListCell
        
        let element = arrDisplay?[indexPath.row]
        
        cell.imgIcon?.setImageWithURL(url: element?.imagePreview)
        cell.lblTitle?.text = E(element?.name)
        cell.lblSubtitle?.text = E(element?.symbol)
        cell.lblSubtitle1?.text = String(format: "%@", element?.atomicNumber?.formattedWithSeparator ?? "")
        cell.vContent?.backgroundColor = element?.colorCategory.withAlphaComponent(0.3)
        cell.lblTitle?.textColor = element?.colorStates
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDisplay?.count ?? 0
    }
}
