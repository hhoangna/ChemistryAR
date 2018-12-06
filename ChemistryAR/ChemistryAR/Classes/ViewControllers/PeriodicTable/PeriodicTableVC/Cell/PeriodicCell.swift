//
//  PeriodicCell.swift
//  ChemistryAR
//
//  Created by Admin on 10/4/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import SpreadsheetView

class TitleCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = AppFont.helveticaBold(with: 32)
        label.textAlignment = .center
        label.textColor = AppColor.mainColor
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class GroupCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = AppFont.helveticaBold(with: 14)
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
        label.font = AppFont.helveticaBold(with: 16)
        
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
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var lblOxidation: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TeamCell: Cell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vContent: UIView!
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class InfoCell: Cell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class NoteCell: Cell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

