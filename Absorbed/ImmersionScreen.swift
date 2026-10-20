//
//  ImmersionView.swift
//  Immersion
//
//  Created by forest on 2024/02/01.
//

import SwiftUI
import SwiftData
import WatchConnectivity

struct ImmersionScreen: View {

    
    @AppStorage(KeyString.inputText_hindrance.rawValue) var inputText_hindrance : String = "入力してください"
    @AppStorage(KeyString.inputText_lisk.rawValue) var inputText_lisk : String = "入力してください"
    


    var body: some View {
        
        
        VStack(spacing: 0) {
        
            Text("行動したくない理由\n行動を阻むもの")
                .font(.system(size: 13))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            TextEditor(text: $inputText_hindrance) //.constant("行動したくない理由\n行動を阻むもの"))
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
//                .border(Color.black)
                .padding(.vertical, 3)
                .padding(.horizontal)
                .frame(height: 100)
                .overlay {
                    Rectangle()
                        .stroke(.gray.opacity(0.8), style: StrokeStyle(lineWidth: 1, dash: [5, 2]))
               
                        .padding(.vertical, 3)
                        .padding(.horizontal)
                }
 
            
            Spacer()
            
      
            
            DaysView()
            
            Spacer()

            ImmersionView()
            
            Spacer()
            
            Text("実行しない不快さ・リスク")
                .font(.system(size: 13))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(0)

        
            TextEditor(text: $inputText_lisk)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(10)
                .background(.gray.opacity(0.2))
                .frame(height: 150)
                .padding(.vertical, 3)
//                .ignoresSafeArea()
     
          
            
         
        }
//        .frame(maxHeight: .infinity)
//        .background(.red)
    }
}

#Preview {
    ImmersionScreen()
}


/* ----------------------------------------------------------------------------
 MARK: - Connect
 ------------------------------------------------------------------------------*/

struct SelectedItemModel {
//    private(set) var selectedAnimal: String = "🐱"
    private(set) var selectedFruit: [String] = []
//    private(set) var selectedWeather: String = "☀️"
//    private(set) var selectedImage: UIImage? = nil
    
//    mutating func changeSelected(animal: String) {
//        selectedAnimal = animal
//    }
//    
    mutating func changeSelected(fruit: [String]) {
        selectedFruit = fruit
    }
    
//    mutating func changeSelected(weather: String) {
//        selectedWeather = weather
//    }
//    
//    mutating func changeSelected(image: UIImage?) {
//        selectedImage = image
//    }
}


class WatchConnectViewModel: NSObject, ObservableObject {
    
    //    @Published  var langs: [String] = []
    
    @Environment(\.modelContext)  var modelContext
    
    @Published var selectedItemModel: SelectedItemModel
    
    private var session: WCSession = .default
    
 
    
    init(selectedItemModel: SelectedItemModel) {
//        self.stateModel = stateModel
        self.selectedItemModel = selectedItemModel
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
        
//
    
//    var selectedFruit: String {
//        get {
//            return selectedItemModel.selectedFruit
//        }
//        set {
//            selectedItemModel.changeSelected(fruit: newValue)
//        }
//    }
//    
    

    
}

extension WatchConnectViewModel: WCSessionDelegate {
    
 
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("セッション：アクティベート")
        }
    }
    

    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
//    func updateApplicationContext_title(_ titles: [String]) {
//        let context: [String: Any] = ["titles": titles]
//        do {
//            try session.updateApplicationContext(context)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    
    func updateApplicationContext(_ items: [[String : Any]]) {
        let context: [String: Any] = ["items": items]
        do {
            try session.updateApplicationContext(context)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
//    func updateApplicationContext_catIndexes(_ catIndexes: [Int]) {
//        let context: [String: Any] = ["catIndexes": catIndexes]
//        do {
//            try session.updateApplicationContext(context)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    
    
//    func updateApplicationContext(str: String) {
//                let context: [String: Any] = [KeyString.todayItems.rawValue: str]
//                do {
//                    try session.updateApplicationContext(context)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }

    
    
//    func fetchTodayItems() -> [String] {
//        var descriptor = FetchDescriptor<Item>()
//        var strs = [String]()
//        
//        descriptor.predicate = #Predicate { item in
//            item.stepNumber == 1
//        }
//        if let filteredList = try? modelContext.fetch(descriptor) {
//            for i in filteredList {
//                
//                strs.append(i.title)
//            }
//        }
//        
//        print(strs)
//        
//        
//        return strs
//        
//    }
    
    
}




struct ImmersionView: View {
    
    @EnvironmentObject var setData : ShareData
    
//    private let viewModel = WatchConnectViewModel()
    
    @EnvironmentObject var viewModel: WatchConnectViewModel // = WatchConnectViewModel(selectedItemModel: SelectedItemModel())
    
    @State  var isConnect = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
//    var myItems = try modelContext.fetch(FetchDescriptor<Item>())
    
    func filteredItems() -> [Item] {
        return items.compactMap { item in
            return item.stepNumber == 1 ? item : nil
        }
    }
    
//    func itemTitles() -> [String] {
//        var strs = [String]()
//        for item in filteredItems() {
//            strs.append(item.title)
//        }
//        return strs
//    }
//     
    let space : CGFloat = 20
    
    let key1 = "title"
    let key2 = "catIndex"
    
  

    func fetchTodayItems_cur() -> [String] {
        var descriptor = FetchDescriptor<Item>()
        var strs = [String]()

        descriptor.predicate = #Predicate { item in
            item.stepNumber == 1
        }
        if let filteredList = try? modelContext.fetch(descriptor) {
            for i in filteredList {

                strs.append(i.title)
            }
        }
        
        print(strs)

        return strs

    }
    

    
    func fetchTodayItems() -> [[String : Any]] {
        var descriptor = FetchDescriptor<Item>()
        var items = [[String : Any]]()
        
        descriptor.predicate = #Predicate { item in
            item.stepNumber == 1
        }
        if let filteredList = try? modelContext.fetch(descriptor) {
            for i in filteredList {
                
                let dict = [key1 : i.title, key2 : i.catIndex] as [String : Any]
                items.append(dict)
            }
        }
        
       
        
        return items
        
    }
    
    
    
    var body: some View {
        
//        Button {
//
//            viewModel.updateApplicationContext(fruit: self.fetchTodayItems())
//            
//
//            
//        } label: {
//            Text("Watchに送る")
//        }
//        .padding(.bottom, 10)
        
        
        VStack {
            switch filteredItems().count {
            case 1:
                ItemRectView(item: filteredItems()[0], count: filteredItems().count)
            case 2:
                HStack(spacing: space) {
                    ItemRectView(item: filteredItems()[0], count: filteredItems().count)
                    ItemRectView(item: filteredItems()[1], count: filteredItems().count)
                }
            case 3:
                
                VStack(spacing: space)  {
                    ItemRectView(item: filteredItems()[0], count: filteredItems().count)
                    
                    HStack(spacing: 20) {
                        ItemRectView(item: filteredItems()[1], count: filteredItems().count)
                        ItemRectView(item: filteredItems()[2], count: filteredItems().count)
                    }
                }
            case 4:
                VStack(spacing: space)  {
                    HStack(spacing: space) {
                        ItemRectView(item: filteredItems()[0], count: filteredItems().count)
                        ItemRectView(item: filteredItems()[1], count: filteredItems().count)
                    }
                    HStack(spacing: space) {
                        ItemRectView(item: filteredItems()[2], count: filteredItems().count)
                        ItemRectView(item: filteredItems()[3], count: filteredItems().count)
                    }
                }
            default:
                Text("no item")
            }
            
        }
        .onAppear {
//            print(fetchTodayItems().count)
            
//            viewModel.send(items: fetchTodayItems())
//            viewModel.send(str: fetchTodayItems())
            
//            viewModel.selectedFruit = fetchTodayItems()
            
            viewModel.updateApplicationContext(self.fetchTodayItems())
//            print(filteredItems().count)
            
//            setData.todayItems = filteredItems()
        }
        
     
           
        
    }
        
}


struct ItemRectView: View {
    

    var lengthes : [CGFloat] = [200, 150, 130, 120]
    
    var item : Item
    var count = 1
    
    @State var showItemDetailScreen = false
    
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    
    var body: some View {
    
        
        ZStack {
            
            
 
        Rectangle()
            .fill(colors[item.catIndex])
            .frame(width: lengthes[count-1], height: lengthes[count-1])
            .overlay {
                Text(item.title)
                    .foregroundStyle(.white)
                    .font(Font.system(size: 24).bold())
                    .minimumScaleFactor(0.1)
            }
      
//        if item.stepNumber == 1 {
            VStack {
                Image(systemName: iconNames_1[icon_1])
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15)
                    .padding(.top, 5)
                    .foregroundColor(.white)
                Spacer()
            }
            .frame(width: lengthes[count-1], height: lengthes[count-1])
//        }
            
        }
        .onTapGesture {
            showItemDetailScreen = true
            
       
        }
        .sheet(isPresented: $showItemDetailScreen) {
            ItemDetailScreen(item: item)
        }
        
        
    }
}


/* ----------------------------------------------------------------------------
 MARK: - Days
 ------------------------------------------------------------------------------*/
struct DaysView: View {
    
//    @Environment(\.modelContext) var modelContext
//    @Query private var days: [ExecutionDay]
    var dayCount = 10
    
//    @AppStorage(KeyString.startDay.rawValue) var startDay : Date = Date()
    
    let grids = [GridItem(.fixed(50), spacing: 10, alignment: .center)]
    
    func makeDays() {
        
//        dateToBack = Int(Date().timeIntervalSince1970)
  
    }
    
//    func addDay() {
//        let item =  ExecutionDay(title: "", index: 0)
//        modelContext.insert(item)
//    }
//    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 3) {
            Text("Today")
                .bold()
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: grids, spacing: 3) {
                    
                    ForEach((1...dayCount), id: \.self) { num in
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(num == dayCount ? .mint : .gray)
                            .overlay {
                                Text(String(num))
                                    .foregroundStyle(.white)
                                    .font(Font.system(size: 12))
                                    .minimumScaleFactor(0.1)
//                                    .padding(3)
                                
                                
                            }
                            .onTapGesture {
//                                deleteDislike(item)
                            }
                    }

                }
                
                
            }
            .frame(height: 25)
            .padding(.horizontal, 5)
//            .background(.gray.opacity(0.9))
//            .border(.gray, width: 3)
            
            
        }
        .padding(.horizontal, 5)
        .onAppear {
            makeDays()
        }
    }
}


//@Model
//class ExecutionDay {
//    var title : String
//    var index : Int
//    
//    init(title: String, index: Int) {
//        self.title = title
//        self.index = index
//    }
//}


