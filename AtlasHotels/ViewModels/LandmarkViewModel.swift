//
//  LandMarkViewModel.swift
//  IOSProject_MVVM
//
//  Created by Vishal Bhapkar on 08/08/23.
//

import Foundation

@MainActor
class LandmarkViewModel: ObservableObject {

    // Published properties that trigger UI updates when their values change.
    @Published var hasError: Bool = false
    @Published var textInputForLocation: String = ""
    @Published var state: ViewState = .none

    @Published var entities: [Entity] = []
    private let landMarkService: LandmarkServiceProtocol = LandmarkAPIService()


    // Function to fetch landmarks based on user input.
    func fetchLandMarks() {
        // Validating user input
        guard !textInputForLocation.isEmpty else {
            self.state = .noTextInput
            return
        }
        self.state = .loading
        self.hasError = false
        Task {
            do {
                let decodedData = try await landMarkService.fetchLandMarksData(location: textInputForLocation)
                if decodedData.suggestions[0].entities.isEmpty {
                    self.state = .dataEmpty
                } else {
                    self.state = .success
                    self.entities = decodedData.suggestions[0].entities
                }
            } catch {
                handleFetchError(error)
            }
        }
    }

    // Function to handle fetch errors.
    private func handleFetchError(_ error: Error) {
        state = .failed(error: error)
        hasError = true
    }

    // Function for implementing logout actions.
    func logout() {
        // Implement logout actions here
        // This might include clearing user data, resetting the login state, etc.
    }
}







