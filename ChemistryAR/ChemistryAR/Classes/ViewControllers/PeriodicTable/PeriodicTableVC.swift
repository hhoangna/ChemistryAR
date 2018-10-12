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
        setupViewHeader()
        setupTableView()
        setupBarButtomItemView()
    }
    
    func setupTableView() {
        tbvContent?.delegate = self
        tbvContent?.dataSource = self
    }
    
    func setupViewHeader() {
        vHeader?.delegate = self
        vHeader?.setCustomNavigationBar(type: .None,
                                        title: "Periodic Table".localized)
    }
    
    override func setupBarButtomItemView() {
        super.setupBarButtomItemView()
        buttonItemView?.indexSelected = 0
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
    
}

extension PeriodicTableVC: CustomNavigationBarDelegate {
    func didSelectOne(header: CustomNavigationBar, btn: UIButton) {
        //
    }
    
    func didSelecCreate(header: CustomNavigationBar, btn: UIButton) {
        //
    }
    
    func diSelectBtnTwo(header: CustomNavigationBar, btn: UIButton) {
        //
    }
    
    func didSelectback(header: CustomNavigationBar, btn: UIButton) {
        didSelectback()
    }
}
