//
//  MPDateTableViewCell.swift
//  RateViewer
//
//  Created by Maxim Pakhotin on 21.04.2020.
//  Copyright © 2020 Maxim Pakhotin. All rights reserved.
//

import UIKit

class MPDateCellModel: IMPDateCellModel {
    
    var title:String
    var date:Date
    
    init(date:Date) {
        let df = DateFormatter()
        df.dateStyle = .medium
        self.title = df.string(from: date)
        self.date = date
    }

}

class MPDateTableViewCell: UITableViewCell, IMPDateTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    func setModel(model: IMPDateCellModel){
        self.textLabel?.text = model.title
    }
   
}
