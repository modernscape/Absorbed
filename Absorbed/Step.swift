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
            .animation(Animation.linear(duration: self.interval).repeatForever())
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


struct StepsScreen : View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var setData : ShareData
    
    @Query var items : [Item]
    
    @Query (
        sort: [
            SortDescriptor(\Step.index, order: .forward)
        ]
    ) var steps: [Step]
        
    var forAddItem : Bool
    
    func addStep() {
        let item = Step(index: steps.count, date: Date(), span: Date())
        modelContext.insert(item)
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
    
    let grids = [GridItem(.fixed(50), spacing: 10, alignment: .center)]
    
    var body: some View {
        NavigationView {
            
            
            VStack(spacing: 0) {
                
                CaptionView(str: "結局今何に集中すべきか？最優先事項を選択しよう")
                
                Spacer(minLength: 2)
                
                List {
                    Section {
                        //                    ForEach(steps.stepsData) { data in
                        //                        StepRow(data)
                        //                    }
                        //                    .listRowSeparator(.hidden)
                        
                        ForEach(steps) { data in
                            StepRow(step: data, forAddItem: forAddItem)
                        }
                        .listRowSeparator(.hidden)
                        
                        
                    }
                }
                //            .background(.red)
                .padding(.horizontal ,2)
                .padding(.vertical ,0)
                
                
                //            List(steps.stepsData) { data in
                //                StepRow(data)
                //            }
                .listStyle(.plain)
                .navigationTitle(forAddItem ? "アイテムをステップに追加" : screenTitles[2])
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    /// ナビゲーションバー右
                    ToolbarItem(placement: .navigationBarTrailing){
                        HStack(spacing: 0) {
                            //                        Text("ステップ")
                            //                            .font(.footnote)
                            
                            Button {
                                withAnimation {
                                    //                                steps.addStep()
                                    addStep()
                                }
                            } label: {
                                Image(systemName: "text.badge.plus")
                            }
                        }
                        
                    }
                    
                }
                
                VStack(alignment: .center, spacing: 3) {
                    
                    HStack(spacing: 3) {
                        Image(systemName: "repeat")
                            .foregroundStyle(Color("continuing_rect"))
//                            .tint(Color("continuing_rect"))
                        Text("継続して行う")
                            .foregroundStyle(Color("continuing_rect"))
                            .bold()
                        
                    }
                  
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: grids, spacing: 7) {
                            ForEach(continuingItems) { item in
                                
                                ZStack {
                                    VStack {
                                    }
                                    .frame(width: 50, height: 50)
                                    .background(
                                        Image("pat_5").resizable(
                                            resizingMode: .tile
                                        )
                                        .opacity(0.7)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .position(CGPoint(x: 50/2, y: 50/2))
                                    .zIndex(1)
                                    .overlay {
                                        Text(item.title)
                                            .foregroundStyle(.white)
                                            .font(Font.system(size: 14))
                                            .minimumScaleFactor(0.1)
                                            .padding(3)
                                    }
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 50)
                                        .foregroundStyle(colors[item.catIndex].opacity(1))
//                                        .blendMode(.overlay)
                                        .blendMode(.multiply)
                                        .onTapGesture {
                                            //                                        deleteDislike(item)
                                        }
                                }
                                
                            
                                  
                            }
                            
                            Button{
                                withAnimation {
//                                    addDislike(title: "嫌なこと")
                                    
                                }
                                
                            } label: {
                                Text("＋")
                                    .foregroundStyle(Color("continuing_rect"))
                                    .font(Font.system(size: 30))
                            }
                            
                            
                        }
                        
                        
                    }
                    .frame(height: 55)
                    .padding(5)
                    .background(Color("continuing_rect").opacity(0.3))
                    .border(Color("continuing_rect"), width: 2)
 
                }
                .padding(.horizontal, 5)
                
            }
            
     
            
        }
        .onAppear {
            if _ud.object(forKey: KeyString.stepsMaken.rawValue) == nil {
                makeDefaultSteps()
                _ud.setValue("Done", forKey: KeyString.stepsMaken.rawValue)
            }
            
            continuingItems = filteredItems()
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

@Model
class Step : Identifiable, Equatable {
    
    var id = UUID()
    var index : Int
    var date : Date
    var span : Date
    
    init(id: UUID = UUID(), index: Int, date: Date, span: Date) {
        self.id = id
        self.index = index
        self.date = date
        self.span = span
    }
    

}
    
//#Preview {
//    StepsScreen()
//}





struct StepRow : View {
    var step : Step
    
    var forAddItem : Bool
    
    @Query private var items: [Item]
    func filteredItems(_ stepNumber: Int) -> [Item] {
        return items.compactMap { item in
            return item.stepNumber == step.index+1 ? item : nil
        }
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 3) {
            
            //            Spacer()
            
            HStack(spacing: 6) {
                //                Spacer()
                
       
                ForEach(filteredItems(step.index)) { item in
                    StepItmeView(item: item , index: step.index, forAddItem: forAddItem)

                    
                }
                
                if filteredItems(step.index).count <= 2 {
                    
                    StepItmeView(item: nil , index: step.index, forAddItem: forAddItem)
                }
                
 
            }
//            .background(.blue)
            .frame(width: 180, alignment: .center)
            
//                        Spacer()
            
//            HStack(alignment: .center, spacing: 3) {
                Text(String(step.index+1))
                    .font(Font.system(size: 10))
                    .foregroundStyle(.gray)
                    .frame(width: 10, alignment: .leading)
                
                Text(step.index == 0 ? "Today" : strFromDate(step.date, format: "yyyy.MM.dd"))
                .font(step.index == 0 ? .title2 .bold() : Font.system(size: 14))
                    .foregroundStyle(step.index == 0 ? .blue : .black)
                    .minimumScaleFactor(0.1)
                    .frame(width: 80, alignment: .leading)
            
                Spacer(minLength: 5)
                
                Text(strFromDate(step.span, format: "yy年Mヶ月"))
                    .font(step.index == 0 ? Font.system(size: 16) : Font.system(size: 12))
                    .foregroundStyle(step.index == 0 ? .blue : .black)
                    .minimumScaleFactor(0.1)
                    .frame(width: 80, alignment: .leading)
//            }
            
            //            Spacer()
            
            
        }
//        .background(.purple)
        .opacity(step.index == 0 ? 1 : 0.6)
//        .frame(height: step.index == 0 ? 60 : 30)
//        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: step.index == 0 ? 60 : 30, idealHeight: 0, maxHeight: 60, alignment: .center)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: step.index == 0 ? 60 : 30, maxHeight: 60, alignment: .center)
   
        
    }
     
}


//@ViewBuilder
struct StepItmeView : View {
    
    var item : Item?
    var index : Int
    var forAddItem : Bool
    
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    
    @EnvironmentObject var setData : ShareData
    
        var body: some View {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: index == 0 ? 50 : 30, height: index == 0 ? 50 : 30, alignment: .center)
                .foregroundStyle(item != nil ? colors[item!.catIndex] : .gray)
                .onTapGesture {
                    if item != nil {
                        withAnimation{
                            item!.isDone.toggle()
                        }
                    }
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
                            .padding(3)
                            .foregroundStyle(item != nil ? .white : Color("darkgray"))
                            .minimumScaleFactor(0.1)
//                            .blinkEffect(enabled: (item == nil && forAddItem))
                            .onTapGesture {
                                
                                if setData.selectedItemView != nil {
                                    withAnimation {
                                        setData.selectedItemView.item.stepNumber = index + 1
                                    }
                                }
                            }
                        
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(style: StrokeStyle(lineWidth: item != nil ? 0 : 1, dash: [5, 2]))
                        
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


func strFromDate(_ date: Date, format: String) -> String {
    let formatter2 = DateFormatter()
    formatter2.dateFormat = format // "yyyy-MM-dd"
    let strDate2 = formatter2.string(from: date)

    
    return strDate2
}


