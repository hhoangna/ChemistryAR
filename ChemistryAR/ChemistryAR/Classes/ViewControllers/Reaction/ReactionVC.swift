//
//  ReactionVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ReactionVC: BaseVC {

    @IBOutlet weak var tbvContent: UITableView?
    @IBOutlet weak var sbSearch: UISearchBar?
    
    var arrDisplay: [ReactionDetailModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        App().showLoadingIndicator()
        
        SERVICES().API.getReactionEquation(product:"", input: sbSearch?.text ?? "") { (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object(let obj):
                self.arrDisplay = obj.equation
                self.tbvContent?.reloadData()
            case .error(_ ):
                self.showAlertView("Get Reaction Equation Error!")
            }
        }
    }
}

extension ReactionVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {        
        print("String: \(String(describing: searchBar.text))")
        fetchData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}

extension ReactionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ReactionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReactionCell = tableView.dequeueReusableCell(withIdentifier: "ReactionCell", for: indexPath) as! ReactionCell
        
        let dto:ReactionDetailModel = arrDisplay?[indexPath.row] ?? ReactionDetailModel()
        
        cell.lblTitle?.attributedText = MDF(dto.phuong_trinh)
        cell.tvContent?.attributedText = MDF(dto.dieu_kien)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDisplay?.count ?? 0
    }
}
