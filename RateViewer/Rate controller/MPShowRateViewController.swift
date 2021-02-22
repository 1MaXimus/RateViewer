//
//  MPShowRateViewController.swift
//  RateViewer
//
//  Created by Maxim Pakhotin on 21.04.2020.
//  Copyright © 2020 Maxim Pakhotin. All rights reserved.
//

import UIKit
struct MPValute {
    var charCode:String?
    var nominal:String?
    var name:String?
    var value:String?
    
}



class MPShowRateParser: NSObject, XMLParserDelegate, IMPValuteFetcher {
    var dateString:String
    var valute:MPValute?
    var eName = ""
    var items = [MPValute]()
    weak var delegate:IMPShowRateDelegate?
    init(date: Date) {
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        dateString = df.string(from: date)
        super.init()
        
    }
    
    func parse() {
        if let url = URL(string: MPConfig.string_url.appending(dateString)) {
            DispatchQueue.main.async {
                let parser = XMLParser(contentsOf: url)
                parser?.delegate = self
                if let success = parser?.parse(), !success {
                    self.delegate?.didEndParsing(message: "Ошибка связи с сервером")
                }
            }
            
            
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName.elementsEqual("Valute") {
            valute = MPValute()
        }
        eName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch eName {
        case "CharCode":
            valute?.charCode = string
        case "Nominal":
            valute?.nominal = string
        case "Name":
            valute?.name = string
        case "Value":
            valute?.value = string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName.elementsEqual("Valute") {
            if let valute = valute, let charCode = valute.charCode, MPConfig.valuteForRate.contains(charCode) {
                items.append(valute)
                if items.count == MPConfig.valuteForRate.count {
                    delegate?.didEndParsing(message: nil)
                }
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        delegate?.didEndParsing(message: parseError.localizedDescription)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        let string = items.isEmpty ? "Валют не найдено" : nil
        delegate?.didEndParsing(message: string)
    }
    deinit {
        print("deinit ->", self)
    }
}

class MPShowRateBuilder: IMPShowRateDelegate {
    
    var fetcher:IMPValuteFetcher
    var completeBlock:((String?) ->())?
    var moddels = [MPValuteCellModel]()
    init(date: Date) {
        fetcher = MPShowRateParser(date: date)
        fetcher.delegate = self
    }
    
    func fetch(complete: @escaping ((String?) ->())) {
        completeBlock = complete
        fetcher.parse()
    }
    
    func didEndParsing(message: String?) {
        configureModels()
        completeBlock?(message)
        
    }
    
    func configureModels() {
        moddels = fetcher.items.map({MPValuteCellModel(item: $0)})
        
    }
    deinit {
        print("deinit ->", self)
    }
    
}

class MPShowRateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var builder:MPShowRateBuilder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.register(UINib(nibName: "MPValuteCell", bundle: nil), forCellReuseIdentifier: "MPValuteCell")
    }
    
    func loadData() {
        tableView.isHidden = true
        activityIndicator.isHidden = false
        builder?.fetch(complete: { [weak self] (errStr) in
            self?.activityIndicator.stopAnimating()
            guard errStr == nil else {
                self?.showAlert(message: errStr)
                return
            }
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return builder?.moddels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MPValuteCell", for: indexPath) as? MPValuteCell, let model = builder?.moddels[indexPath.row] {
            cell.setModel(model: model)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: "УПС!", message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { (action) in
            self.loadData()
        })
        alertController.addAction(retryAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
