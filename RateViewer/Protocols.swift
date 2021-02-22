//
//  Protocols.swift
//  RateViewer
//
//  Created by Maxim Pakhotin on 22.04.2020.
//  Copyright © 2020 Maxim Pakhotin. All rights reserved.
//

import UIKit

protocol IMPShowRateDelegate: AnyObject {
    func didEndParsing(message: String?)
}

protocol IMPValuteFetcher {
    var items:[MPValute]  { get set }
    func parse()
    var delegate:IMPShowRateDelegate? { get set}
}

protocol IMPDateCellModel {
    var title:String { get }
    var date:Date { get }
}

protocol IMPDateTableViewCell: UITableViewCell {
    func setModel(model: IMPDateCellModel)
}
