//
//  PeriodicTableVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/4/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class PeriodicTableVC: BaseVC {
    
    @IBOutlet weak var tbvContent: UITableView!
    
    var arrList = ["Mendeleev Periodic Table".localized, "Solubility".localized, "Electronegativity of elements".localized, "Molecular weight of organic substances".localized, "Reactivity series".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    func updateUI() {
        self.updateCustomNavigationBar(.BackOnly, "Adnkasjdnak")
        setupTableView()
    }
    
    func setupTableView() {
        tbvContent?.delegate = self
        tbvContent?.dataSource = self
    }
}

extension PeriodicTableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PeriodicCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PeriodicCell
        
        let item = arrList[indexPath.row]
        cell.lblTitle?.text = item
        
        return cell
    }
}

extension PeriodicTableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: ElementTableVC = .load(SB: .Periodic)
                
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
