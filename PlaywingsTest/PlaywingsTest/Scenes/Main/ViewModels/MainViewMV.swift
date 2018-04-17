//
//  MainViewMV.swift
//  PlaywingsTest
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

/// Main Business Logis
class MainViewMV: CommonViewModel {
    
    deinit {
        
        debugPrint("MainViewMV deinit")
    }
    
    /// 현재 로딩한 페이지 넘버
    var currentPageNo: Int = 0
    var brewList: BehaviorSubject<[JSON]>?
    
    let mainModel = MainViewModel()
    
    init(currentPageNo: Int = 0) {
        
        self.currentPageNo = currentPageNo
    }
    
    
    /// Command 설정
    ///
    /// - Parameter command: 설정할 커멘드
    func setCommand(_ command: MainCommand) {
        
        switch command {
        case .loadBrewList(pageNo: let pageNo, perPage: let perPage):
            
            self.loadData(pageNo: pageNo, perPage: perPage)
            break
        }
    }
    
    /// 데이터 로딩
    ///
    /// - Parameters:
    ///   - pageNo: 로딩할 페이지
    ///   - perPage: 페이지당 호출할 데이터 개수
    func loadData(pageNo: Int? = nil, perPage: Int = 10) {
        
        var localPageNo: Int = 0
        if pageNo != nil {
            
            localPageNo = pageNo!
        }
        else {
            
            self.currentPageNo += 1
            localPageNo = self.currentPageNo
        }
        
        self.mainModel.loadData(pageNo: localPageNo, perPage:perPage, successCallBack: { result in
            
            if self.brewList == nil {
                
//                self.beerList = BehaviorSubject(value: result)
            }
            
            
//            Observable.from([1, 3, 5, 7, 9])
//            self.beerList.
        }, failCallBack: {errorCd in
            
        })
    }
}
