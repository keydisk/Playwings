//
//  DetailItemViewController.swift
//  PlaywingsTest
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit

/// DetailView에서 사용하는 커맨드
///
/// - loadDetailData: 상세 정보 조회
enum DetailViewCommand: Command {
    
    case loadDetailData
    
    func excute() {
        
    }
}

/// 음료의 상세 정보를 표시해주는 클래스
class DetailItemViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = DetailViewMV()
    
    let titleCellIdentifer     = "titleCellIdentifer"
    let pictureCellIdentifer   = "pictureCellIdentifer"
    let contentsCellIdentifier = "contentsCellIdentifier"
//    let cellTitleCell = "cellTitleCell"
//    let cellTitleCell = "cellTitleCell"
    
    /// 음료 리스트 구독
    private func brewItemSubscribe() {
        
        _ = self.viewModel.detailItem?.subscribe({ (result) in
            
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
        // Do any additional setup after loading the view.
        self.viewModel.setCommand(DetailViewCommand.loadDetailData)
        
        self.brewItemSubscribe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Implement TableView Delegate
extension DetailItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        do {
//
//            guard let dataSource = try self.viewModel.brewList?.value() else {
//
//                return 0
//            }
//
//            return dataSource.count
//        }
//        catch _ {
//
//            return 0
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.titleCellIdentifer, for: indexPath) as! ListCellTableViewCell
        
//        do {
//
//            guard let dataSource = try self.viewModel.brewList?.value() else {
//
//                return cell
//            }
//
//            cell.cellData = dataSource[indexPath.row]
//
//            debugPrint("indexPath.row : \(indexPath.row)")
//
//            return cell
//        }
//        catch _ {
//
//            return cell
//        }
        
        return cell
    }
}
