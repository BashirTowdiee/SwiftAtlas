import Foundation

open class BaseFormatter {
  public required init(prefix: String) {
    self.prefix = prefix
  }

  let prefix: String

  class var strategyName: String { "base" }

  open func format(_ input: String) -> String {
    "\(prefix) \(input)"
  }
}

class LessonFormatter: BaseFormatter {
  required init(prefix: String) {
    super.init(prefix: prefix)
  }

  override class var strategyName: String { "lesson" }

  override func format(_ input: String) -> String {
    super.format(input.capitalized)
  }
}

final class MarkdownFormatter: LessonFormatter {
  override class var strategyName: String { "markdown" }

  override func format(_ input: String) -> String {
    "**" + super.format(input) + "**"
  }
}

final class DebugFormatter: LessonFormatter {
  override class var strategyName: String { "debug" }

  override func format(_ input: String) -> String {
    "[\(Self.strategyName)] " + super.format(input)
  }
}
