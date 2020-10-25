//
//  ContentView.swift
//  UserFinder
//
//  Created by Amit Samant on 25/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    HStack(spacing: 8){
                        TextField("Search", text: $viewModel.text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
                    Picker("Search At",
                           selection: $viewModel.selectedStrategyIndex) {
                        ForEach(0..<2) { row in
                            Text(ContentViewModel.strategiesName[row])
                                .tag(row)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                ForEach(viewModel.users) { user in
                    Text(user.name)
                }
            }
            .navigationTitle("User Search")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
