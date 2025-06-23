//
//  BitLabsAPITest.swift
//  BitLabs-Unit-Tests
//
//  Created by Omar Raad on 11.10.23.
//

@testable import BitLabs
import Foundation
import XCTest
import Mocker

class BitLabsAPITest: XCTestCase {
    
    var session: URLSession!
    var bitlabsAPI: BitLabsAPI!
    var encoder = JSONEncoder() { didSet { encoder.keyEncodingStrategy = .convertToSnakeCase } }
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        session = URLSession(configuration: configuration)
        bitlabsAPI = BitLabsAPI(session)
    }
    
    override func tearDown() {
        Mocker.removeAll()
        bitlabsAPI = nil
        session = nil
        super.tearDown()
    }
    
    func testGetSurveys_Failure() {
        let url = BitLabsRouter.getSurveys(sdk: "").asURLRequest().url!
        let mock = Mock(url: url, ignoreQuery: true, dataType: .json, statusCode: 500, data: [.get: Data()], requestError: Exception("Error"))
        mock.register()
        
        let expectation = XCTestExpectation(description: "Error received")
        bitlabsAPI.getSurveys(sdk: "") { result in
            switch result {
            case .success(let surveys):
                XCTFail("Request succeeded: \(surveys)")
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetSurveys_Response_Success() {
        let json = try! encoder.encode(
            BitLabsResponse(
                data: GetSurveysResponse(restrictionReason: nil, surveys: [Survey(id: "1", type: "", clickUrl: "", cpi: "", value: "", loi: 0.0, country: "", language: "", rating: 0, category: Category(name: "", iconUrl: "", iconName: "", nameInternal: ""), tags: [])]),
                error: nil,
                status: "",
                traceId: ""
            )
        )
        
        let url = BitLabsRouter.getSurveys(sdk: "").asURLRequest().url!
        let mock = Mock(url: url, ignoreQuery: true, dataType: .json, statusCode: 200, data: [.get: json])
        mock.register()
        
        let expectation = XCTestExpectation(description: "Response received")
        bitlabsAPI.getSurveys(sdk: "") { result in
            switch result {
            case .success(let surveys):
                XCTAssertTrue(surveys.first?.id == "1")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetSurveys_Response_Error() {
        let json = try! encoder.encode(
            BitLabsResponse<GetSurveysResponse>(
                data: nil,
                error: ErrorResponse(details: ErrorDetails(http: "400", msg: "Response Error")),
                status: "",
                traceId: ""
            )
        )
        
        let url = BitLabsRouter.getSurveys(sdk: "").asURLRequest().url!
        let mock = Mock(url: url, ignoreQuery: true, dataType: .json, statusCode: 200, data: [.get: json])
        mock.register()
        
        
        let expectation = XCTestExpectation(description: "Error received")
        bitlabsAPI.getSurveys(sdk: "") { result in
            switch result {
            case .success(let surveys):
                XCTFail("Request succeeded: \(surveys)")
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
