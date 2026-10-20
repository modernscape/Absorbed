//
//  TaskView.swift
//  Absorbed
//
//  Created by bird on 2024/04/24.
//

import SwiftUI


struct TaskRow: View {
    
    var phase: Phase
    

    let grids = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        
        GeometryReader {reader in
            
            HStack {
                HStack {
                    
                    Image(systemName: phase.isDone != nil && phase.isDone! ? "checkmark.square" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(colorForIndex(phase.item.catIndex))
                        .onTapGesture {
                            phase.isDone!.toggle()
                        }
                    
                    Text(phase.title)
                        .font(.system(size: 16))
                        .minimumScaleFactor(0.1)
                        .foregroundColor(colorForIndex(phase.item.catIndex))
                    
    
                    
                }
                .frame(width: reader.size.width*0.3, alignment: .leading)
                
//                HStack {
                    
//                    ForEach(0..<7) {_ in
//                        Rectangle()
//                            .background(.gray)
//                
//                        
//                    }
                    
//                    ScrollView {
                        
                        LazyHGrid(rows: grids, alignment: .center, spacing: 1) {
                            ForEach (0..<7, id: \.self) { num in
//                                Text(String(num))
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: ((reader.size.width*0.7)-46)/7)
                                    .stroke(color: colorForIndex(phase.item.catIndex),width: 1)
                                
//                                    .frame(height: 30)
                                
//                                    .background(.gray)
//                                    .frame(width:30, height: 30)
                                //                        Ball (str: String (num) )
                                //                            .frame(height: 50)
                            }
//                            .padding()
                            
                            
                        }
                        
//                    }
                  
                    
//                }
                .frame(width: reader.size.width*0.7, height: 50, alignment: .leading)
//                .background(.red)
                
            }

        }
    }
}

    
    
struct TaskView: View {
    
    var items: [Item]
    
    var body: some View {
        
        
        NavigationView {
            
            List {
                Section {
                    ForEach(Array(items.enumerated()), id: \.element) { index, item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.system(size: 12))
                                .foregroundStyle(colorForIndex(item.catIndex))
                        
                            ForEach(Array(item.phases.enumerated()), id: \.element) { index, phase in
                                TaskRow(phase: item.phases[index])
//                                    .foregroundStyle(colorForIndex(item.catIndex))
                                    .frame(height: 50)
                                
                            }
                       
                  
                            
                            
                            //                                    PhaseRow(phase: phase)
                            //                                        .swipeActions(edge: .trailing) {
                            //
                            //                                            Button(role: .destructive) {
                            //                                                deletePhase(phase)
                            //
                            //                                            } label: {
                            //                                                Label("削除", systemImage: "trash")
                            //
                            //                                            }
                            //                                        }
                            //                                        .padding(.vertical, 4)
                        }
                    }
                    //                            .onMove(perform: move)
//                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    
                }
            }
            //                    .environment(\.editMode, .constant(.active))
            .listStyle(.plain)
            .padding(20)
            .environment(\.defaultMinListRowHeight, 30)
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                
                /// ナビゲーションバー右１
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                /// ナビゲーションバー左
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 0) {
                        Button(action: {
//                            addPhase(item: item)
                            
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    TaskView(items: [item_00, item_01, item_10])
}
