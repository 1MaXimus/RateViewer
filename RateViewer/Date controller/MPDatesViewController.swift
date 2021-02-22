//
//  MPDatesViewController.swift
//  RateViewer
//
//  Created by Maxim Pakhotin on 21.04.2020.
//  Copyright © 2020 Maxim Pakhotin. All rights reserved.
//

import UIKit

class MPDateControllerBuilder {
    
    var models:[IMPDateCellModel] = [MPDateCellModel]()
    
    func addModel() {
        if let date = models.last?.date, let newDate = Calendar.current.date(byAdding: .day, value: -1, to: date) {
            let model = MPDateCellModel(date: newDate)
            models.append(model)
        }
    }
    
    func createModels(numberOf count: Int, fromDate: Date) {
        models = [MPDateCellModel]()
        let firstModel =  MPDateCellModel(date: Date())
        models.append(firstModel)
        for _ in 1...count {
            addModel()
        }
    }
    
    func model(for indexPath:IndexPath) -> IMPDateCellModel {
        return models[indexPath.row]
    }
    deinit {
        print("deinit ->", self)
    }
}

class MPDatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var builder = MPDateControllerBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBar = self.navigationController?.navigationBar {
            navBar.isTranslucent = true
            navBar.backgroundColor = .clear
            navBar.barTintColor = .clear
            navBar.setBackgroundImage(UIImage(), for: .default)
        }
        builder.createModels(numberOf: 30, fromDate: Date())
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return builder.models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MPDateTableViewCell", for: indexPath) as? IMPDateTableViewCell {
            let model = builder.model(for: indexPath)
            cell.setModel(model: model)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let lastRow = tableView.indexPathsForVisibleRows?.last?.row {
            if builder.models.count - lastRow < 10 {
                builder.addModel()
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? MPDateTableViewCell, let indexPath = self.tableView.indexPath(for: cell), let vc = segue.destination as? MPShowRateViewController{
            let model = self.builder.model(for: indexPath)
            vc.builder = MPShowRateBuilder(date: model.date)
        }
    }
    
    deinit {
        print("deinit ->", self)
    }
    
}
