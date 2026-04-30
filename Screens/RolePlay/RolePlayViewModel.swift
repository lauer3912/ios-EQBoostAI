import Foundation

class RolePlayViewModel {

    let scenarioService = ScenarioService.shared

    var filteredScenarios: [Scenario] = []
    var onScenariosUpdated: (() -> Void)?

    private var currentFilter: ScenarioFilter = .all

    func loadScenarios() {
        filteredScenarios = scenarioService.getAllScenarios()
        onScenariosUpdated?()
    }

    func applyFilter(_ filter: ScenarioFilter) {
        currentFilter = filter
        switch filter {
        case .all:
            filteredScenarios = scenarioService.getAllScenarios()
        case .free:
            filteredScenarios = scenarioService.getFreeScenarios()
        case .premium:
            filteredScenarios = scenarioService.getAllScenarios().filter { $0.isPremium }
        }
        onScenariosUpdated?()
    }
}