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

let limitItemsNum = 3

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
    
//    @State var screenShown = false
    
    @AppStorage(KeyString.moveLocked_item.rawValue) var moveLocked_item = false
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    
    func rectColor() -> Color {
        var col = Color.clear
        if item.continuing {
            col = colorForIndex(item.catIndex).opacity(0.5)
//        } else if item.stepNumber == 1 {
        } else if item.inImmersion != nil && item.inImmersion! {
            col = colorForIndex(item.catIndex)
        } else if item.stepNumber == 0 {
            col = colorForIndex(item.catIndex).opacity(0.05)
        } else {
            col = colorForIndex(item.catIndex).opacity(0.2)
        }
        return col
    }
    
    @State var showSheet = false
    
    var body: some View {
        
        ZStack {
            
            
            ZStack {
                
                if item.continuing {
                    VStack {
                    }
                    .frame(width: item.length, height: item.length, alignment: .center)
                    .background(
                        Image("pat_5").resizable(
                            resizingMode: .tile
                        )
                        .opacity(1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: continuingCornerRadius, style: .continuous))
                    .zIndex(10)
                }
                
                RoundedRectangle(cornerRadius: item.continuing ? continuingCornerRadius : 1)
                    .foregroundStyle(rectColor().opacity(1))
                    .blendMode(.multiply)
                    .frame(width: item.length, height: item.length, alignment: .center)
                    .shadow(color: item.continuing ?.white : .gray , radius: 3)
                    .zIndex(1)
                    .overlay {
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(Color("viewSelected_border"), lineWidth: isSelected ? 6 : 0)
                    }
                    .overlay {
//                        if item.stepNumber != 1 && !item.continuing {
                        if item.inImmersion == false && !item.continuing {
                            RoundedRectangle(cornerRadius: 1)
                                .stroke(colorForIndex(item.catIndex), style: StrokeStyle(lineWidth: item.stepNumber == 0 ? 1 : 2, dash: item.stepNumber != 0 || item.continuing ? [1, 0] : [8, 2]))
                        } else {
                            Rectangle().opacity(0)
                            
         
                    
                            
//                            if item.stepNumber != 1 && item.continuing {
//                                Rectangle().opacity(0)
//                            }
                     
                            
                            // 影画像
                        }
                    }
                
//                if item.stepNumber == 1 && !item.continuing {
                if item.inImmersion != nil && item.inImmersion! == true && !item.continuing {
                    Image("shadow")
                        .resizable()
                        .frame(width: (item.length+4)*1.14, height: (item.length+4)*1.12, alignment: .leading)
                    
                        .offset(x:(item.length+4)*0.12/2, y:(item.length+4)*0.12/2)
                }
//                    .zIndex(0)
            }

            // アイコン
            VStack {
                if item.continuing {
                    Image(systemName: "repeat")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 8)
                        .padding(.top, 3)
                        .foregroundColor(colorForIndex(item.catIndex))
                } else {
//                    if item.stepNumber == 1 {
                    if item.inImmersion != nil && item.inImmersion! == true {
                        Image(systemName: iconNames_1[icon_1])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                            .padding(.top, 3)
                            .foregroundColor(.white)
                    } else if item.stepNumber >= 1 {
                        Text(String(item.stepNumber))
                            .font(.system(size: 10))
                            .foregroundStyle(colorForIndex(item.catIndex).opacity(0.7))
                            .padding(.top, 2)
                            .bold()
                    }
                }
                
                Spacer()
                
                if item.phases.count > 0 {
                    Image(systemName: phaseImageName)
                        .resizable()
                        .frame(width: 10, height: 1.2)
                        .padding(.bottom, 5)
                        .foregroundColor(item.stepNumber == 1 ? .white : colorForIndex(item.catIndex))
                        .opacity(0.7)
                }
            }
            .frame(width: item.length, height: item.length)
            
            Text(item.title)
                .foregroundStyle((item.stepNumber == 1 && !item.continuing) ? .white : colorForIndex(item.catIndex))
                .font(.system(size: [item.length*0.25, 24.0].min()!)).bold(item.stepNumber == 1 || item.continuing)
                .minimumScaleFactor(0.1)
                .multilineTextAlignment(.center)
                .frame(width: item.length-10, height: item.length-10, alignment: .center)
                .stroke(color: .white, width: item.continuing || item.stepNumber >= 2 ? 1 : 0)
//                .shadow(color: .black.opacity(0.2) , radius: 1)
            
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
            if item.created {
                showSheet = true
            }
            
            if item.inImmersion == nil {
                item.inImmersion = false
            }
            
        }
        .onTapGesture {
            //            withAnimation {
            if isSelected {
                showSheet = true
            }
            
            
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
        .sheet(isPresented: $showSheet) {
            ItemDetailScreen(item: item)
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




let itemCount = 3

struct ItemDetailScreen: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query (
        sort: [
            SortDescriptor(\Step.index, order: .forward)
        ]
    ) var steps: [Step]
    
    
    @Query (
        sort: [
            SortDescriptor(\Category.index, order: .forward)
        ]
    ) var categories: [Category]
    
    
    @Query var items: [Item]
    @FocusState var isFocused
        
    @State private var vibrateOnRing = false
    
    var item : Item
    @State private var stepperValue = 0
    


    let str = "なし"

    
    private func addPhase(item: Item) {
        
        let p = Phase(item: item, index: item.phases.count, title: "", created: true, isDone: false)
        item.phases.append(p)
        modelContext.insert(p)
    }
    
    func deletePhase(_ phase: Phase) {
        if let index = item.phases.firstIndex(of: phase) {
            item.phases.remove(at: index)
        }
        
        withAnimation {
            modelContext.delete(phase)
        }

        let delay = 1.0 //遅延
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            updatePhaseIndex(item)
        }
    }
    
 
    
    func move(offset: IndexSet, index: Int) {
            var ary = sortedModels
            ary.move(fromOffsets: offset, toOffset: index)

        let delay = 0.5 //遅延
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation {
                updateArrayIndex(ary)
                item.phases = ary
                try! modelContext.save()
                
            }  
        }
    }
    
    
    func updatePhaseIndex(_ item: Item) {
        for i in 0..<item.phases.count {
            item.phases[i].index = i
        }
        try! modelContext.save()
    }
    
    func updateArrayIndex(_ ary: [Phase]) {
        for i in 0..<ary.count {
            ary[i].index = i
        }
    }
    
    var sortedModels: [Phase] {
         get {
             item.phases.sorted(by: { $0.index < $1.index })
         }
         set {
             item.phases = newValue
         }
     }
    
    
    @AppStorage(KeyString.numOfTodayItems.rawValue) var numOfTodayItems : Int = 2
    
    func calcNumOfItemsForStep(_ num: Int) -> Int {
        var count = 0
        for item in items {
            if item.stepNumber == num && item.continuing == false {
                count += 1
            }
        }
        return count
    }
    

    
    @State private var title = "View Title"
    @State var originalStepNumber : Int = 0

    
    let offsetY = -30
    

    // 残り日数
    func lastDateStr() -> String {
        if item.stepNumber == 0 {
            return "ー"
        } else {
            let step = steps[item.stepNumber-1]
            //        return dateToString(date: step.date)
            
            return spanStr(from: zeroDate(Date()), to: zeroDate(step.date))
        }
        

    }
        
    // 期限日
    func calcLimetStr() -> String {
        if item.stepNumber == 0 {
            return "ー"
        } else {
            let step = steps[item.stepNumber-1]
            return dateToString(date: step.date)
        }
    }
    
    let labelFontSize : CGFloat = 12
    let labelFontColor : Color = .gray
    
    @State var showGoalCountAlert = false
    @State var originalGoalCount = 0
    
    @State var showAlert = false
    @AppStorage(KeyString.countUpdateDateStr.rawValue) var countUpdateDateStr = ""
    
    @State var isSound = true
    
    var body: some View {
        
        GeometryReader { g in
            
            
            NavigationView {
                VStack(spacing: 0) {
                    
                    //                    if !item.continuing {
                    VStack(spacing: 10) {
                        TextField("タイトル入力", text: Binding(get: {
                            item.title
                        }, set: { (newVal) in
                            item.title = newVal
                        }))
                        .frame(width: g.size.width)
         
                        .font(.title)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .offset(CGSize(width: 0, height: 15))
                      
                        .focused($isFocused)
                        .zIndex(10)
                        .onSubmit {
                            isFocused = false
                        }
            
                        ZStack(alignment: .top) {
                            
                            HStack(alignment: .top)  {
                                
                                // 左
                                VStack(alignment: .leading) {
                                    
                                    Text("期限")
                                        .font(.system(size: labelFontSize))
                                        .foregroundStyle(labelFontColor)
                                    Text(calcLimetStr())
                                    Text("残り")
                                        .font(.system(size: labelFontSize))
                                        .foregroundStyle(labelFontColor)
                                    Text(lastDateStr())
                                        .foregroundStyle(.green)
                                        .bold()
                                }
                                
                                Spacer()
                                
                                
                                
                                
                                // 右
                                VStack(alignment: .leading) {
                                    Text("目標数")
                                        .font(.system(size: labelFontSize))
                                        .foregroundStyle(labelFontColor)
                                    Button(String(item.goalCount ?? 100)) {
                                        showGoalCountAlert = true
                                    }
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(.blue.opacity(0.2))
                                    .cornerRadius(3)
                                    
                                    .onAppear {
                                        if item.goalCount == nil {
                                            item.goalCount = 100
                                        }
                                        originalGoalCount = item.goalCount!
                                    }
                                    
                                    .alert("目標数を設定",isPresented: $showGoalCountAlert) {
                                        TextField("目標数", text: Binding(get: {
                                            withAnimation {
                                                String(item.goalCount ?? 100)
                                            }
                                        }, set: { (newVal) in
                                            //
                                            
                                            
                                            withAnimation {
                                                if let c = Int(newVal) {
                                                    item.goalCount = c
                                                    
                                                } else {
                                                    //
                                                }
                                                
                                            }
                                        }))
                                        .keyboardType(.numberPad)
                                        
                                        
                                        Button("保存", role: .cancel, action: {
                                            originalGoalCount = item.goalCount!
                                        })
                                        Button("キャンセル", role: .none, action: {
                                            item.goalCount = originalGoalCount
                                        })
                                        
                                    }
                                    Text("達成")
                                        .font(.system(size: labelFontSize))
                                        .foregroundStyle(labelFontColor)
                                    
                                    
                                    //                                            Text("\(item.count ?? 0)")
                                    
                                    VStack(alignment: .trailing) {
                                        Button(action: {
                                            showAlert = true
                                        }, label: {
                                            Text("\(item.count ?? 0)")
                                                .foregroundStyle(.blue)
                                                .bold(item.todayCount ?? 0 >= calcTodayGoal(item: item, steps: steps))
                                            //                                                    VStack(alignment: .trailing, spacing: 0) {
                                            
                                            
                                            
                                            
                                        })
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(.blue.opacity(0.2))
                                        .cornerRadius(3)
                                        
                                        .alert("達成数", isPresented: $showAlert) {
                                            
                                            Button("カウントアップ", role: .none) {
                                                withAnimation {
                                                    if item.count == nil {
                                                        item.count = 0
                                                    }
                                                    
                                                    item.count? += 1
                                                    
                                                    if item.todayCount == nil {
                                                        item.todayCount = 0
                                                    }
                                                    
                                                    vivrate()
                                                    
                                                    
                                                    // 日付が変わったかチェック
                                                    if countUpdateDateStr != dateToString(date: Date(), format: dateFormatStr) {
                                                        resetItemsCount(items: [item])
                                                    }
                                                    
                                                    item.todayCount? += 1
                                                    saveCountUpdateDateStr()
                                                }
                                            }
                                            
                                            Button("カウントダウン", role: .none) {
                                                withAnimation {
                                                    if item.count == nil {
                                                        item.count = 0
                                                    }
                                                    
                                                    item.count? -= 1
                                                    
                                                    if item.count != nil && item.count! < 0 {
                                                        item.count? = 0
                                                    }
                                                    
                                                    if item.todayCount == nil {
                                                        item.todayCount = 0
                                                    }
                                                    
                                                    // 日付が変わったかチェック
                                                    if countUpdateDateStr != dateToString(date: Date(), format: dateFormatStr) {
                                                        resetItemsCount(items: [item])
                                                    }
                                                    item.todayCount? -= 1
                                                    saveCountUpdateDateStr()
                                                    
                                                    if item.todayCount != nil && item.todayCount! < 0 {
                                                        item.todayCount? = 0
                                                    }
                                                }
                                            }
                                            
                                            if item.count ?? 0 > 0 {
                                                Button("リセット", role: .destructive) {
                                                    withAnimation {
                                                        item.count? = 0
                                                        item.todayCount? = 0
                                                    }
                                                }
                                            }
                                            
                                            Button("キャンセル", role: .cancel) {
                                                withAnimation {
                                                    showAlert = false
                                                }
                                            }
                                            
                                            
                                        }
                                        Spacer()
                                    }
                                    
                                    Text("今日")
                                        .font(.system(size: labelFontSize))
                                        .foregroundStyle(labelFontColor)
                                    Text("\(item.todayCount ?? 0) / \(calcTodayGoal(item: item, steps: steps))")
                                        .foregroundStyle(item.todayCount ?? 0 >= calcTodayGoal(item: item, steps: steps) ? .green : .black)
                                        .bold(item.todayCount ?? 0 >= calcTodayGoal(item: item, steps: steps))
                                    
                                    
                                }
                                
                                
                                
                            }
                            .offset(CGSize(width: 0, height: 20))
                            .padding(.horizontal, 10)
                            
                            
                            VStack() {
                                
                                // カテゴリー
                                Menu {
                                    ForEach(Array(categories.enumerated()), id: \.element) { index, cat in
                                        
                                        Button(action: {
                                            
                                            withAnimation{
                                                
                                                if let index0 = categories[item.catIndex].items.firstIndex(of: item) {
                                                    categories[item.catIndex].items.remove(at: index0)
                                                }
                                                
                                                if let index1 = categories.firstIndex(of: cat) {
                                                    item.catIndex = index1
                                                    categories[item.catIndex].items.append(item)
                                                }
                                                
                                            }
                                            
                                        }) {
                                            HStack {
                                                if index == item.catIndex {
                                                    Image(systemName: "checkmark")
                                                }
                                                Text(cat.title)
                                                    .foregroundColor(colorForIndex(cat.index))
                                            }
                                        }
                                        //                                    .padding()
                                        
                                        
                                    }
                                } label: {
                                    Label(categories[item.catIndex].title, systemImage: "folder")
                                }
                                .offset(CGSize(width: 0, height: 10))
                                .padding(.bottom, 20)
                                
                                
                                
                                // 没入
                                if !item.continuing {
                                    HStack(spacing: 10) {
                                        Text("没入")
                                            .bold()
                                        
                                        Toggle(isOn: Binding(get: {
                                            withAnimation {
                                                item.inImmersion ?? false
                                            }
                                        }, set: { (newVal) in
                                            withAnimation {
                                                item.inImmersion = newVal
                                            }
                                        })
                                        ) {
                                            
                                            
                                        }
                                        .fixedSize()
                                    }
                                    
                                }
                                
                                if item.inImmersion != nil && item.inImmersion! == false {
                                    // 継続
                                    HStack(spacing: 10) {
                                        Text("継続")
                                        
                                        Toggle(isOn: Binding(get: {
                                            withAnimation {
                                                item.continuing
                                            }
                                        }, set: { (newVal) in
                                            withAnimation {
                                                item.continuing = newVal
                                            }
                                        })
                                        ) {
                                            
                                            
                                        }
                                        .fixedSize()
                                    }
                                    
                                }
                            }
                        }
                        .frame(width: g.size.width)
                        //                                .offset(CGSize(width: 0, height: offsetY))
                        
                        .padding(0)
                        //                                .background(.red)
                        //                            }
                        
                        
                        
                        
                        
                        if !item.continuing {
                            //                                HStack {
                            //                                    Text("ステップ：" )
                            //                                    Text((item.stepNumber == 0 ? str : item.stepNumber == 1 ? "Today" : "\(item.stepNumber)"))
                            //                                        .bold()
                            //                                        .foregroundColor(item.stepNumber == 1 ? .blue : .black)
                            //                                        .backgroundStyle(.red)
                            //                                }
                            //
                            
                            Text("ステップ")
                                .font(.system(size: 12))
                                .padding(0)
                            
                            ScrollView(.horizontal) {
                                
                                Picker("", selection: Binding(get: {
                                    item.stepNumber
                                }, set: { (newVal) in
                                    
                                    item.stepNumber = newVal
                                })) {
                                    Text("なし")
                                        .tag(0)
                                    
                                    //                                        if numOfTodayItems < limitItemsNum || originalStepNumber == 1 {
                                    //                                            Text("没入")
                                    //                                                .tag(1)
                                    //                                                .tint(.red)
                                    //                                        }
                                    
                                    ForEach(steps) { step in
                                        //                                            if step.index >= 1 {
                                        if calcNumOfItemsForStep(step.index+1) < limitItemsNum || item.stepNumber == step.index+1 {
                                            Text(String(step.index+1))
                                                .tag(step.index+1)
                                        }
                                        
                                        //                                            }
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal, 10)
                                .frame(width: g.size.width)
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    .fixedSize()
                    .labelsHidden()
                    
                    //                    }
                    
                    //                    Toggle(
                    //                        "継続",
                    //                        systemImage: "repeat",
                    //                        isOn: Binding(get: {
                    //                            withAnimation {
                    //                                item.continuing
                    //                            }
                    //                        }, set: { (newVal) in
                    //                            withAnimation {
                    //                                item.continuing = newVal
                    //                            }
                    //                        })
                    //                    )
                    //                    .frame(width: 150)
                    //                    .padding(.horizontal, 20)
                    //                    .padding(.vertical, 30)
                    
                    Text("行動の展開・要素・ポテンシャル")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .padding(.top, 15)
                    
                    List {
                        Section {
                            
                            
                            ForEach(sortedModels) { phase in
                                VStack(alignment: .leading) {
                                    PhaseRow(phase: phase)
                                        .swipeActions(edge: .trailing) {
                                            
                                            Button(role: .destructive) {
                                                deletePhase(phase)
                                                
                                            } label: {
                                                Label("削除", systemImage: "trash")
                                                
                                            }
                                        }
                                        .padding(.vertical, 4)
                                }
                            }
                            .onMove(perform: move)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            
                        }
                    }
                    //                    .environment(\.editMode, .constant(.active))
                    .listStyle(.plain)
                    .environment(\.defaultMinListRowHeight, 30)
                }
                //            .navigationTitle($item.title)
                //            .navigationTitle(Binding(get: {
                //                item.title
                //            }, set: { (newVal) in
                //                item.title = newVal
                //            }))
//                .frame(maxWidth: .infinity)
//                .navigationBarTitleDisplayMode(.inline)
                .offset(CGSize(width: 0, height: offsetY))
                .toolbar {
                    
                    /// ナビゲーションバー右１
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    /// ナビゲーションバー左
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 0) {
                            Button(action: {
                                addPhase(item: item)
                                
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
//            .frame(maxWidth: .infinity)
            .onDisappear {
                numOfTodayItems = calcNumOfItemsForStep(1)
                
                //            item.hasPhase = !(filteredPhases().count == 0)
                //            if originalStepNumber == 1 && item.stepNumber != 1 {
                //                numOfTodayItems -= 1
                //            }
                
                //            if originalStepNumber != 1 && item.stepNumber == 1 {
                //                numOfTodayItems += 1
                //            }
            }
            .onAppear {
//                print(item.title)
                
                
                if item.inImmersion != nil && item.inImmersion! == true {
                    item.continuing = false
                }
                
                if item.inImmersion == nil {
                    item.inImmersion = false
                    item.continuing = false
                }
                
                
                if item.count == nil {
                    item.count = 0
                }
                
                isFocused = item.created
                item.created = false
                originalStepNumber = item.stepNumber
                
                // 日付が変わったかチェック
                if countUpdateDateStr != dateToString(date: Date(), format: dateFormatStr) {
                    resetItemsCount(items: [item])
                }
                
//                for i in 0..<sortedModels.count {
//                    let p = sortedModels[i]
//                
//                
//                }
                
//                originalCatIndex = item.catIndex
                
                //            selectedPicker = item.stepNumber
            }
            
        }
        

        
    }
    
}


/* ----------------------------------------------------------------------------
 MARK: - Phase
 ------------------------------------------------------------------------------*/

//@Model
//class Phase {
//    var item : Item
//    var index : Int
//    var title : String
//    var created : Bool
//    
//    
//    init(item: Item, index: Int, title: String, created: Bool = false) {
//        self.item = item
//        self.index = index
//        self.title = title
//        self.created = created
//    }
//
//}



struct PhaseRow : View {
    

    
    var phase : Phase
    
    
    
    @FocusState var focused
    
//    @State var isDone = false
    
    var body: some View {
        HStack(spacing: 10) {
            
            Image(systemName: phase.isDone != nil && phase.isDone! ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(colorForIndex(phase.item.catIndex))
                .onTapGesture {
                    phase.isDone!.toggle()
                }
       
            
//            
//            Button(action: {
//                if phase.isDone == nil {
//                    phase.isDone = true
//                } else {
//                    phase.isDone!.toggle()
//                }
//            }) {
//                if phase.isDone != nil && phase.isDone! {
//                    Image(systemName: "checkmark.square")
//                        .resizable()
//                        .foregroundColor(.gray)
//             
//                    
//                } else {
//                    Image(systemName: "square")
//                        .resizable()
//                        .foregroundColor(colors[phase.item.catIndex])
//                }
//                    
//            }
         
            
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 40, height: 40)
                .foregroundStyle(colorForIndex(phase.item.catIndex))
//                .opacity(phase.isDone != nil && phase.isDone! ? 0.3 : 1.0)
                .overlay {
                    Text(String(phase.index+1))
                        .foregroundStyle(.white)
                }

            TextField("タイトル入力", text: Binding(get: {
                phase.title
            }, set: { (newVal) in
                phase.title = newVal
            }))
            .strikethrough(phase.isDone != nil && phase.isDone!)
            .focused($focused)
            .onSubmit {
                phase.created = false
            }
//            .background(.red)
//            .padding(.vertical, 10)
            
//            Spacer()
        }
        .padding(.horizontal, 10)
        .onAppear {
//            withAnimation {
                focused = phase.created
//            }
        }
        .opacity(phase.isDone != nil && phase.isDone! ? 0.3 : 1.0)
        
    }

}






