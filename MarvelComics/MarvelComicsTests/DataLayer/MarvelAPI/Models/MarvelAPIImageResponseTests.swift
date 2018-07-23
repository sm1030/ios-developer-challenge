//
//  MarvelAPIImageResponseTests.swift
//  MarvelComicsTests
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import MarvelComics

class MarvelAPIImageResponseTests: XCTestCase {
    
    func testGetImage() {
        
        /// Asynchrounus request handler
        var marvelAPI = MarvelAPI()
        var imageResponse: UIImage?
        var errorString: String?
        func getImageSynchronously(imagePath: String, imageExtension: String, sizeVariant: MarvelAPIImageSizeVariant, timeout: TimeInterval = 3) {
            let expectations = XCTestExpectation(description: "getImage")
            marvelAPI.getImage(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: sizeVariant) { (_imageResponse, _errorString) in
                imageResponse = _imageResponse
                errorString = _errorString
                expectations.fulfill()
            }
            wait(for: [expectations], timeout: timeout)
        }
        
        /// Test with BAD base API url
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .automaticStagingFile
        getImageSynchronously(imagePath: "!@£$%^&*()_+", imageExtension: "!@£$%^&*()_+", sizeVariant: .portraitSmall)
        XCTAssertNotNil(errorString)
        XCTAssertNil(imageResponse)
        
        /// Test with NIL data
        let imagePath = "http://i.annihil.us/u/prod/marvel/i/mg/9/90/4bb860a46f58d"
        let imageExtension = "jpg"
        let urlResponse = HTTPURLResponse(url: URL(string: "http//test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse, data: nil, error: nil)
        getImageSynchronously(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: .portraitSmall)
        XCTAssertEqual(errorString, "Response data is NIL")
        XCTAssertNil(imageResponse)
        
        /// Test with SMALL image
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .automaticStagingFile
        getImageSynchronously(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: .portraitSmall)
        XCTAssertNil(errorString)
        XCTAssertNotNil(imageResponse)
        XCTAssertEqual(imageResponse?.size.width, 50)
        XCTAssertEqual(imageResponse?.size.height, 75)
        
        /// Test with MEDIUM image
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .automaticStagingFile
        getImageSynchronously(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: .portraitMedium)
        XCTAssertNil(errorString)
        XCTAssertNotNil(imageResponse)
        XCTAssertEqual(imageResponse?.size.width, 100)
        XCTAssertEqual(imageResponse?.size.height, 171)
        
        /// Test with UNCANNY image
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .automaticStagingFile
        getImageSynchronously(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: .portraitUncanny)
        XCTAssertNil(errorString)
        XCTAssertNotNil(imageResponse)
        XCTAssertEqual(imageResponse?.size.width, 300)
        XCTAssertEqual(imageResponse?.size.height, 450)
        
        /// Test with FULL SIZE image
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .automaticStagingFile
        getImageSynchronously(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: .fullSize)
        XCTAssertNil(errorString)
        XCTAssertNotNil(imageResponse)
        XCTAssertEqual(imageResponse?.size.width, 550)
        XCTAssertEqual(imageResponse?.size.height, 835)
        
        
        /// === INTEGRATION TEST ===
        /// - important: This is testing against a REAL web server!
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .realWebData
        getImageSynchronously(imagePath: imagePath, imageExtension: imageExtension, sizeVariant: .portraitSmall, timeout: 10)
        XCTAssertNil(errorString)
        XCTAssertNotNil(imageResponse)
        XCTAssertEqual(imageResponse?.size.width, 50)
        XCTAssertEqual(imageResponse?.size.height, 75)
    }
}
