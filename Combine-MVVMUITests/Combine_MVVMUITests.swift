//
//  Combine_MVVMUITests.swift
//  Combine-MVVMUITests
//
//  Created by 서정원 on 3/10/25.
//

import Combine
import XCTest
@testable import Combine_MVVM

final class Combine_MVVMUITests: XCTestCase {
    
    var sut: QuoteViewModel!
    var quoteService: MockQuoteServiceType!
    


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}


class MockQuoteServiceType: QuoteServiceType {
    var value: AnyPublisher<Quote, Error>?
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        return value ?? Empty().eraseToAnyPublisher()
    }
}
