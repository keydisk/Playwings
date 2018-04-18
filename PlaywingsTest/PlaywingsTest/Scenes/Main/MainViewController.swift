//
//  ViewController.swift
//  PlaywingsTest
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON


/// MainCommand
enum MainCommand: Command {
    
    case loadBrewList(pageNo: Int?, perPage: Int)
    
    func excute() {
        
    }
}

/// MainViewController
class MainViewController: BaseViewController {

    //MARK: - Properties ~
    @IBOutlet weak var tableView: UITableView!
    
    let cellIndentifier = "brewCell"
    let viewModel = MainViewMV()
    let perPage:Int = 10
    
    //MARK: - Methods~
    /// 음료 리스트 구독
    private func brewListSubscribe() {
        
        _ = self.viewModel.brewList?.subscribe({ (result) in
            
            switch result {
                
            case .completed :
                
                break
            case .error( _ ) :
                break
            case .next( _ ) :
                
                self.stopIndigator()
                self.tableView.reloadData()
                break
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationTitle = "Brew List~"
        self.startIndigator()
        self.viewModel.setCommand(MainCommand.loadBrewList(pageNo: nil, perPage: self.perPage))
        
        self.brewListSubscribe()
        
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let identifier = segue.identifier
        
        if identifier == "showDetailView" {
            
            if let selectIndex = sender as? NSNumber {
                
                let nextViewCtr = segue.destination as! DetailItemViewController
                
                nextViewCtr.viewModel.selectIndex = selectIndex.intValue
            }
        }
    }
    
}

//MARK: - Implement TableView Delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BrewListData.shared.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIndentifier, for: indexPath) as! ListCellTableViewCell
        
        cell.tag = indexPath.row
        
        if indexPath.row == BrewListData.shared.count - 1 {
            
            self.viewModel.setCommand(MainCommand.loadBrewList(pageNo: nil, perPage: self.perPage))
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectIndex = NSNumber(value: indexPath.row)
        self.performSegue(withIdentifier: "showDetailView", sender: selectIndex)
    }
    
}
