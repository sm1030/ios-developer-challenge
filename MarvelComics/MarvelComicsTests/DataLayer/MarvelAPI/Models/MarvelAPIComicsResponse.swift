//
//  MarvelAPIComicsResponse.swift
//  MarvelComicsTests
//
//  Created by Alexandre Malkov on 22/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import MarvelComics

class MarvelAPIComicsResponseTests: XCTestCase {
    
    func testGetComics() {
        
        /// Asynchrounus request handler
        var marvelAPI = MarvelAPI()
        var comicsResponse: MarvelAPIComicsResponse?
        var errorString: String?
        func getComicsSynchronously(limit: Int? = nil, offset: Int? = nil, timeout: TimeInterval = 3) {
            let expectations = XCTestExpectation(description: "getCategories")
            marvelAPI.getComics(limit: limit, offset: offset, completion: { (_comicsResponse, _errorString) in
                comicsResponse = _comicsResponse
                errorString = _errorString
                expectations.fulfill()
            })
            wait(for: [expectations], timeout: timeout)
        }
        
        /// Test with BAD base API url
        marvelAPI = MarvelAPI()
        marvelAPI.baseURL = "!@£$%^&*()_+"
        marvelAPI.mockableURLSession.mockMode = .automaticStagingFile
        getComicsSynchronously()
        XCTAssertNotNil(errorString)
        XCTAssertNil(comicsResponse)
        
        /// Test with NIL data
        let urlResponse = HTTPURLResponse(url: URL(string: "http//test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse, data: nil, error: nil)
        getComicsSynchronously()
        XCTAssertEqual(errorString, "Response data is NIL")
        XCTAssertNil(comicsResponse)
        
        /// Test with GOOD data
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .automaticStagingFile
        getComicsSynchronously(limit: 20, offset: 0)
        XCTAssertNil(errorString)
        XCTAssertNotNil(comicsResponse)
        if let comicsResponse = comicsResponse {
            XCTAssertEqual(comicsResponse.code, 200)
            XCTAssertEqual(comicsResponse.status, "Ok")
            XCTAssertEqual(comicsResponse.copyright, "© 2018 MARVEL")
            XCTAssertEqual(comicsResponse.attributionText, "Data provided by Marvel. © 2018 MARVEL")
            XCTAssertEqual(comicsResponse.attributionHTML, "<a href=\"http://marvel.com\">Data provided by Marvel. © 2018 MARVEL</a>")
            XCTAssertEqual(comicsResponse.etag, "9c0da1d1a0fce63db4bb9d768c1142a9b0fb581a")

            let comicDataContainer = comicsResponse.data
            XCTAssertEqual(comicDataContainer?.offset, 0)
            XCTAssertEqual(comicDataContainer?.limit, 20)
            XCTAssertEqual(comicDataContainer?.total, 42265)
            XCTAssertEqual(comicDataContainer?.count, 20)
            
            
            let results = comicsResponse.data?.results
            XCTAssertEqual(results?.count, 20)
            if results?.count ?? 0 == 20 {

                if let comic = results?.first {
                    XCTAssertEqual(comic.id, 20956)
                    XCTAssertEqual(comic.thumbnail?.path, "http://i.annihil.us/u/prod/marvel/i/mg/9/90/4bb860a46f58d")
                    XCTAssertEqual(comic.thumbnail?.imageExtension, "jpg")
                }

                if let comic = results?.last {
                    XCTAssertEqual(comic.id, 21476)
                    XCTAssertEqual(comic.thumbnail?.path, "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available")
                    XCTAssertEqual(comic.thumbnail?.imageExtension, "jpg")
                }
            }
        }
        
        /// === INTEGRATION TEST ===
        /// - important: This is testing against a REAL web server!
        marvelAPI = MarvelAPI()
        marvelAPI.mockableURLSession.mockMode = .realWebData
        getComicsSynchronously(limit: 20, offset: 0, timeout: 10)
        XCTAssertNil(errorString)
        XCTAssertNotNil(comicsResponse)
        if let comicsResponse = comicsResponse {
            XCTAssertEqual(comicsResponse.code, 200)
            XCTAssertEqual(comicsResponse.status, "Ok")
            XCTAssertEqual(comicsResponse.copyright, "© 2018 MARVEL")
            XCTAssertEqual(comicsResponse.attributionText, "Data provided by Marvel. © 2018 MARVEL")
            XCTAssertEqual(comicsResponse.attributionHTML, "<a href=\"http://marvel.com\">Data provided by Marvel. © 2018 MARVEL</a>")
        }
    }
}
