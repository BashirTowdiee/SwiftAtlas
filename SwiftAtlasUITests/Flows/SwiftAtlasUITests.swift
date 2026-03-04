import XCTest

final class SwiftAtlasUITests: XCTestCase {
    func testAppLaunchesAndShowsTabs() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.tabBars.buttons["Lessons"].exists)
        XCTAssertTrue(app.tabBars.buttons["Labs"].exists)
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }
}
