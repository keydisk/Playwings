//
//  PlaywingsTestTests.swift
//  PlaywingsTestTests
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import XCTest
import SwiftyJSON
import RxSwift

@testable import PlaywingsTest

class PlaywingsTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// 음료 리스트 가져오는 것을 테스트하는 메소드
    func testGetBrewList() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let mainViewModel = MainViewMV()

        mainViewModel.setCommand(MainCommand.loadBrewList(pageNo: nil, perPage: 10))
        let intervalCount: TimeInterval = 3
        
        let expect = expectation(description: "get brew List")
        
        _ = mainViewModel.brewList?.subscribe({ result in

            switch result {
            case .next( _ ) :

                for i in 0..<BrewListData.shared.count {

                    XCTAssertNotNil(BrewListData.shared.getName(i), "Name 에러")
                    XCTAssertNotNil(BrewListData.shared.getDescription(i), "Description 에러")
                    XCTAssertNotNil(BrewListData.shared.getImgUrl(i), "image url 에러")
                    XCTAssertNotNil(BrewListData.shared.getTip(i), "tip 에러")

                    if  let intredients = BrewListData.shared.getIngredients(i),
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

                    XCTAssertNotNil(BrewListData.shared.getAbv(i), "Abv 에러")
                }

                if Int(intervalCount * 10) == BrewListData.shared.count {

                    expect.fulfill()
                }
                else {

                    mainViewModel.setCommand(MainCommand.loadBrewList(pageNo: nil, perPage: 10))
                }

                break

            case .completed :
                break
            case .error(let error as NSError) :

                XCTAssertNotNil(nil, "error code : \(error.code)")
                break
            default :
                break
            }
        })
        
        waitForExpectations(timeout: NetworkConstants.NetworkTimeout * intervalCount, handler: nil)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
