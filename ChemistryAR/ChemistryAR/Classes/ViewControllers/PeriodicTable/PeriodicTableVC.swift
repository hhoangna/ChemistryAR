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
    
    var groupName = ["", "IA", "IIA", "IIIB", "IVB", "VB", "VIB", "VIIB", "VIIIB", "VIIIB", "VIIIB", "IB", "IIB", "IIIA", "IVA", "VA", "VIA", "VIIA", "VIIIA"]
    var periodName = ["", "1", "2", "3", "4", "5", "6", "7", "", "", ""]
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        setupSpreadSheetView()
        readDataJSON()
    }
    
    func setupNavigationBar() {
        let leftBarBtnItem = UIBarButtonItem.searchButton(target: self, action: #selector(onNavigationClickRightButton(_:)))
        self.navigationController?.navigationItem.leftBarButtonItem = leftBarBtnItem
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
        vContainer?.register(UINib(nibName: String(describing: InfoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: InfoCell.self))
        vContainer?.register(UINib(nibName: String(describing: TeamCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TeamCell.self))
        vContainer?.register(UINib(nibName: String(describing: NoteCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: NoteCell.self))
        vContainer?.register(BlankCell.self, forCellWithReuseIdentifier: String(describing: BlankCell.self))
        vContainer?.register(TitleCell.self, forCellWithReuseIdentifier: String(describing: TitleCell.self))
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
        return 19
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 11
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return 60
        } else {
            return 100
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 50
        } else if case 8 = row {
            return 40
        } else {
            return 130
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        return [CellRange(from: (row: 1, column: 2), to: (row: 1, column: 17)),
                CellRange(from: (row: 2, column: 3), to: (row: 3, column: 12)),
                CellRange(from: (row: 9, column: 1), to: (row: 9, column: 2)),
                CellRange(from: (row: 10, column: 1), to: (row: 10, column: 2))]
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        
        if case (1...18, 0) = (indexPath.column, indexPath.row) {
            return cellGroup(spreadsheetView, indexPath)
        } else if case (0, 1...10) = (indexPath.column, indexPath.row) {
            if case (0, 8...10) = (indexPath.column, indexPath.row) {
                return cellBlank(spreadsheetView, indexPath)
            } else {
                return cellPeriod(spreadsheetView, indexPath)
            }
        } else if case (1...18, 1...10) = (indexPath.column, indexPath.row) {
            if case (2...17, 1) = (indexPath.column, indexPath.row) {
                return cellTitle(spreadsheetView, indexPath)
            } else if case (3...12, 2...3) = (indexPath.column, indexPath.row) {
                return cellNote(spreadsheetView, indexPath)
            } else if case (0...18, 8) = (indexPath.column, indexPath.row) {
                return cellBlank(spreadsheetView, indexPath)
            } else if case (18, 9...10) = (indexPath.column, indexPath.row) {
                return cellBlank(spreadsheetView, indexPath)
            } else if case (1...2, 9) = (indexPath.column, indexPath.row) {
                return cellInfoLantan(spreadsheetView, indexPath)
            } else if case (1...2, 10) = (indexPath.column, indexPath.row) {
                return cellInfoActini(spreadsheetView, indexPath)
            } else if case (3, 6) = (indexPath.column, indexPath.row) {
                return cellLantan(spreadsheetView, indexPath)
            }else if case (3, 7) = (indexPath.column, indexPath.row) {
                return cellActini(spreadsheetView, indexPath)
            } else {
                return cellElement(spreadsheetView, indexPath)
            }
        }
        return cellInfo(spreadsheetView, indexPath)
    }
}

extension PeriodicTableVC: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
        
        if case (1...18, 0) = (indexPath.column, indexPath.row) {
            return
        } else if case (0, 1...10) = (indexPath.column, indexPath.row) {
            return
        } else if case (1...18, 1...10) = (indexPath.column, indexPath.row) {
            if case (2...17, 1) = (indexPath.column, indexPath.row) {
                return
            } else if case (3...12, 2...3) = (indexPath.column, indexPath.row) {
                return
            } else if case (0...18, 8) = (indexPath.column, indexPath.row) {
                return
            } else if case (18, 9...10) = (indexPath.column, indexPath.row) {
                return
            } else if case (1...2, 9) = (indexPath.column, indexPath.row) {
                return
            } else if case (1...2, 10) = (indexPath.column, indexPath.row) {
                return
            } else if case (3, 6) = (indexPath.column, indexPath.row) {
                return
            }else if case (3, 7) = (indexPath.column, indexPath.row) {
                return
            } else {
                let element = displayElement[indexPath.row - 1][indexPath.column - 1]
                let vc: ElementVC = .load(SB: .Periodic)
                vc.elementId = element._id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension PeriodicTableVC {
    func cellGroup(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: GroupCell.self), for: indexPath) as! GroupCell
        
        cell.label.text = groupName[indexPath.column]
        cell.borders.bottom = .solid(width: 1, color: AppColor.borderColor)
        cell.borders.right = .solid(width: 1, color: AppColor.borderColor)
        
        return cell
    }
    
    func cellPeriod(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: CycleCell.self), for: indexPath) as! CycleCell
        
        cell.label.text = periodName[indexPath.row]
        cell.borders.right = .solid(width: 1, color: AppColor.borderColor)
        cell.borders.bottom = .solid(width: 1, color: AppColor.borderColor)
        
        return cell
    }
    
    func cellLantan(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TeamCell.self), for: indexPath) as! TeamCell
        
        cell.lblTitle.text = "*"
        cell.lblTitle.textAlignment = .center
        cell.vContent.backgroundColor = AppColor.lantanColor.withAlphaComponent(0.3)
        cell.borders.bottom = .solid(width: 1, color: AppColor.lantanColor)
        cell.borders.left = .solid(width: 1, color: AppColor.lantanColor)
        cell.borders.right = .solid(width: 1, color: AppColor.lantanColor)
        cell.borders.top = .solid(width: 1, color: AppColor.lantanColor)
        
        return cell
    }
    
    func cellInfoLantan(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TeamCell.self), for: indexPath) as! TeamCell
        
        cell.lblTitle.text = "* Lantan"
        cell.lblTitle.textAlignment = .right
        cell.vContent.backgroundColor = AppColor.white
        cell.borders.bottom = .solid(width: 1, color: AppColor.white)
        cell.borders.left = .solid(width: 1, color: AppColor.white)
        cell.borders.right = .solid(width: 1, color: AppColor.white)
        cell.borders.top = .solid(width: 1, color: AppColor.white)
        
        return cell
    }
    
    func cellInfoActini(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TeamCell.self), for: indexPath) as! TeamCell
        
        cell.lblTitle.text = "** Actini"
        cell.lblTitle.textAlignment = .right
        cell.vContent.backgroundColor = AppColor.white
        cell.borders.bottom = .solid(width: 1, color: AppColor.white)
        cell.borders.left = .solid(width: 1, color: AppColor.white)
        cell.borders.right = .solid(width: 1, color: AppColor.white)
        cell.borders.top = .solid(width: 1, color: AppColor.white)
        
        return cell
    }
    
    func cellActini(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TeamCell.self), for: indexPath) as! TeamCell
        
        cell.lblTitle.text = "**"
        cell.lblTitle.textAlignment = .center
        cell.vContent.backgroundColor = AppColor.actiniColor.withAlphaComponent(0.3)
        cell.borders.bottom = .solid(width: 1, color: AppColor.actiniColor)
        cell.borders.left = .solid(width: 1, color: AppColor.actiniColor)
        cell.borders.right = .solid(width: 1, color: AppColor.actiniColor)
        cell.borders.top = .solid(width: 1, color: AppColor.actiniColor)
        
        return cell
    }
    
    func cellElement(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ElementCell.self), for: indexPath) as! ElementCell
        
        let col = indexPath.column
        let row = indexPath.row
        
        let element = displayElement[row - 1][col - 1]
        
        cell.lblAtom.text = String(format: "%i", element.atomicNumber ?? 0)
        cell.lblName.text = E(element.name)
        cell.lblSymbol.text = E(element.symbol)
        cell.lblOxidation.text = element.getOxitdation()
        cell.lblMass.text = E(element.atomicMass?.roundWithSeparator(3))
        cell.lblElectronic.text = E(element.electronicConfiguration)
        cell.vContent.backgroundColor = element.colorCategory.withAlphaComponent(0.3)
        cell.lblSymbol.textColor = element.colorStates
        cell.borders.bottom = .solid(width: 1, color: element.colorCategory)
        cell.borders.left = .solid(width: 1, color: element.colorCategory)
        cell.borders.right = .solid(width: 1, color: element.colorCategory)
        cell.borders.top = .solid(width: 1, color: element.colorCategory)
        
        return cell
    }
    
    func cellBlank(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BlankCell.self), for: indexPath) as! BlankCell
        
        return cell
    }
    
    func cellNote(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: NoteCell.self), for: indexPath) as! NoteCell
        
        return cell
    }
    
    func cellTitle(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TitleCell.self), for: indexPath) as! TitleCell
        
        cell.label.text = "BẢNG TUẦN HOÀN HOÁ HỌC"
        
        return cell
    }
    
    func cellInfo(_ spreadsheetView: SpreadsheetView,_ indexPath:IndexPath) -> Cell {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: InfoCell.self), for: indexPath) as! InfoCell
        
        cell.borders.right = .solid(width: 1, color: AppColor.borderColor)
        cell.borders.bottom = .solid(width: 1, color: AppColor.borderColor)
        
        return cell
    }
}
