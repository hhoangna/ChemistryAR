//
//  ElementTableVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/17/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import SpreadsheetView

class ElementTableVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupSpreadSheetView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vContainer?.flashScrollIndicators()
    }
    
    func setupSpreadSheetView() {
        vContainer?.delegate = self
        vContainer?.dataSource = self
        
        vContainer?.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        
        vContainer?.intercellSpacing = CGSize(width: 2, height: 2)
        vContainer?.gridStyle = .none
        
        vContainer?.register(GroupCell.self, forCellWithReuseIdentifier: String(describing: GroupCell.self))
        vContainer?.register(CycleCell.self, forCellWithReuseIdentifier: String(describing: CycleCell.self))
        vContainer?.register(UINib(nibName: String(describing: ElementCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ElementCell.self))
        vContainer?.register(BlankCell.self, forCellWithReuseIdentifier: String(describing: BlankCell.self))
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        self.didSelectback()
    }
}

extension ElementTableVC: SpreadsheetViewDataSource {
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + 10
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + 20
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return 45
        } else {
            return 80
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 45
        } else {
            return 100
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (1...(10 + 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: GroupCell.self), for: indexPath) as! GroupCell
            
            cell.label.text = "\(indexPath.column)"
            
            return cell
        } else if case (0, 1...20 + 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: CycleCell.self), for: indexPath) as! CycleCell
            
            cell.label.text = "\(indexPath.row)"
            
            return cell
        } else if case (1...10 + 1, 1...20 + 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ElementCell.self), for: indexPath) as! ElementCell
            
            cell.borders = .all(.solid(width: 1, color: AppColor.mainColor))
            
            return cell
        }
        return spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BlankCell.self), for: indexPath)
    }
}

extension ElementTableVC: SpreadsheetViewDelegate {
    
}

