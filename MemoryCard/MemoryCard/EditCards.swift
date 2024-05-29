//
//  EditCards.swift
//  MemoryCard
//
//  Created by Матвей Глухов on 28.05.2024.
//

import SwiftUI

struct EditCards: View {
    @Environment (\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                    
                    Section {
                        ForEach(0..<cards.count, id: \.self) { index in
                            VStack(alignment: .leading, content: {
                                Text(cards[index].prompt)
                                    .font(.headline)
                                Text(cards[index].answer)
                                    .foregroundStyle(.secondary)
                            })
                        }
                        .onDelete(perform: removeCards)
                    }
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar(content: {
                Button("Done", action: done)
            })
            .onAppear(perform: loadData)
        }
    }
    
    func done() {
        dismiss()
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        savedData()
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        savedData()
    }
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func savedData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
}

#Preview {
    EditCards()
}
