//
//  ContentViewModel.swift
//  UserFinder
//
//  Created by Amit Samant on 25/10/20.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    static let strategiesName = ["Git hub", "Stackoverflow"]
    static let strategies: [UserSearchStrategy] = [GitUserStrategy(), StackoverflowStrategy()]
    
    var strategy: UserSearchStrategy = strategies[0]
    var cancellable: AnyCancellable?
    var stretagyCancellable:AnyCancellable?
    
    @Published var text: String = ""
    @Published var selectedStrategyIndex = 0
    @Published var users: [User] = []
    @Published var isLoading = false
    
    init() {
        
        cancellable = $text
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: search(name:))
        
        stretagyCancellable = $selectedStrategyIndex.sink(receiveValue: { [self] in
            // Changes the strategy
            self.strategy = ContentViewModel.strategies[$0]
            self.users = []
            self.search(name: self.text)
        })
        
    }
    
    func search(name: String){
        guard !name.isEmpty else {
            return
        }
        self.isLoading = true
        self.strategy.searchUser(withName: name) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let users):
                    self.users = users
                case .failure(let error):
                    print(error)
                    self.users = []
                }
            }
        }
    }
}
