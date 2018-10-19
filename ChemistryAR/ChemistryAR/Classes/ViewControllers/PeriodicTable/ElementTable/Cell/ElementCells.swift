//
//  ElementCells.swift
//  ChemistryAR
//
//  Created by Admin on 10/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import SpreadsheetView

class GroupCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = AppFont.helveticaBold(with: 12)
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CycleCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        label.textAlignment = .center
        label.font = AppFont.helveticaBold(with: 14)
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 3, dy: 0)
        }
    }
}

class ElementCell: Cell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMass: UILabel!
    @IBOutlet weak var lblAtom: UILabel!
    @IBOutlet weak var lblElectronic: UILabel!
    @IBOutlet weak var lblElectronegativity: UILabel!
    @IBOutlet weak var lblOxidation: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class BlankCell: Cell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.9, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
