import XCTest

final class SwiftAtlasUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAppLaunchesAndShowsTabs() {
        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.tabBars.buttons["Lessons"].exists)
        XCTAssertTrue(app.tabBars.buttons["Labs"].exists)
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }

    func testHomeQuickActionsNavigateToLessonsAndLabs() {
        XCTAssertTrue(app.otherElements["home.screen"].waitForExistence(timeout: 2))

        app.buttons["home.openLessons"].tap()
        XCTAssertTrue(app.otherElements["lessons.screen"].waitForExistence(timeout: 2))

        app.tabBars.buttons["Home"].tap()
        XCTAssertTrue(app.otherElements["home.screen"].waitForExistence(timeout: 2))

        app.buttons["home.openLabs"].tap()
        XCTAssertTrue(app.otherElements["labs.screen"].waitForExistence(timeout: 2))
    }

    func testLessonsSupportsSearchFilterAndDetail() {
        app.tabBars.buttons["Lessons"].tap()
        XCTAssertTrue(app.otherElements["lessons.screen"].waitForExistence(timeout: 2))

        let searchField = app.searchFields["Search lessons, tracks, or mentors"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("MVVM")

        let filterButton = app.buttons["lessons.filterButton"]
        XCTAssertTrue(filterButton.exists)
        filterButton.tap()
        XCTAssertTrue(app.otherElements["lessons.filterSheet"].waitForExistence(timeout: 2))
        app.swipeDown()

        let firstRow = app.otherElements["lessons.row.1"]
        XCTAssertTrue(firstRow.waitForExistence(timeout: 2))
        firstRow.tap()
        XCTAssertTrue(app.otherElements["lessonDetail.screen"].waitForExistence(timeout: 2))
    }

    func testSettingsExposesCriticalControls() {
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.otherElements["settings.screen"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.segmentedControls["settings.themePicker"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.switches["settings.flag.labsEnabled"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.textFields["settings.secretField"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["settings.clearCache"].waitForExistence(timeout: 2))
    }

    func testLabsOpensDestination() {
        app.tabBars.buttons["Labs"].tap()
        XCTAssertTrue(app.otherElements["labs.screen"].waitForExistence(timeout: 2))

        let componentsRow = app.otherElements["labs.row.components"]
        XCTAssertTrue(componentsRow.waitForExistence(timeout: 2))
        componentsRow.tap()

        XCTAssertTrue(app.navigationBars["Components"].waitForExistence(timeout: 2))
    }
}
