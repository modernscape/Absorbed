//
//  ReorderScreen.swift
//  Absorbed
//
//  Created by bird on 2024/03/15.
//

import SwiftUI


struct ReorderScreen: View {
    
    @Environment(\.modelContext) private var modelContext
    @AppStorage(KeyString.magnifyBy.rawValue) var magnifyBy = 1.0
    
    var categories : [Category]!
    
    @State var editMode: EditMode = .active
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(categories.enumerated()), id: \.element) { index, cat in
                    HStack {
                        Text("\(index+1)")
                            .foregroundStyle(.gray)
                            .padding(.trailing, 3)
                        Text(categories[index].title)
                            .bold()
                    }
               
                }
                //            .onMove(perform: move)
                .onMove { source, destination in
                    // Make a copy of the current list of items
                    var updatedItems = categories!
                    
                    // Apply the move operation to the items
                    updatedItems.move(fromOffsets: source, toOffset: destination)
                    
                    
                    for i in (0..<updatedItems.count) {
                        let item = updatedItems[i]
                        
                        for cat in categories {
                            if cat.index == item.index {
                                cat.index = i
                                for item in cat.items {
                                    item.catIndex = i
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("並べ替え")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.editMode, self.$editMode)
            
        }
    }
}

#Preview {
    ReorderScreen()
}
