//
//  PeriodicTableVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/4/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import SpreadsheetView

class PeriodicTableVC: BaseVC {
    
    var elementModel: [ElementModel] = []
    var displayElement: [[ElementModel]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCustomNavigationBar(.BackOnly, "Periodic Table")
        setupSpreadSheetView()
        readDataJSON()
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
    
    func readDataJSON() {
        if let path = Bundle.main.path(forResource: "elements", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let elements = try JSONDecoder().decode([[ElementModel]].self, from: data)
                self.displayElement = elements
                
                DispatchQueue.main.async() { () -> Void in
                    self.vContainer?.reloadData()
                }
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}

extension PeriodicTableVC: SpreadsheetViewDataSource {
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + 20
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
            return cellGroup(spreadsheetView, indexPath)
        } else if case (0, 1...20 + 1) = (indexPath.column, indexPath.row) {
            return cellPeriod(spreadsheetView, indexPath)
        } else if case (1...10 + 1, 1...20 + 1) = (indexPath.column, indexPath.row) {
            return cellElement(spreadsheetView, indexPath)
        }
        return cellBlank(spreadsheetView, indexPath)
    }
}

extension PeriodicTableVC: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
}

extension PeriodicTableVC {
    func cellGroup(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: GroupCell.self), for: indexPath) as! GroupCell
        
        cell.label.text = "\(indexPath.column)"
        
        return cell
    }
    
    func cellPeriod(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: CycleCell.self), for: indexPath) as! CycleCell
        
        cell.label.text = "\(indexPath.row)"
        
        return cell
    }
    
    func cellElement(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ElementCell.self), for: indexPath) as! ElementCell
        
        return cell
    }
    
    func cellBlank(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BlankCell.self), for: indexPath) as! BlankCell
        
        return cell
    }
}
