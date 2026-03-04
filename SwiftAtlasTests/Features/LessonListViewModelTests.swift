import Foundation
import Testing
@testable import SwiftAtlas

struct LessonListViewModelTests {
    @MainActor
    @Test
    func loadPopulatesGroupsFromRepository() async {
        let viewModel = LessonListViewModel()
        let container = TestContainerFactory.makeContainer()

        await viewModel.bind(container: container)

        guard case let .loaded(groups, _) = viewModel.loadState else {
            Issue.record("Expected loaded state after bind.")
            return
        }

        #expect(groups.isEmpty == false)
    }

    @MainActor
    @Test
    func searchQueryFiltersLoadedLessons() async throws {
        let viewModel = LessonListViewModel()
        let container = TestContainerFactory.makeContainer()

        await viewModel.bind(container: container)
        viewModel.searchQuery = "concurrency"
        try await Task.sleep(for: .milliseconds(350))

        guard case let .loaded(groups, _) = viewModel.loadState else {
            Issue.record("Expected loaded search results.")
            return
        }

        let titles = groups.flatMap(\.lessons).map { $0.title.lowercased() }
        #expect(titles.allSatisfy { $0.contains("concurrency") })
    }

    @MainActor
    @Test
    func pinningCanDriveFilteredResults() async {
        let viewModel = LessonListViewModel()
        let container = TestContainerFactory.makeContainer()

        await viewModel.bind(container: container)
        viewModel.togglePin(for: 1)
        viewModel.showPinnedOnly = true
        viewModel.searchQuery = ""

        guard case let .loaded(groups, _) = viewModel.loadState else {
            Issue.record("Expected loaded pinned results.")
            return
        }

        #expect(groups.flatMap(\.lessons).allSatisfy { $0.id == 1 })
    }
}
