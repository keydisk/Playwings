//
//  DetailItemMV.swift
//  PlaywingsTest
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

/// 디테일뷰 모델뷰
class DetailViewMV: CommonViewModel, CommonViewModelProtocol {
    
    public var selectIndex: Int = 0
    var detailItem: BehaviorSubject<JSON>?
    
    /// Command 설정
    ///
    /// - Parameter command: 설정할 커멘드
    func setCommand(_ command: Command) {
        
        switch command as? DetailViewCommand {
        case .loadDetailData? :
            
            var json = JSON()
            
            json["description"] = "Test"
            
            self.detailItem = BehaviorSubject<JSON>(value: json)
            
            break
        default :
            break
        }
    }
}
