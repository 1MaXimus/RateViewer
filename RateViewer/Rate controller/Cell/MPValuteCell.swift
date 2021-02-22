//
//  MPValuteCell.swift
//  RateViewer
//
//  Created by Maxim Pakhotin on 22.04.2020.
//  Copyright © 2020 Maxim Pakhotin. All rights reserved.
//

import UIKit



class MPValuteCellModel {
    var charCode:String?
    var nominal:String?
    var name:String?
    var rate:String?
    
    init(item: MPValute) {
        self.charCode = item.charCode
        self.name = item.name
        self.nominal = item.nominal
        self.rate = item.value?.appending(" руб.")
        
    }
    deinit {
        print("deinit ->", self)
    }
}

class MPValuteCell: UITableViewCell {
    @IBOutlet weak var charCodeLabel: UILabel!
    @IBOutlet weak var nominalLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    func setModel(model: MPValuteCellModel){
        charCodeLabel.text = model.charCode
        nominalLabel.text = model.nominal
        nameLabel.text = model.name
        rateLabel.text = model.rate
    }
    
    deinit {
        print("deinit ->", self)
    }
    
}
