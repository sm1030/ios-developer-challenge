//
//  MarvelAPITests.swift
//  MarvelComicsTests
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import MarvelComics

class MarvelAPITests: XCTestCase {
    
    var marvelAPI = MarvelAPI()
    var responseData: Data?
    var responseErrorString: String?
    
    override func setUp() {
        super.setUp()
        
        marvelAPI = MarvelAPI()
    }
    
    func testAuthenticationSignature() {
        
        /// Calculate HASH
        let timeStamp = "1"
        let publicKey = "1234"
        let privateKey = "abcd"
        let hash = MD5( timeStamp + privateKey + publicKey ).lowercased()
        XCTAssertEqual(hash, "ffd275c5130566a2916217b101f26150")
        
        /// Calculate whole authentication string
        let signature = MarvelAPI.authenticationSignature(timeStamp: timeStamp, publicKey: publicKey, privateKey: privateKey)
        XCTAssertEqual(signature, "ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150")
    }
    
    func getDataSynchronously(urlRequest: URLRequest) {
        let expectation = XCTestExpectation(description: "getData")
        marvelAPI.getData(urlRequest: urlRequest) { [weak self] (data, errorString) in
            self?.responseData = data
            self?.responseErrorString = errorString
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetData() {
        let urlString = "https://gateway.marvel.com/v1/public/comics"
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        let urlResponse200 = HTTPURLResponse(url: URL(string: urlString)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let urlResponse400 = HTTPURLResponse(url: URL(string: urlString)!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        /// Test status code not 200
        marvelAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse400, data: nil, error: nil)
        getDataSynchronously(urlRequest: urlRequest)
        XCTAssertNotNil(responseErrorString)
        XCTAssertNil(responseData)
        
        /// Test status code not 200 with MarvelAPIErrorResponse
        let errorResponse = FileHandle(forReadingAtPath: Bundle.main.path(forResource: "MarvelAPIErrorResponse", ofType: "")!)?.readDataToEndOfFile()
        marvelAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse400, data: errorResponse, error: nil)
        getDataSynchronously(urlRequest: urlRequest)
        XCTAssertNotNil(responseErrorString)
        XCTAssertNil(responseData)
        
        /// Test NIL data
        marvelAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse200, data: nil, error: nil)
        getDataSynchronously(urlRequest: urlRequest)
        XCTAssertNotNil(responseErrorString)
        XCTAssertNil(responseData)
        
        /// Test SUCCESS
        marvelAPI.mockableURLSession.mockMode = .stagingFile(fileName: "MarvelAPIErrorResponse")
        getDataSynchronously(urlRequest: urlRequest)
        XCTAssertNil(responseErrorString)
        XCTAssertNotNil(responseData)
        if let responseData = responseData {
            let errorResponse: MarvelAPIErrorResponse? = marvelAPI.decode(data: responseData)
            XCTAssertNotNil(errorResponse)
            XCTAssertEqual(errorResponse?.code, "MissingParameter")
            XCTAssertEqual(errorResponse?.message, "You must provide a hash.")
        }
        
        
        /// https://i.annihil.us/u/prod/marvel/i/mg/4/20/4bc697c680890.jpg
        /// GET_u_prod_marvel_i_mg_4_20_4bc697c680890.jpg
    }
    
    func testDecode() {
        
        /// Test decoding BAD data
        let nilData = Data()
        var errorResponse: MarvelAPIErrorResponse? = marvelAPI.decode(data: nilData)
        XCTAssertNil(errorResponse)

        /// Test decoding GOOD data
        let data = FileHandle(forReadingAtPath: Bundle.main.path(forResource: "MarvelAPIErrorResponse", ofType: "")!)?.readDataToEndOfFile()
        XCTAssertNotNil(data)
        if let data = data {
            errorResponse = marvelAPI.decode(data: data)
            XCTAssertNotNil(errorResponse)
            XCTAssertEqual(errorResponse?.code, "MissingParameter")
            XCTAssertEqual(errorResponse?.message, "You must provide a hash.")
        }
    }
}
