//
//  Step.swift
//  Immersion
//
//  Created by forest on 2024/01/28.
//

import SwiftUI
import SwiftData

struct BlinkEffect: ViewModifier {
    @State var isOn: Bool = false
    let opacityRange: ClosedRange<Double>
    let interval: Double
    
    init(opacity: ClosedRange<Double>, interval: Double) {
        self.opacityRange = opacity
        self.interval = interval
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(self.isOn ? self.opacityRange.lowerBound : self.opacityRange.upperBound)
//            .animation(Animation.linear(duration: self.interval).repeatForever())
//            .animation(.linear(duration: self.interval).repeatForever(), value: opacity)
            
            .onAppear(perform: {
                self.isOn = true
            })
    }
}

extension View {
    func blinkEffect(opacity: ClosedRange<Double> = 0.1...1, interval: Double = 0.6, enabled: Bool) -> some View {
        if enabled {
            self.modifier(BlinkEffect(opacity: opacity, interval: interval))
        } else {
            self.modifier(BlinkEffect(opacity: 1...1, interval: interval))
        }
    }
}


let continuingCornerRadius : CGFloat = 14

struct StepsScreen : View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var setData : ShareData
    
    @Query var categories : [Category]
    @Query var items : [Item]
    
    @Query (
        sort: [
            SortDescriptor(\Step.index, order: .forward)
        ]
    ) var steps: [Step]
    
    func sortedModels_() -> [Step] {
        return steps.sorted(by: { $0.index < $1.index })
     }
    
    var forAddItem : Bool
    
    func addStep() {
        let item = Step(index: steps.count, date: prevNewDate(), span: Date())
        modelContext.insert(item)
    }
    
    func prevNewDate() -> Date {
        
        let lastStep = steps.last
        let date = Calendar.current.date(byAdding: .month, value: 3, to: lastStep?.date ?? Date())!
        return date
    }
    
    func makeDefaultSteps() {
        let ary = [
            Step(index: 0, date: Date(), span: Date()),
            Step(index: 1, date: Date(), span: Date()),
            Step(index: 2, date: Date(), span: Date()),
            Step(index: 3, date: Date(), span: Date()),
            Step(index: 4, date: Date(), span: Date()),
            Step(index: 5, date: Date(), span: Date()),
        ]
        
        for i in 0..<ary.count {
            let item = ary[i]
            modelContext.insert(item)
        }
    }
    
    func filteredItems() -> [Item] {
        return items.compactMap { item in
            return item.continuing == true ? item : nil
        }
    }

    
    @State var continuingItems : [Item] = []
    
    func checkInvalidItems() {
        for i in 0..<continuingItems.count {
            let item = continuingItems[i]
            if item.catIndex >= categories.count {
                continuingItems.remove(at: i)
                modelContext.delete(item)
            }
        }
    }

    
    let grids = [GridItem(.fixed(50), spacing: 10, alignment: .center)]
    
    
    func deleteStep(_ step: Step) {
        resetItemsStep(step.index)
        modelContext.delete(step)
        updateStepsIndex()
    }
    
    func resetItemsStep(_ stepIndex: Int) {
        for i in 0..<items.count {
            let item = items[i]
            if item.stepNumber == stepIndex+1 {
                item.stepNumber = 0
            }
        }
    }
    
    func updateStepsIndex() {
        for i in 0..<steps.count {
            steps[i].index = i
        }
        try! modelContext.save()
    }
        
    @AppStorage(KeyString.stepScreenB.rawValue) var stepScreenB : Bool = false
    
    @State var showSheet = false
    @State var itemForEdit : Item? = nil
    
    var body: some View {
        NavigationView {
            
            if stepScreenB {
                VStack(spacing: 0) {
                    
                    CaptionView(str: "結局今何に集中すべきか？最優先事項を選択しよう")
                    
                    Spacer(minLength: 2)
                    
                    List {
                        
                        ForEach(Array(steps.enumerated()), id: \.element) { index, step in
                            if index == 0 {
                                StepRow(prevStepDate: nil, step: step, forAddItem: forAddItem)
                                
                            } else {
                                StepRow(prevStepDate: steps[index-1].date ,step: step, forAddItem: forAddItem)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            deleteStep(step)
                                        } label: {
                                            Label("削除", systemImage: "trash")
                                        }
                                    }
                                    .padding(.vertical, 4)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 3, trailing: 0))
                        
                    }
                    .padding(.horizontal ,2)
                    .padding(.vertical ,0)
                    .listStyle(.plain)
                    .navigationTitle(forAddItem ? "アイテムをステップに追加" : screenTitles[2])
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        
                        // ナビゲーションバー
                        ToolbarItem(placement: .navigationBarTrailing){
                            HStack(spacing: 0) {
                                
                                Button {
                                    withAnimation {
                                        addStep()
                                    }
                                } label: {
                                    Image(systemName: "text.badge.plus")
                                }
                                .disabled(steps.count >= 10)
                            }
                        }
                        
                        // ナビゲーションバー
                        ToolbarItem(placement: .navigationBarLeading){
                            HStack(spacing: 0) {
                                
                                Button {
                                    withAnimation {
                                        stepScreenB.toggle()
                                    }
                                } label: {
                                    Text("フロー表示")
                                }
                            }
                        }
                    }
                    
                    // 継続して行う
                    VStack(alignment: .center, spacing: 3) {
                        
                        HStack(spacing: 3) {
                            Image(systemName: "repeat")
                                .foregroundStyle(Color("continuing_rect"))
                            Text("継続して行う")
                                .foregroundStyle(Color("continuing_rect"))
                                .bold()
                        }
                        
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: grids, spacing: 7) {
                                ForEach(continuingItems) { item in
//                                ForEach(Array(continuingItems.enumerated()), id: \.element) { index, item in
                                    
                                    ZStack {
                                        VStack {
                                        }
                                        .frame(width: 50, height: 50)
                               
                                        
                                        .background(
                                            Image("pat_5").resizable(
                                                resizingMode: .tile
                                            )
                                            .opacity(1)
                                        )
                                
                                     
                                        
                                        .clipShape(RoundedRectangle(cornerRadius: continuingCornerRadius, style: .continuous))
//                                        .position(CGPoint(x: 50/2, y: 50/2))
                                        .zIndex(1)
                           
                                            
                                            
                                            
                               
                                        
                                        .overlay {
                                            Text(item.title)
                                                .foregroundStyle(colorForIndex(item.catIndex))
                                                .font(Font.system(size: 14))
                                                .minimumScaleFactor(0.1)
                                                .padding(3)
                                                .bold()
                                                .shadow(color: .black.opacity(0.2) , radius: 1)
                                                .stroke(color: .white, width: 0.5)
                                            
                                             
                                        
                                        }
                                        
                                        RoundedRectangle(cornerRadius: continuingCornerRadius)
                                            .frame(width: 50)
                                            .foregroundStyle(colorForIndex(item.catIndex).opacity(0.3))
                                        //                                        .blendMode(.overlay)
                                            .blendMode(.multiply)
                                    
                                   
                                         
                                    }
                                    
                                    .onTapGesture {
//                                        if item != nil {
                                            
                                            
//                                            showSheet = true
                                            
//                                        }
                                    }
//                                    .sheet(isPresented: $showSheet) {
//                                        ItemDetailScreen(item: item)
//                                     
//                                    }
                                    
                                    
//                                    .onTapGesture {
//                                        showItemDetailScreen = true
//                                        print(item.title)
//                                        itemForEdit = item
//                                    }
//                                    
//                                    .sheet(isPresented: $showItemDetailScreen) {
//                                        //                                        print(item.title)
//                                        //                                        print(item.catIndex)
//                                        ItemDetailScreen(item: itemForEdit!)
//                                        
//                                    }
                               
                              
                          
                               
                                  

                                }
                            }
                        }
//                        .onChange(of: continuingItems) { //newValue in
////                            continuingItems
//                            
//                            print("newValue = [\(continuingItems)]")
//                        }
                        .frame(height: 55)
                        .padding(5)
                        .background(Color("continuing_rect").opacity(0.1))
                        .border(Color("continuing_rect"), width: 2)
                        
                    }
                    .padding(.horizontal, 5)
                    
                }
            } else {
//                StepScreenB()
                FlowScreen()
                    .toolbar {
                        
                        // ナビゲーションバー右
//                        ToolbarItem(placement: .navigationBarTrailing){
//                            HStack(spacing: 0) {
//                                
//                                Button {
//                                    withAnimation {
//                                        addStep()
//                                    }
//                                } label: {
//                                    Image(systemName: "text.badge.plus")
//                                }
//                                .disabled(steps.count >= 10)
//                            }
//                        }
                        
                        // ナビゲーションバー右
                        ToolbarItem(placement: .navigationBarLeading){
                            HStack(spacing: 0) {
                                
                                Button {
                                    withAnimation {
                                        //                                    addStep()
                                        stepScreenB.toggle()
                                    }
                                } label: {
                                    Text("ステップ表示")
                                    //                                Image(systemName: "text.badge.plus")
                                }
                                //                            .disabled(steps.count >= 10)
                            }
                        }
                        
                        
                    }
                    .listStyle(.plain)
                    .navigationTitle("フロー")
                    .navigationBarTitleDisplayMode(.inline)
                
                
            }
            
      

        }
 
        .onAppear {
            continuingItems = filteredItems()
            checkInvalidItems()
        }
        .onDisappear {
            if setData.selectedItemView != nil {
                withAnimation {
                    setData.selectedItemView.isSelected = false
                    setData.selectedItemView = nil
                }
          
            }
        }
    }
}




    
//#Preview {
//    StepsScreen()
//}





struct StepRow : View {
    
//    @Query var steps: [Step]
    
//    @Query (
//        sort: [
//            SortDescriptor(\Step.index, order: .forward)
//        ]
//    ) var steps: [Step]
    
    @Query (
        sort: [
            SortDescriptor(\Step.index, order: .forward)
        ]
    ) var steps: [Step]
    
//
 
    func checkPickerDate() {
        for i in 0..<steps.count-1 {
            let step = steps[i]
            let nextStep = steps[i+1]
            if step.date > nextStep.date {
                let d1 = zeroDate(step.date)
//                let d2 = zeroDate(nextStep.date)
                nextStep.date = Calendar.current.date(byAdding: .day, value: 1, to: d1)! // 次の日
            }
            

        }
    }
    
    func updateSpanStr() {
        for i in 0..<steps.count {
            let step = steps[i]
            step.spanStr = spanStr(from: zeroDate(Date()), to: zeroDate(step.date))
        }
    }

    var prevStepDate : Date?
    var step : Step
//    var nextStep : Step?
        
    var forAddItem : Bool
    
    @Query private var items: [Item]
    
    func filteredItems(_ stepNumber: Int) -> [Item] {
        return items.compactMap { item in
            return ((item.stepNumber == step.index+1) && (item.continuing == false)) ? item : nil
        }
    }
    
    let picerScale = 0.7
    @State private var dateTime = Date()
    
    //残り日数計算function
    func resetTime(date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
    }
    
    
    func strFromDate(_ date: Date, format: String) -> String {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = format // "yyyy-MM-dd"
        let strDate2 = formatter2.string(from: date)
        return strDate2
    }
    
    var infiniteDate : Date {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: 3000, month: 12, day: 31))
        return date!
    }
    

    func getStartDate() -> Date {
        
        if step.index == 0 {
            return Date()
        } else {
            return prevStepDate!
        }
    }

//    @State var spanString = ""
    
    var body: some View {
        
        
//        GeometryReader { geo in
            
            HStack(alignment: .center, spacing: 0) {
                
                // 左
                HStack(spacing: 6) {
                    ForEach(filteredItems(step.index)) { item in
                        StepItmeView(item: item , index: step.index, forAddItem: forAddItem)
                    }
//                    if filteredItems(step.index).count <= 2 {
//                        StepItmeView(item: nil , index: step.index, forAddItem: forAddItem)
//                    }
                }
//                .background(.red)
                .frame(width: 180, alignment: .center)
                
                Spacer(minLength: 2)
                
                // 右
                HStack(alignment: .center, spacing: 0) {
                                        
                    Text(String(step.index+1))
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                        .frame(width: 10, alignment: .leading)
                        .padding(0)
                    
                    Spacer(minLength: 2)
                    
                    DatePicker(
                        "〆切",   // ラベル
                        selection: Binding(get: {
                            withAnimation {
                                step.date
                            }
                        }, set: { (newVal) in
                            withAnimation {
                                step.date = newVal
                                checkPickerDate()
                                updateSpanStr()
                            }
                        }),
                        in: getStartDate()...infiniteDate,
                        displayedComponents: [.date] // 日付のみ表示する指定
                    )
                    .fixedSize()
                    .labelsHidden()
                    .scaleEffect(x: picerScale, y: picerScale)
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .foregroundStyle(step.index == 0 ? .blue : .black)
                    .padding(.vertical, 0)
                    .frame(width: 100, alignment: .trailing)
       
                    Text(step.spanStr ?? "")
                        .font(step.index == 0 ? .system(size: 16).bold() : .system(size: 14))
                        .minimumScaleFactor(0.1)
                        .foregroundStyle(step.index == 0 ? .green : .black)
                        .frame(width: 100, alignment: .leading)
                        .padding(.trailing, 3)
                 
                    Spacer()
                }
            }
            .onAppear{
                updateSpanStr()
            }

//            .opacity(step.index == 0 ? 1 : 0.6)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: step.index == 0 ? 30 : 10, maxHeight: 60, alignment: .leading)
  
    }
}
            
      
            
            
     
            
            
                
//                Text(step.index == 0 ? "Today" : strFromDate(step.date, format: "yyyy.MM.dd"))
//                .font(step.index == 0 ? .title2 .bold() : Font.system(size: 14))
//                    .foregroundStyle(step.index == 0 ? .blue : .black)
//                    .minimumScaleFactor(0.1)
//                    .frame(width: 80, alignment: .leading)
            
//                Spacer(minLength: 5)
            

            
            
         
            
        
//                Text(strFromDate(step.span, format: "yy年Mヶ月"))
//                    .font(step.index == 0 ? Font.system(size: 16) : Font.system(size: 12))
//                    .foregroundStyle(step.index == 0 ? .blue : .black)
//                    .minimumScaleFactor(0.1)
//                    .frame(width: 80, alignment: .leading)

//            }
            
            //            Spacer()
            
            

     



//@ViewBuilder
struct StepItmeView : View {
    
    var item : Item?
    var index : Int
    var forAddItem : Bool
    
    let smallLength : CGFloat = 40
    
    @State var showSheet = false
    
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    
    @EnvironmentObject var setData : ShareData
    
        var body: some View {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: index == 0 ? 50 : smallLength, height: index == 0 ? 50 : smallLength, alignment: .center)
//                .foregroundStyle(item != nil ? (index == 0 ? colorForIndex(item!.catIndex) : colorForIndex(item!.catIndex).opacity(0.17)) : .gray)
                .foregroundStyle(item != nil ? (item!.inImmersion != nil && item!.inImmersion! ? colorForIndex(item!.catIndex) : colorForIndex(item!.catIndex).opacity(0.17)) : .gray)
                .onTapGesture {
                    if item != nil {

                  
                        showSheet = true
      
                    }
                }
                .sheet(isPresented: $showSheet) {
                    ItemDetailScreen(item: item!)
                }
                .overlay {
                    ZStack {
                        if index == 0 {
                            VStack {
                                Image(systemName: iconNames_1[icon_1])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 8)
                                    .padding(.top, 3)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .frame(width: 50, height: 50, alignment: .center)
                        }
                        
                        Text(item != nil ? item!.title : "＋")
                            .font(Font.system(size: item != nil ? 12 : 18))
                            .bold(index == 0)
                            .multilineTextAlignment(.center)
                            .padding(3)
//                            .foregroundStyle(item != nil ? (index == 0 ? .white : colorForIndex(item!.catIndex)) : Color("darkgray"))
                            .foregroundStyle(item != nil ? (item!.inImmersion != nil && item!.inImmersion! ? .white : colorForIndex(item!.catIndex)) : Color("darkgray"))
                            .minimumScaleFactor(0.1)
//                            .blinkEffect(enabled: (item == nil && forAddItem))
//                            .onTapGesture {
//                                
//                                if setData.selectedItemView != nil {
//                                    withAnimation {
//                                        setData.selectedItemView.item.stepNumber = index + 1
//                                    }
//                                }
//                            }
                        
                        RoundedRectangle(cornerRadius: 1)

                            .stroke(colorForIndex(item!.catIndex), style: StrokeStyle(lineWidth: item != nil ? (index == 0 ? 0 : 1.5) : 0))
                        
                        if item != nil && item!.isDone {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: index == 0 ? 50 * 0.7 : 30 * 0.7, height: index == 0 ? 50 * 0.7 : 30 * 0.7, alignment: .center)
                                .foregroundColor(.white.opacity(0.6))
                                .zIndex(10)
                        }
                    }
                }
        }
}


