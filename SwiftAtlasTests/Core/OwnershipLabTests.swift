import Testing

@testable import SwiftAtlas

struct OwnershipLabTests {
  @Test
  func fixedRetainCycleExampleDeallocates() {
    var teacherDeallocated = false
    var sessionDeallocated = false

    var example: FixedRetainCycleExample? = FixedRetainCycleExample(
      onTeacherDeinit: { teacherDeallocated = true },
      onSessionDeinit: { sessionDeallocated = true }
    )
    weak var weakTeacher = example?.teacher
    weak var weakSession = example?.session

    example?.releaseExternalReferences()
    example = nil

    #expect(weakTeacher == nil)
    #expect(weakSession == nil)
    #expect(teacherDeallocated)
    #expect(sessionDeallocated)
  }

  @Test
  func retainCycleExampleStaysAliveUntilBroken() {
    var example: RetainCycleExample? = RetainCycleExample(onTeacherDeinit: {}, onSessionDeinit: {})
    weak var weakTeacher = example?.teacher
    weak var weakSession = example?.session

    example?.releaseExternalReferences()

    #expect(weakTeacher != nil)
    #expect(weakSession != nil)

    example?.breakCycle()
    example = nil
  }
}
