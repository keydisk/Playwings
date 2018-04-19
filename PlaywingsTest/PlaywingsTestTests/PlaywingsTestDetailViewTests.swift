//
//  PlaywingsTestDetailViewTests.swift
//  PlaywingsTestTests
//
//  Created by JuYoung choi on 2018. 4. 18..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import XCTest

import RxSwift
import SwiftyJSON

@testable import PlaywingsTest

class PlaywingsTestDetailViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// 개별 요소에 대한 유효성 검사
    ///
    /// - Parameter element: element
    private func validData(element: JSON) {
        
        XCTAssertNotNil(element["description"].string, "description 에러")
        XCTAssertNotNil(element["imgUrl"].string,      "imgUrl 에러")
        XCTAssertNotNil(element["name"].string,        "name 에러")
        XCTAssertNotNil(element["abv"].string,         "abv 에러")
        
        if  let intredients = element["ingredients"].object as? JSON,
            let malts = intredients["malt"].array,
            let hops  = intredients["hops"].array {
            
            for malt in malts {
                
                XCTAssertNotNil(malt["name"].string, "malt Name 에러")
                XCTAssertNotNil(malt["amount"]["value"].number, "malt Amount value 에러")
                XCTAssertNotNil(malt["amount"]["unit"].string, "malt Amount unit 에러")
            }
            
            for hop in hops {
                
                XCTAssertNotNil(hop["amount"]["value"].number, "hop amount의 value 에러")
                XCTAssertNotNil(hop["amount"]["unit"].string, "hop amount의 unit  에러")
            }
        }
        else {
            
            XCTAssert(false, "구성 요소 에러")
        }
    }
    
    /// testItemDetail test
    func testItemDetail() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expect = expectation(description: "getBrewDetailInfo")
        
        let mainViewModel = MainViewMV()
        
        mainViewModel.setCommand(MainCommand.loadBrewList(pageNo: nil, perPage: 10))
        
        _ = mainViewModel.brewList?.subscribe( {result in
            
            switch result {
            case .next(let element) :
                if element.count > 0 {
                    
                    let viewModel = DetailViewMV()
                    
                    for i in 0..<BrewListData.shared.count {
                        
                        viewModel.selectIndex = i
                        viewModel.setCommand(DetailViewCommand.loadDetailData)
                        
                        _ = viewModel.detailItem?.subscribe({ result in
                            
                            switch result {
                            case .next(let element ) :
                                self.validData(element: element)
                                break
                            case .completed :
                                
                                break
                            case .error(let error as NSError):
                                XCTAssertNil(nil, "error code : \(error.code)")
                                break
                            }
                        })
                    }
                    
                    expect.fulfill()
                }
                
                break
            case .completed :
                break
            case .error(let error as NSError) :
                
                XCTAssertNil(nil, "error code : \(error.code)")
                break
            }
        })
        
        waitForExpectations(timeout: NetworkConstants.NetworkTimeout * 2, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
