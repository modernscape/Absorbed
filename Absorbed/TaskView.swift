//
//  TaskView.swift
//  Absorbed
//
//  Created by bird on 2024/04/24.
//

import SwiftUI


    
    
struct TaskView: View {
    
    var items: [Item]
    
    let dayStrs = ["月", "火", "水", "木", "金", "土", "日"]

    

    
    @AppStorage(KeyString.taskViewHiddenDateStr.rawValue) var taskViewHiddenDateStr = ""
//    var w : CGFloat
    
    func saveTaskViewHiddenDateStr() {
//        @AppStorage(KeyString.taskViewHiddenDateStr.rawValue) var taskViewHiddenDateStr = ""
        taskViewHiddenDateStr = dateToString(date: Date(), format: dateFormatStr)
        print("taskViewHiddenDateStr")
        print(taskViewHiddenDateStr)
    }
    
    func resetAllAchievements() {
        for item in items {
            for phase in item.phases {
                phase.achievements_num = defaultAchievements_num
            }
        }
    }
    
    func sortedModelsFor(item: Item) -> [Phase] {
        return item.phases.sorted(by: { $0.index < $1.index })
    }
    
    
    

    
    var body: some View {
        
        
     
        GeometryReader { reader in
  
            NavigationView {
                                
                List {
                    Section(header: HStack {
                        
                        HStack {}
                            .frame(width: (reader.size.width)*0.3, height: 10)
//                            .background(.red)

                        
                        HStack(spacing: 1) {
                            ForEach(Array(dayStrs.enumerated()), id: \.element) { index, str in
                            
//                            ForEach(dayStrs, id: \.self) { str in
                                
                                Rectangle()
                                    .fill(.white)
                                    .frame(width: ((reader.size.width*0.7)-66)/7, height: 20)
                                    .stroke(color: .white ,width: 1)
                                    .overlay{
                                        Text(str)
                                            .foregroundColor(isToday(index) ? Color("app_blue") : .gray)
                                            .bold(isToday(index))
                                    }
                              
                                
                            }
                        }
                        .frame(width: reader.size.width*0.7, height: 20, alignment: .leading)
//                        .padding(.horizontal, 20)
             
                     
                        
                        
                    }) {
                        ForEach(Array(items.enumerated()), id: \.element) { index, item in
                            VStack(alignment: .leading) {
                                
                                HStack(alignment: .center) {
                                    Rectangle()
                                        .fill(colorForIndex(item.catIndex))
                                        .frame(width: 25, height: 25)
                                        .overlay {
                                            Text(String(index+1))
                                                .foregroundStyle(.white)
                                                .font(.system(size: 15))
                                            
                                        }
                                        .padding(.leading, item.phases.count == 0 ? 0 : 25)
                                        .padding(.top, 15)
            
                                       
//                                        .fill(.red)
                             
                             
                                    
                                    Text(item.title)
                                        .font(.system(size: 14))
                                        .underline()
                                        .foregroundStyle(colorForIndex(item.catIndex))
//                                        .padding(.leading, item.phases.count == 0 ? 0 : 25)
                                        .padding(.top, 15)
                                    
                                    Spacer()
                                    
                                    Text("------------")
                                        .font(.system(size: 14))
                                        .padding(.top, 15)
                                        .foregroundStyle(colorForIndex(item.catIndex))
                                    
                                    
                                    
                                }
//                                .background(.blue)
                            
                                
//                                    .background(.black)
//                                    .multilineTextAlignment(.leading)
                    
//                                ForEach(Array(item.phases.enumerated()), id: \.element) { index, phase in
                                ForEach(Array(sortedModelsFor(item: item).enumerated()), id: \.element) { index, phase in
                                    TaskRow(phase: sortedModelsFor(item: item)[index], w: reader.size.width)
                                    //                                    .foregroundStyle(colorForIndex(item.catIndex))
//                                        .frame(height: 50)
                                        .opacity(item.phases[index].isDone! ? 0.3 : 1.0)
                                    //
                                    
                                }
                            }
//                            .background(.green)
                       
                            
                        
                            
                            
                        }
//                        .frame(width: (reader.size.width), alignment: .leading)
//                        .frame(width: (reader.size.width)*0.3)
                        
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
//                        .border
                        
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal, 20)
                .environment(\.defaultMinListRowHeight, 20)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("行動実績")
                
//                .toolbar {
//                    
//                    /// ナビゲーションバー右１
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        EditButton()
//                    }
//                    /// ナビゲーションバー左
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        HStack(spacing: 0) {
//                            Button(action: {
//                   
//                                
//                            }) {
//                                Image(systemName: "plus")
//                            }
//                        }
//                    }
//                }
                .onWillAppear {
                    print("--------onWillAppear--------")
                    print("onWillAppear")
                    print("--------onWillAppear--------")
                    
//                    let s = "2024/05/13"
                    
//                    if dateToString(date: Date(), format: dateFormatStr) != taskViewHiddenDateStr {
                    if weekFor(date: Date()) != weekFor(date: stringToDate(dateValue: taskViewHiddenDateStr)) {
//                    if weekFor(date: Date()) != weekFor(date: stringToDate(dateValue: s)) {
                        
                        print("別の週")
                        
                    
                        resetAllAchievements()
                        
                        
                    } else {
                        print("同じ週")
                    
                    }
                    
                    
        
                }
                .onDisappear {
                    saveTaskViewHiddenDateStr()
                }
                .onAppear {
 
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification), perform: { _ in
                    if weekdayFor(date: Date()) == 2 { // 週が変わった時（日　→　月）
                        saveTaskViewHiddenDateStr()
                        resetAllAchievements()
                    }
                })
            
            }
        }
    }
}

//struct ContentView: View {
//    @State var dayDetails: String = "Hello World"
//    var body: some View {
//        Text(dayDetails)
//            .padding()
//            .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification), perform: { _ in
//                dayDetails = "Day has changed"
//            })
//    }
//}



struct TaskRow: View {
    
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    
    var phase: Phase
    
    let numImgSuffix = ".circle.fill"
    
    
    let grids = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var w : CGFloat
    
//    func numForPhase(index: Int) -> Int {
//        var num = 0
//        for i in 0...index {
//            let a = phase.achievements_num![i]
//            if a != 0 {
//                num += 1
//            }
//        }
//        return num+1
//    }
    
    func updateAchievements_num() {
        var num = 0
        for i in 0..<phase.achievements_num!.count {
            if phase.achievements_num![i] != 0 {
                phase.achievements_num![i] = num+1
                num += 1
            }
        }
    }
    
    func imgNameFor(_ index: Int) -> String {
        var name = "trophy.circle.fill"
        if phase.isDone! == false {
            if phase.achievements_num == nil {
                phase.achievements_num = defaultAchievements_num
                name = "circle.dotted"
            } else {
                if phase.achievements_num![index] == 0 {
                    name = "circle.dotted"
                } else {
                    name = String(phase.achievements_num![index]) + numImgSuffix
                }
            }
        }
        return name
    }
    
    var body: some View {
        
        //        GeometryReader { reader in
        
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
                    .bold()
                    .minimumScaleFactor(0.1)
                    .foregroundColor(colorForIndex(phase.item.catIndex))
                
                Spacer()
                
                
            }
            .padding(.leading, 25)
            .frame(width: w*0.3)
            //            .background(.gray)
            
            
            
            
            LazyHGrid(rows: grids, alignment: .center, spacing: 1) {
                ForEach (0..<7, id: \.self) { index in
                    //                                Text(String(num))
                    
                    Rectangle()
                        .fill(.white)
                        .frame(width: ((w*0.7)-66)/7)
                        .stroke(color: .white ,width: 1)
                        .overlay {
//                            Image(systemName:phase.isDone! ? "trophy.circle.fill" : (phase.achievements_num != nil && phase.achievements_num![index] == 0 ? "circle.dotted" : String(phase.achievements_num![index]) + numImgSuffix))
                            
                            Image(systemName: imgNameFor(index))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 27, alignment: .center)
                                .foregroundColor(colorForIndex(phase.item.catIndex))
//                                .padding(2)
               
                                .background(isToday(index) ? Color("app_blue").opacity(0.1) : .white)
                                .cornerRadius(20)
                            
                  
                            
                              
                        }
                        .onTapGesture {
                            if phase.achievements_num != nil {
                                
                                if phase.achievements_num![index] == 0 {
                                    phase.achievements_num![index] = 1
                                    
                                    if isToday(index) {
                                        countUp(phase)
                                    }
                                    
//                                    saveCountUpdateDateStr()
//                                    phase.item.todayCount! += 1
//                                    phase.item.count! += 1
                                    vivrate()
                                    updateAchievements_num()
                                    
//                                    if phase.achievements_num![index] != 0 {
//                                        vivrate()
//                                    }
                                } else {
                                    if isToday(index) {
                                        countDown(phase)
                                    }
//                                    phase.item.todayCount! -= 1
//                                    phase.item.count! -= 1
                                    phase.achievements_num![index] = 0
                                    updateAchievements_num()
                                }
                                
                            
                            } else {
                                phase.achievements_num = defaultAchievements_num
                                phase.achievements_num![index] = 1
                                vivrate()
                            }
                        }
                    
                    
                }
                
                
            }
            .frame(width: w*0.7, height: 30, alignment: .leading)
            
            
        }
        
        
    }
}


#Preview {
    TaskView(items: [item_00, item_01, item_10])
}
