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
        updateCustomNavigationBar(.BackOnly, "Reaction")

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
                break
                
            case .error(_ ):
                self.showAlertView("Get Reaction Equation Error!")
            }
        }
    }

}

extension ReactionVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        print("String: \(searchBar.text)")
        fetchData()
    }
}

extension ReactionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ReactionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BaseTbvCell = tableView.dequeueReusableCell(withIdentifier: "ReactionCell", for: indexPath) as! BaseTbvCell
        
        let dto:ReactionDetailModel = arrDisplay?[indexPath.row] ?? ReactionDetailModel()
        
        cell.lblTitle?.attributedText = MDF(dto.phuong_trinh)
        cell.lblSubtitle?.attributedText = MDF(dto.dieu_kien)
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDisplay?.count ?? 0
    }
}
