import XCTest

final class SwiftAtlasLaunchTests: XCTestCase {
  func testLaunchPerformance() throws {
    measure(metrics: [XCTApplicationLaunchMetric()]) {
      XCUIApplication().launch()
    }
  }
}
