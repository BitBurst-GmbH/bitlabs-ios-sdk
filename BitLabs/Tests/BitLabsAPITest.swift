//
//  BitLabsAPITest.swift
//  BitLabs-Unit-Tests
//
//  Created by Omar Raad on 11.10.23.
//

@testable import Alamofire
@testable import BitLabs
import OHHTTPStubs
import Foundation
import XCTest

func forAll() -> HTTPStubsTestBlock {
  return { _ in  return true }
}

class BitLabsAPITest: XCTestCase {
    
    var encoder = JSONEncoder() { didSet { encoder.keyEncodingStrategy = .convertToSnakeCase } }
    
    override class func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testGetSurveys_Failure() {
        stub(condition: forAll()) {_ in
         return HTTPStubsResponse(error: Exception("Failure Error"))
        }

        let bitlabsAPI = BitLabsAPI(Session())

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
        do {
            let json = try encoder.encode(BitLabsResponse(data: GetSurveysResponse(restrictionReason: nil, surveys: [Survey(id: "", type: "", clickUrl: "", cpi: "", value: "", loi: 0.0, country: "", language: "", rating: 0, category: Category(name: "", iconUrl: "", iconName: "", nameInternal: ""), tags: [])]), error: nil, status: "", traceId: ""))
                        
            stub(condition: forAll()) { _ in
                return HTTPStubsResponse(data: json, statusCode: Int32(200), headers: ["Content-Type": "application/json"])
            }
            
            let bitlabsAPI = BitLabsAPI(Session())
            let expectation = XCTestExpectation(description: "Response received")
            
            bitlabsAPI.getSurveys(sdk: "") { result in
                switch result {
                case .success(_):
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                }
            }
            
            wait(for: [expectation], timeout: 10.0)
        } catch(let error) {
            XCTFail("Failed to parse hardcoded. Error: \(error)")
        }
    }
    
    func testGetSurveys_Response_Error() {
        do {
            let json = try encoder.encode(BitLabsResponse<GetSurveysResponse>(data: nil, error: ErrorResponse(details: ErrorDetails(http: "400", msg: "Response Error")), status: "", traceId: ""))
            
            stub(condition: forAll()) { _ in
                return HTTPStubsResponse(data: json, statusCode: Int32(200), headers: ["Content-Type": "application/json"])
            }
            
            let bitlabsAPI = BitLabsAPI(Session())

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
        } catch(let error) {
            XCTFail("Failed to parse hardcoded. Error: \(error)")
        }
    }
    
    func testGetHasOffers_Failure() {
        stub(condition: forAll()) {_ in
         return HTTPStubsResponse(error: Exception("Failure Error"))
        }

        let bitlabsAPI = BitLabsAPI(Session())

        let expectation = XCTestExpectation(description: "Error received")
        bitlabsAPI.getHasOffers { result in
            XCTAssertEqual(result, false)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetHasOffers_Response_Success() {
        do {
            let json = try encoder.encode(BitLabsResponse(data: GetOffersResponse(offers: [Offer(id: 0)]), error: nil, status: "", traceId: ""))
            
            stub(condition: forAll()) { _ in
                return HTTPStubsResponse(data: json, statusCode: Int32(200), headers: ["Content-Type": "application/json"])
            }

            let bitlabsAPI = BitLabsAPI(Session())

            let expectation = XCTestExpectation(description: "Response received")
            bitlabsAPI.getHasOffers { result in
                XCTAssertEqual(result, true)
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to parse hardcoded. Error: \(error)")
        }
    }
    
    func testGetHasOffers_Response_Error() {
        do {
            let json = try encoder.encode(BitLabsResponse<GetSurveysResponse>(data: nil, error: ErrorResponse(details: ErrorDetails(http: "400", msg: "Response Error")), status: "", traceId: ""))

            stub(condition: forAll()) { _ in
                return HTTPStubsResponse(data: json, statusCode: Int32(200), headers: ["Content-Type": "application/json"])
            }

            let bitlabsAPI = BitLabsAPI(Session())

            let expectation = XCTestExpectation(description: "Error received")
            bitlabsAPI.getHasOffers { result in
                XCTAssertEqual(result, false)
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to parse hardcoded. Error: \(error)")
        }
    }
    
    func testGetAppSettings_Failure() {
        stub(condition: forAll()) {_ in
         return HTTPStubsResponse(error: Exception("Failure Error"))
        }

        let bitlabsAPI = BitLabsAPI(Session())

        let expectation = XCTestExpectation(description: "Error received")
        expectation.isInverted = true
        bitlabsAPI.getAppSettings { visual, isOffersEnabled, currency, promotion  in
            
            XCTFail("Completion block should not be called for erros")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetAppSettings_Response_Success() {
        do {
            let json = try encoder.encode(BitLabsResponse(data: GetAppSettingsResponse(visual: Visual(backgroundColor: "", colorRatingThreshold: 0, customLogoUrl: "", elementBorderRadius: "", hideRewardValue: true, interactionColor: "", navigationColor: "", offerwallWidth: "", screenoutReward: "", surveyIconColor: ""), offers: Offers(enabled: true), currency: Currency(floorDecimal: true, factor: "", symbol: Symbol(content: "", isImage: true), currencyPromotion: nil, bonusPercentage: 20), promotion: Promotion(startDate: "", endDate: "", bonusPercentage: 1)), error: nil, status: "", traceId: ""))
            
            stub(condition: forAll()) { _ in
                return HTTPStubsResponse(data: json, statusCode: Int32(200), headers: ["Content-Type": "application/json"])
            }

            let bitlabsAPI = BitLabsAPI(Session())

            let expectation = XCTestExpectation(description: "Response received")
            bitlabsAPI.getAppSettings { visual, isOffersEnabled, currency, promotion  in
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to parse hardcoded. Error: \(error)")
        }
    }

    func testGetAppSettings_Response_Error() {
        do {
            let json = try encoder.encode(BitLabsResponse<GetSurveysResponse>(data: nil, error: ErrorResponse(details: ErrorDetails(http: "400", msg: "Response Error")), status: "", traceId: ""))
            
            stub(condition: forAll()) { _ in
                return HTTPStubsResponse(data: json, statusCode: Int32(200), headers: ["Content-Type": "application/json"])
            }

            let bitlabsAPI = BitLabsAPI(Session())

            let expectation = XCTestExpectation(description: "Error received")
            expectation.isInverted = true
            
            bitlabsAPI.getAppSettings { visual, isOffersEnabled, currency, promotion  in
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to parse hardcoded. Error: \(error)")
        }
    }
    
    func testGetLeaderboard_Failure() {
        stub(condition: forAll()) {_ in
         return HTTPStubsResponse(error: Exception("Failure Error"))
        }

        let bitlabsAPI = BitLabsAPI(Session())

        let expectation = XCTestExpectation(description: "Error received")
        expectation.isInverted = true
        bitlabsAPI.getLeaderboard { _ in
            XCTFail("Completion block should not be called")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetLeaderboard_Response_Success() {
        do {
            let json = try encoder.encode(BitLabsResponse(data: GetLeaderboardResponse(nextResetAt: "", ownUser: User(earningsRaw: 0.0, name: "", rank: 0), rewards: [Reward(rank: 0, rewardRaw: 0.0)], topUsers: nil), error: nil, status: "", traceId: ""))
            
            stub(condition: forAll()) { _ in
                return HTTPStubsResponse(data: json, statusCode: Int32(200), headers: ["Content-Type": "application/json"])
            }

            let bitlabsAPI = BitLabsAPI(Session())

            let expectation = XCTestExpectation(description: "Response received")
            bitlabsAPI.getLeaderboard { leaderboard in
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to parse hardcoded. Error: \(error)")
        }
    }

    func testGetLeaderboard_Response_Error() {
        do {
            let json = try encoder.encode(BitLabsResponse<GetSurveysResponse>(data: nil, error: ErrorResponse(details: ErrorDetails(http: "400", msg: "Response Error")), status: "", traceId: ""))
            
            stub(condition: forAll()) { _ in
                return HTTPStubsResponse(data: json, statusCode: Int32(200), headers: ["Content-Type": "application/json"])
            }

            let bitlabsAPI = BitLabsAPI(Session())

            let expectation = XCTestExpectation(description: "Error received")
            expectation.isInverted = true

            bitlabsAPI.getLeaderboard { _ in
                XCTFail("Completion block should not be called")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        } catch {
            XCTFail("Failed to parse hardcoded. Error: \(error)")
        }
    }
}
