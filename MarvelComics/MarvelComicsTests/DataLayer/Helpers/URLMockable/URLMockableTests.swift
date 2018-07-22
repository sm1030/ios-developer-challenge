//
//  URLMockableTests.swift
//  MarvelComicsTests
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import MarvelComics

class URLMockableTests: XCTestCase {
    
    struct MockableStruct: URLMockable {}
    let mockable = MockableStruct()
    
    func testGetStagingFileName() {
        
        /// Test WITHOUT query string
        var urlRequest = URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/comics")!)
        var fileName = mockable.getStagingFileName(urlRequest: urlRequest)
        XCTAssertEqual(fileName, "GET_v1_public_comics")
        
        /// Test WITH query string
        urlRequest = URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/comics?offset=40&limit=20ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150")!)
        fileName = mockable.getStagingFileName(urlRequest: urlRequest)
        XCTAssertEqual(fileName, "GET_v1_public_comics?limit=20ts=1&offset=40")
        
        /// Test with urlRequest = nil
        fileName = mockable.getStagingFileName(urlRequest: nil)
        XCTAssertEqual(fileName, nil)
    }
    
    func testGetData() {
        
        /// Test getData() from file with nil name
        var data = mockable.getData(fileName: nil)
        XCTAssertNil(data)
        
        /// Test getData() from file with "" name
        data = mockable.getData(fileName: "")
        XCTAssertNil(data)
        
        /// Test getData() from file with "xxx" name
        data = mockable.getData(fileName: "xxx")
        XCTAssertNil(data)
        
        /// Test getData() from file with GOOD JSON content
        data = mockable.getData(fileName: "GET_v1_public_comics")
        XCTAssertNotNil(data)
        
        /// Test getData() from file with GOOD JPEG content
        data = mockable.getData(fileName: "GET_u_prod_marvel_i_mg_4_20_4bc697c680890.jpg")
        XCTAssertNotNil(data)
    }
}
