import Foundation

actor ConcurrencyDemoCounter {
  private var count = 0

  func increment() -> Int {
    count += 1
    return count
  }
}
