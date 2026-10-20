//
//  ItemView.swift
//  Immersion
//
//  Created by forest on 2024/01/22.
//

import SwiftUI
import SwiftData

/* ----------------------------------------------------------------------------
 MARK: - Item
 ------------------------------------------------------------------------------*/

struct ItemView: View {
//    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var setData : ShareData
//    @Query private var items: [Item]
    
//    @Environment(\.dismiss) var dismiss
    
    static func == (lhs: ItemView, rhs: ItemView) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    
    @State var item : Item
    @State var posDiff = CGPoint.zero
    @State var dragStart = false
    @State var showDetail = false

    @State var isSelected = false
    var asDetail = false
    
    @Binding var showMenu : Bool
    @Binding var showMenu_forItem : Bool
    
    @FocusState var isFocused: Bool   // ①
    
    @State var screenShown = false
    
    @AppStorage(KeyString.moveLocked_item.rawValue) var moveLocked_item = false
    
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    
//    @EnvironmentObject var viewModel: WatchConnectViewModel
    
    
    
//    func deleteItem() {
//        let cat = categoryData.categories[item.catIndex]
//        if let index = cat.items.data.firstIndex(of: item) {
//            cat.items.data.remove(at: index)
//            isSelected = false
//            showMenu_forItem = false
//            setData.setData.selectedCatView = nil
//        }
//    }
    
   
    var rectColor : Color {
        if item.continuing {
            colors[item.catIndex].opacity(0.7)
        } else if item.stepNumber == 1{
            colors[item.catIndex]
        } else {
            colors[item.catIndex].opacity(0.1)
        }
        
//        item.stepNumber == 1 ? colors[item.catIndex] : colors[item.catIndex].opacity(0.1)
    }
  
    
    var body: some View {
        
        ZStack {
            
            
            ZStack {
                
                if item.continuing {
                    VStack {
                    }
                    .frame(width: item.length, height: item.length, alignment: .center)
//                    .background(.red)
                    .background(
                        Image("pat_5").resizable(
                            resizingMode: .tile
                        )
                        .opacity(0.7)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    .position(CGPoint(x: item.posX, y: item.posY))
//                    .position(CGPoint(x: item.length/2, y: item.length/2))
//                    .position(CGPoint(x: self., y: 0))
                    .zIndex(1)
                    
                }
         
            
                RoundedRectangle(cornerRadius: item.continuing ? 10 : 1)
                //                .foregroundColor(colors[item.catIndex])
                //                .foregroundColor(item.stepNumber == 1 ? colors[item.catIndex] : colors[item.catIndex].opacity(0.1))
//                    .foregroundColor(rectColor)
                    .foregroundStyle(rectColor.opacity(1))
                    .blendMode(.multiply)
                    .frame(width: item.length, height: item.length, alignment: .center)
                    .shadow(color: item.continuing ?.white : .gray , radius: 3)
                    .overlay {
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(Color("viewSelected_border"), lineWidth: isSelected ? 6 : 0)
                    }
                    .overlay {
                        if item.stepNumber != 1 && !item.continuing {
                            
                            
                            RoundedRectangle(cornerRadius: 1)
                                .stroke(colors[item.catIndex], style: StrokeStyle(lineWidth: 1, dash: item.stepNumber == 1 || item.continuing ? [1, 0] : [8, 2]))
                        }
                    }
                
                
                
            }
            
            

            
            
    
                VStack { 
                    
                    if item.continuing {
                        Image(systemName: "repeat")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 8)
                            .padding(.top, 3)
                            .foregroundColor(.white)
                    } else {
                        if item.stepNumber == 1 {
                            Image(systemName: iconNames_1[icon_1])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 12)
                                .padding(.top, 3)
                                .foregroundColor(.white)
                        } else if item.stepNumber > 1 {
                            Text(String(item.stepNumber))
                                .font(.system(size: 8))
                                .foregroundStyle(colors[item.catIndex].opacity(0.7))
                                .padding(.top, 2)
                            
                        }
                    }
                    
                   
                    
                    Spacer()
                    
                    if item.hasPhase {
                        Image(systemName: phaseImageName)
                            .resizable()
//                            .scaledToFit()
                            .frame(width: 10, height: 1.2)
                            .padding(.bottom, 5)
                            .foregroundColor(item.stepNumber == 1 ? .white : colors[item.catIndex])
                            .opacity(0.7)
                    }
                }
                .frame(width: item.length, height: item.length)
            
            
//            TextEditor(text: $item.title)
            TextField("タイトル入力", text: $item.title, axis: .vertical)
                .lineLimit(3)
                .font(.system(size: [item.length*0.25, 24.0].min()!)).bold(item.stepNumber == 1)
                .minimumScaleFactor(0.1)
                .multilineTextAlignment(.center)
                .foregroundStyle(item.stepNumber == 1 || item.continuing ? .white : colors[item.catIndex])
                .padding(4)
                .frame(width: item.length, height: item.length, alignment: .center)
                .focused($isFocused)
                .disabled(!isSelected)
                .onAppear {
                    isFocused = item.created
                    isSelected = item.created
                    setData.selectedItemView = self
                }
                .onSubmit {
                    item.created = false
                    isSelected = false
                    setData.selectedItemView = nil
                    isFocused = false
//                    viewModel.updateApplicationContext(fruit: fetchTodayItems())
                }
                
            
            
            if item.isDone {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: item.length*0.7, height: item.length*0.7, alignment: .center)
                    .foregroundColor(.white.opacity(0.6))
                    .zIndex(10)
            }
                
        }
        .position(asDetail ? CGPoint(x: item.posX/scaleK, y: item.posY/scaleK) : CGPoint(x: item.posX, y: item.posY))
//        .opacity(item.stepNumber == 1 ? 1 : 0.7)
        .zIndex(100)
        .gesture(drag)
        .onAppear {

        }
        .onTapGesture {
//            withAnimation {
            
            if setData.selectedItemView != nil {
                setData.selectedItemView.isSelected = false
            }
                        
            isSelected = true
            setData.selectedItemView = self
            
            //                if selectedItemView != nil {
            if setData.selectedCatView != nil {
                setData.selectedCatView.isSelected = false
                setData.selectedItemView.item.created = false
                setData.selectedCatView = nil
            }
            
            showMenu = false
            showMenu_forItem = true
            
            


        }
        
        
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                if !moveLocked_item {
                    if !dragStart {
                        posDiff = CGPoint(x: value.startLocation.x - item.posX , y: value.startLocation.y - item.posY)
                        dragStart = true
                    }
                    
                    item.posX =
                    value.startLocation.x
                    + value.translation.width
                    - posDiff.x
                    
                    item.posY =
                    value.startLocation.y
                    + value.translation.height
                    - posDiff.y
                    
                }
            }
            .onEnded { value in
                
                if !moveLocked_item {
                    item.posX =
                    value.startLocation.x
                    + value.translation.width
                    - posDiff.x
                    
                    item.posY =
                    value.startLocation.y
                    + value.translation.height
                    - posDiff.y
                    
                    dragStart = false
                }

            }
    }
    
    
    
}

//#Preview {
//    ItemView(item: Item(), showMenu_forItem: Binding.constant(false))
//}


//class Items : ObservableObject {
//    
//    @Published var data = [Item]()
//    
//
//}

@Model
class Item : Identifiable {


    let id = UUID()
    var title: String
    var posX : CGFloat
    var posY : CGFloat
    var length: CGFloat
    var catIndex: Int
    var stepNumber: Int // 0:Stepに属さない
    var dislike : Bool
    var created : Bool
    var isDone : Bool
    var hasPhase : Bool
    var continuing : Bool


    
    init(title: String = "", posX: CGFloat = 0, posY: CGFloat = 0, length: CGFloat = 50, catIndex: Int, stepNumber: Int = 0, dislike: Bool = false, focused: Bool = false, isDone: Bool = false, hasPhase : Bool = false, continuing : Bool = false) {
        self.title = title
        self.posX = posX
        self.posY = posY
        self.length = length
        self.catIndex = catIndex
        self.stepNumber = stepNumber
        self.dislike = dislike
        self.created = focused
        self.isDone = isDone
        self.hasPhase = hasPhase
        self.continuing = continuing
    }
    
}



let itemCount = 3

struct ItemDetailScreen: View {
    
    @Environment(\.modelContext) private var modelContext
    

    
    @Query (
        sort: [
            SortDescriptor(\Phase.index, order: .forward)
        ]
    ) var phases: [Phase]
    
    func filteredPhases() -> [Phase] {
        return phases.compactMap { pahse in
            return pahse.item == self.item ? pahse : nil
        }
    }
    
    private func addPhase(item: Item) {
        withAnimation{
            let p = Phase(item: item, index: filteredPhases().count, title: "タイトル", created: true)
            modelContext.insert(p)
        }
    }
    
    func editPhase() {
        print("editPhase")
        
    }
    
    func deletePhase(_ phase: Phase) {
        withAnimation {
            modelContext.delete(phase)
            try! modelContext.save()
        }
        
    }
    
 
    
    func move(offset: IndexSet, index: Int) {
        withAnimation{
        var ary = filteredPhases()

            ary.move(fromOffsets: offset, toOffset: index)


        
        for i in 0..<ary.count {
            let p = ary[i]
            p.index = i
        }
        try! modelContext.save()
        }
    }
    
    @State private var vibrateOnRing = false
    
    var item : Item
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                
//                Toggle(isOn: $vibrateOnRing) {
//                    Text("Vibrate on Ring")
//                }
//                
              
//
                
                Toggle(
                    "継続",
                    systemImage: "repeat",
                    isOn: Binding(get: {
                        item.continuing
                        
                    }, set: { (newVal) in
                        item.continuing = newVal
                    })
                )
                
                .frame(width: 150)
                .padding(.horizontal, 20)
                .padding(.vertical, 30)

                Text("行動の展開・ポテンシャル")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                
                List {
                    Section {
                        ForEach(filteredPhases()) { phase in
                            VStack(alignment: .leading) {
                                PhaseRow(phase: phase)
                                    .swipeActions(edge: .trailing) {
                                        
                                        Button(role: .destructive) {
                                            deletePhase(phase)
                                            
                                        } label: {
                                            Label("削除", systemImage: "trash")
                                            
                                        }
                                    }
                                    .padding(.vertical, 7)
//
//                                Image(systemName: "arrow.down")
//                                    .padding(.leading, 38)
//                                    .padding(.top, 1)
//                                    .padding(.bottom, 10)
//                                    .foregroundStyle(colors[phase.item.catIndex])
                            }
                        }
                        .onMove(perform: move)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

//                        .onDelete {
//                            
//                        }
                        
                        
                        
                    }
                  
            
                    
                    
                }
             
                
                
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 30)
                

                
                
                
                
                
            }
            .navigationTitle(item.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                /// ナビゲーションバー左
                ToolbarItem(placement: .navigationBarLeading){
                    HStack(spacing: 0) {
                        Button(action: {
                            addPhase(item: item)

                        }) {
                            Image(systemName: "plus")
                        }

                        
                    }
                    
                    
                }
                
                /// ナビゲーションバー右１
                ToolbarItem(placement: .navigationBarTrailing){
                    EditButton()
                    
//                    HStack(spacing: 0) {
//
//                        Button(action: {
//                            withAnimation {
//                                editPhase()
//
//                                
//                                
//                            }
//
//                        }) {
//                            Text("編集")
////                            Image(systemName: "edit")
//                        }
//                    }
                    
                }
                
            }
            
            
        }
        .onDisappear{
            item.hasPhase = !(filteredPhases().count == 0)
        }
    

        
    }
    
}


/* ----------------------------------------------------------------------------
 MARK: - Phase
 ------------------------------------------------------------------------------*/

@Model
class Phase {
    var item : Item
    var index : Int
    var title : String
    var created : Bool
    
    
    init(item: Item, index: Int, title: String, created: Bool = false) {
        self.item = item
        self.index = index
        self.title = title
        self.created = created
    }
    

    
}



struct PhaseRow : View {
    
    var phase : Phase
    
    @FocusState var focused
    
    var body: some View {
        HStack(spacing: 10) {
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 50, height: 50)
                .foregroundStyle(colors[phase.item.catIndex])
                .overlay {
                    Text(String(phase.index+1))
                        .foregroundStyle(.white)
                }

            TextField("タイトル入力", text: Binding(get: {
                phase.title
            }, set: { (newVal) in
                phase.title = newVal
            }))
            .focused($focused)
            .onSubmit {
                phase.created = false
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear {
            withAnimation {
                focused = phase.created
            }
        }
        
    }

}






