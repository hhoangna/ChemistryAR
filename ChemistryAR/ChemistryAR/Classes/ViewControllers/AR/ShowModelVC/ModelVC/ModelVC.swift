//
//  ModelPanel.swift
//  ChemistryAR
//
//  Created by Admin on 11/20/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import Panels

class ModelPanel: UIViewController, Panelable {
    @IBOutlet var headerHeight: NSLayoutConstraint!
    @IBOutlet var headerPanel: UIView!
    
    @IBOutlet weak var tbvContent: UITableView!
    
    var arrModel: [String] = ["1", "2", "3", "4", "5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
    }
}

extension ModelPanel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ModelCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ModelCell
        
        return cell
    }
}

extension ModelPanel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
