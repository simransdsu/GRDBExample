//
//  ContentView.swift
//  GRDBExample
//
//  Created by Simran Preet Singh Narang on 2022-07-04.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        Form {
            TextField("Name", text: $vm.name)
            TextField("Score", text: $vm.score)
            Button("Save") {
                Task {
                    await vm.save()
                }
            }
            
            Section("Players") {
                List {
                    ForEach(vm.players, id: \.id) { player in
                        VStack(alignment: .leading) {
                            Text(player.name)
                            Text("\(player.score)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            await vm.deletePlayer(at: indexSet)
                        }
                    }
                }
            }
        }
        .task {
            await vm.fetchPlayer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class ViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var score: String = ""
    
    @Published var players = [Player]()
    
    private var repository = PlayerRepository()
    
    @MainActor func save() async {
        
        _ = await repository.create(withName: name, score: Int(score) ?? 0)
        name = ""
        score = ""
        await fetchPlayer()
    }
    
    @MainActor func fetchPlayer() async {
        players = await repository.fetchAll() ?? []
    }
    
    @MainActor func deletePlayer(at indexSet: IndexSet) async {
        
        let playerToDelete = players[indexSet.first ?? 0]
        await repository.delete(playerToDelete)
        await fetchPlayer()
    }
}
