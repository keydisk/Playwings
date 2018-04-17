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
    
    case loadBrewList(pageNo: Int, perPage: Int)
    
    func excute() {
        
        
    }
}

/// MainViewController
class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIndentifier = "cell"
    let viewModel = MainViewMV()
    
    /// 음료 리스트 구독
    private func brewListSubscribe() {
        
        self.viewModel.brewList?.subscribe({ (result) in
            
            switch result {
                
            case .completed :
                self.tableView.reloadData()
                break
            case .error( _) :
                break
            case .next( _ ) :
                break
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.viewModel.setCommand(MainCommand.loadBrewList(pageNo: 1, perPage: 10))
        
        self.brewListSubscribe()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

//MARK: - Implement TableView Delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        self.viewModel.beerList
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIndentifier, for: indexPath)
        
        let data = self.viewModel.beerList?.elementAt(indexPath.row)
        debugPrint(data)
        
        return cell
    }
}
