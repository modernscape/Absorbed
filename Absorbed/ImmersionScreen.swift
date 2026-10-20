//
//  ImmersionView.swift
//  Immersion
//
//  Created by forest on 2024/02/01.
//

import SwiftUI
import SwiftData
import WatchConnectivity
import AudioToolbox

struct ImmersionScreen: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage(KeyString.inputText_hindrance.rawValue) var inputText_hindrance : String = "習得に時間がかかりそう\n成果が出るか分からない"
    @AppStorage(KeyString.inputText_lisk.rawValue) var inputText_lisk : String = "嫌な仕事をしなくてはならない\n貧弱な体"
    @AppStorage(KeyString.showFields.rawValue) var showFields_stored = true
    @AppStorage(KeyString.dreamStr.rawValue) var dreamStr = "お金持ちになって自由を手にいれる"
    @AppStorage(KeyString.dreamLimitStr.rawValue) var dreamLimitStr = dateToString(date: Calendar.current.date(byAdding: .year, value: 30, to: stringToDate(dateValue: "2000/01/01", format: dateFormatStr))!)
    @AppStorage(KeyString.icon_4.rawValue) var icon_4 : Int = 0
    
    @FocusState var focused_1 : Bool
    @FocusState var focused_2 : Bool
    
    @Query private var benefitImages: [BenefitImage]
    
    @State var showFields = false
    
    let moveL : CGFloat = 200
    
    func addImage() {
        addBenefitImage()
    }
    
    // Want
    private func addBenefitImage() {
        let item =  BenefitImage()
        modelContext.insert(item)
    }
    
    @Binding var showBenefitImage : Bool
    @Binding var selectedBenefitImage : UIImage

    var body: some View {
        GeometryReader { reader in
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    HStack(alignment: .center, spacing: 3) {
                        //                        Color.red
                        Image(systemName: iconNames_5[0])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 14)
//                            .foregroundColor(Color("reaseon"))
                        
                        Text("行動したくない理由、行動を阻むもの")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.center)
//                            .foregroundColor(.black).opacity(0.9)
//                            .foregroundColor(Color("reaseon")).opacity(0.8)
                        //                    .fontWeight(.ultraLight)
                            .bold()
                    }
                    .foregroundColor(.black).opacity(0.9)
           
                    
                    TextEditor(text: $inputText_hindrance) //.constant("行動したくない理由\n行動を阻むもの"))
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .focused($focused_1)
                        .foregroundColor(Color("reaseon"))
                        .padding(.vertical, 2)
                        .padding(.horizontal)
                        .frame(height: 80)
                        .overlay {
                            Rectangle()
                                .stroke(Color("reaseon").opacity(0.8), style: StrokeStyle(lineWidth: 1, dash: [5, 2]))
                                .padding(.vertical, 3)
                                .padding(.horizontal)
                        }
                    
                }
                .offset(y: showFields ? 0 : -moveL)
                .opacity(showFields ? 1 : 0)
                .onTapGesture {
                    
                }
                
                HStack(alignment: .center) {
                    Text(dreamStr)
                        .lineLimit(1)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.yellow)
                        .stroke(color: .black.opacity(0.8), width: 1.5)
                        .minimumScaleFactor(0.1)
                    
                    Spacer(minLength: 10)
                    
                    VStack(alignment: .center){
                        Text("期限: " + dreamLimitStr)
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .stroke(color: .black.opacity(0.8), width: 1.5)
                            .minimumScaleFactor(0.1)
                        
                        Text("残り: " + spanString(toDateString: dreamLimitStr))
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .bold))
                            .minimumScaleFactor(0.1)
                            .foregroundColor(Color("app_blue"))
                            .underline()
                        
                    }
                 
                }
                //            .bold()
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                
                
                
                //            BenefitImageView(benefitImage: BenefitImage())
                
                ImmersionView()
                    .overlay {
                        Image("addImageBtn")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .position(x: 35, y: 20)
                            .opacity(showFields ? 1 : 0)
                            .onTapGesture {
                                addImage()
                            }
                            .zIndex(100)
                        
                        ForEach(benefitImages) { img in
                            BenefitImageView(benefitImage: img, showBenefitImage: $showBenefitImage ,selectedBenefitImage: $selectedBenefitImage)
                        }
                        
                        if showBenefitImage {
                            Image(uiImage: selectedBenefitImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(5)
                                .frame(width: reader.size.width*0.95)
                                .position(CGPoint(x:reader.size.width/2, y: reader.size.height/2))
                                .opacity(0.95)
                                .shadow(radius: 3)
                   
                           
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                    .zIndex(200)
                
                
                Spacer()
                
                       
                //
                
                VStack(spacing: 0) {
                    
                    HStack(alignment: .center, spacing: 3) {
//                        Color.red
                        Image(systemName: iconNames_4[icon_4])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
//                            .foregroundColor(Color("reaseon"))
       
   
                        
                        Text("実行しないことによる不快さ・リスク")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color("reaseon")).opacity(0.8)
                            .foregroundColor(.black)
                            .padding(0)
                            .bold()
                        
                    }
                    .foregroundColor(.black).opacity(0.9)
        
//                    TextEditor(text: $inputText_lisk)
//                        .font(.system(size: 15))
//                        .multilineTextAlignment(.center)
//                        .padding(7)
//                        .background(.gray.opacity(0.2))
//                        .frame(height: 100)
//                        .padding(.vertical, 2)
//                        .focused($focused_2)
//                        .foregroundColor(.red).opacity(0.8)
//                    
                    
                    
                    
                    TextEditor(text: $inputText_lisk) //.constant("行動したくない理由\n行動を阻むもの"))
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .focused($focused_2)
                        .foregroundColor(Color("reaseon"))
                    
                    //                .border(Color.black)
                        .padding(.vertical, 2)
                        .padding(.horizontal)
                        .frame(height: 80)
                        .overlay {
                            Rectangle()
                                .stroke(Color("reaseon").opacity(0.8), style: StrokeStyle(lineWidth: 1, dash: [5, 2]))
                                .padding(.vertical, 3)
                                .padding(.horizontal)
                        }
                    //                .ignoresSafeArea()
                    
                }
                .offset(y: showFields ? 0 : moveL)
                .opacity(showFields ? 1 : 0)
                .onTapGesture {
                    
                }
                
            }
            
            .background(.white)
            .onTapGesture {
                
          
                
                withAnimation{
                    focused_1 = false
                    focused_2 = false
                    
                    if showBenefitImage == false {
                        showFields.toggle()
                        showFields_stored = showFields
                    }
                    showBenefitImage = false
                }
                
            }
            .onAppear {
                showFields = showFields_stored
            }
        }
//        .frame(maxHeight: .infinity)
//        .background(.red)
    }
}

//#Preview {
////    ImmersionScreen()
//}


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
    
    
//    @Binding var focused : Bool
    
//    var myItems = try modelContext.fetch(FetchDescriptor<Item>())
    
    func filteredItems() -> [Item] {
        return items.compactMap { item in
//            return (item.stepNumber == 1 && !item.continuing) ? item : nil
            return (item.inImmersion == true  && !item.continuing) ? item : nil
        }
    }

    let space : CGFloat = 10
    
    let key1 = "title"
    let key2 = "catIndex"
    
//    func fetchTodayItems_cur() -> [String] {
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
//        return strs
//    }
    

    func fetchTodayItems() -> [[String : Any]] {
        var descriptor = FetchDescriptor<Item>()
        var items = [[String : Any]]()
        
        descriptor.predicate = #Predicate { item in
            
//            item.stepNumber == 1
            item.inImmersion == true
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
        
        GeometryReader{ geo in
            VStack(alignment: .center, spacing: space) {
                Spacer()
                
                switch filteredItems().count {
                case 1:
                    HStack {
                        Spacer()
                        ItemRectView(item: filteredItems()[0], count: filteredItems().count, index: 0)
                        Spacer()
                    }
                case 2:
                    HStack(spacing: space) {
                        Spacer()
                        ItemRectView(item: filteredItems()[0], count: filteredItems().count, index: 0)
                        ItemRectView(item: filteredItems()[1], count: filteredItems().count, index: 1)
                        Spacer()
                    }
                    
//                    .background(.blue)
                case 3:
                    
                    VStack(alignment: .center, spacing: space)  {
                        ItemRectView(item: filteredItems()[0], count: filteredItems().count, index: 0)
                        
                        HStack(spacing: 10) {
                            Spacer()
                            ItemRectView(item: filteredItems()[1], count: filteredItems().count, index: 1)
                            ItemRectView(item: filteredItems()[2], count: filteredItems().count, index: 2)
                            Spacer()
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//                    .background(.blue)
                case 4:
                    VStack(spacing: space)  {
                        HStack(spacing: space) {
                            Spacer()
                            ItemRectView(item: filteredItems()[0], count: filteredItems().count, index: 0)
                            ItemRectView(item: filteredItems()[1], count: filteredItems().count, index: 1)
                            Spacer()
                        }
                        HStack(spacing: space) {
                            Spacer()
                            ItemRectView(item: filteredItems()[2], count: filteredItems().count, index: 2)
                            ItemRectView(item: filteredItems()[3], count: filteredItems().count, index: 3)
                            Spacer()
                        }
                    }
                default:
                    VStack {
                        Text("no item")
                            .padding(10)
                            .background(.yellow)
                 
//                            .multilineTextAlignment(.center)
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
              
                }
                Spacer()
                
            }
//            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//            .background(.red)
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
        
}





//extension GeometryProxy {
//    // converts from some other coordinate space to the proxy's own
//    func convert(_ point: CGPoint, from coordinateSpace: CoordinateSpace) -> CGPoint {
//        let frame = self.frame(in: coordinateSpace)
//        let localViewPoint = CGPoint(x: point.x-frame.origin.x, y: point.y-frame.origin.y)
//        
//        // Some system bug? Test in iOS 13.4, 13.5, 14.1, 14.5
//        if coordinateSpace == .global {
//            switch (UIDevice.current.systemVersion as NSString).floatValue {
//            case 13.5:
//                return CGPoint(x: localViewPoint.x, y: point.y)
//            case 14.5:
//                return point
//            default: break
//            }
//        }
//        
//        return localViewPoint
//    }
//}

struct ItemRectView: View {
    

//    var rectCenter : CGPoint
    

    var lengthes : [CGFloat] = [200, 150, 130, 120]
    
    var item : Item
    var count = 1
    
    var index : Int
    
    @State var showItemDetailScreen = false
    
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    
    

//    @Binding var focused : Bool
    

    @State var posDiff = CGPoint.zero
    @State var dragStart = false
        
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                
                if !dragStart {
                    posDiff = CGPoint(x: value.startLocation.x - (item.benefitListPosX ?? defaultPos(index).x), y: value.startLocation.y - (item.benefitListPosY ?? defaultPos(index).y))
                    dragStart = true
                }
                
                item.benefitListPosX =
                value.startLocation.x
                + value.translation.width
                - posDiff.x
                
                
                item.benefitListPosY =
                value.startLocation.y
                + value.translation.height
                - posDiff.y
                
         
                //-64, 80
                //41, 190
                //128, 195
                
               
                

                
            }
            .onEnded { value in
                
                
                //                item.posX =
                //                value.startLocation.x
                //                + value.translation.width
                //                - posDiff.x
                //
                //                item.posY =
                //                value.startLocation.y
                //                + value.translation.height
                //                - posDiff.y
                //
                dragStart = false
                
                
            }
    }

//    struct ContentView : View {
//        var body: some View {
//            GeometryReader { geometry -> Text in
//                let frame = geometry.frame(in: CoordinateSpace.global)
//                return Text("\(frame.origin.x), \(frame.origin.y), \(frame.size.width), \(frame.size.height)")
//            }
//        }
//    }
    
    @AppStorage(KeyString.countUpdateDateStr.rawValue) var countUpdateDateStr = ""
    @State var showAlert = false
    
//    func saveCountUpdateDateStr() {
//        countUpdateDateStr = dateToString(date: Date(), format: dateFormatStr)
//    }
    
    @Query (
        sort: [
            SortDescriptor(\Step.index, order: .forward)
        ]
    ) var steps: [Step]
    
    func isChecked() -> Bool {
        return item.goalCount ?? 0 > 0 && item.todayCount ?? 0 >= calcTodayGoal(item: item, steps: steps) || (item.goalCount ?? 0 == 0 && item.todayCount ?? 0 >= 1)
    }
    
    var body: some View {
    
//        GeometryReader { geo in
            
            ZStack {
                
                GeometryReader { geometry in
//                    let frame = geometry.frame(in: CoordinateSpace.global)
                    
       
                    Rectangle()
                        .fill(colors[item.catIndex])
                        .frame(width: lengthes[count-1], height: lengthes[count-1])
                        .overlay {
                            Text(item.title)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 20)
                                .foregroundStyle(.white)
                                .font(Font.system(size: 24).bold())
                                .minimumScaleFactor(0.1)
                                .multilineTextAlignment(.center)
                   
                        }
                    
                    
                    
                    //
                    //                    BenefitView(item: item, rectCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2))
                    BenefitView(item: item, index: index)
                        .zIndex(10)
                        .position(x: item.benefitListPosX ?? defaultPos(index).x, y: item.benefitListPosY ?? defaultPos(index).y)
                        .gesture(drag)
                        .onTapGesture {
                            
                        }
                    
                    LineView(item: item, 
                             startPos:
                                CGPoint(x: item.benefitListPosX ?? defaultPos(index).x, y: 0),
                             
                             endPos:
                                CGPoint(x: geometry.frame(in: CoordinateSpace.local).midX, y: geometry.frame(in: CoordinateSpace.local).midY),
                             index: index
                    )
                    .zIndex(-2)
                    
                    
                    
            
//                    )
                }
                
                 
                VStack(alignment: .trailing) {
                    Button(action: {
                        showAlert = true
                    }, label: {
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("\(item.count ?? 0)")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        
                            if item.goalCount != 0 {
                                Text("/ "+String(item.goalCount ?? 0))
                                    .foregroundStyle(.white).opacity(0.8)
                                    .font(.system(size: 11))
                            }
                        }
                        .offset(x: -6, y: 3)
               
                        
         
                    })
                    .alert("達成数", isPresented: $showAlert) {
                        
                        Button("カウントアップ", role: .none) {
                            withAnimation {

                                if item.count == nil {
                                    item.count = 0
                                }
                                
                                item.count? += 1

                                vivrate()
                                
                                if item.todayCount == nil {
                                    item.todayCount = 0
                                }
                                
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

                        if item.count! > 0 {
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
                .frame(width: lengthes[count-1], height: lengthes[count-1], alignment: .trailing)
//                .background(.gray)
                
                
                //        if item.stepNumber == 1 {
                VStack {
                    Image(systemName: iconNames_1[icon_1])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                        .padding(.top, 5)
                        .foregroundColor(.white)
                    Spacer()
                    if item.phases.count > 0 {
                        Image(systemName: phaseImageName)
                            .resizable()
                            .frame(width: 15, height: 2)
                            .padding(.bottom, 7)
                            .foregroundColor(item.stepNumber == 1 ? .white : colorForIndex(item.catIndex))
                            .opacity(0.7)
                    }
                    
                }
                .frame(width: lengthes[count-1], height: lengthes[count-1])
                //        }
                
                VStack {
//                    if (item.todayCount != nil && item.todayCount! >= item.goalCount ?? 0) {
//                    if (item.todayCount ?? 0 >= calcTodayGoal(item: item, steps: steps)) {
           
                    Image(systemName: isChecked() ? "checkmark.circle.fill" : "circle.dashed")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 17)
                        .padding(.top, 5)
                        .padding(.leading, 5)
                        .foregroundColor(isChecked() ? .white : .gray)
                        .opacity(isChecked() ? 1.0 : 0.7)
//                            .offset(x: 7, y: 1)
                    
       
                    Spacer()
                    
                    
                }
                .frame(width: lengthes[count-1], height: lengthes[count-1], alignment: .leading)
//                .background(.blue)
                
            }
            .onTapGesture {
                showItemDetailScreen = true
                
                
            }
            .sheet(isPresented: $showItemDetailScreen) {
                ItemDetailScreen(item: item)
            }
            .frame(width: lengthes[count-1], height: lengthes[count-1])
            .background(.red)
//            .overlay {
//                //                        BenefitView(item: item, rectCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2))
//                //
//                BenefitView(item: item, rectCenter: CGPoint(x: 500, y: 0))
//                    .zIndex(10)
//                    .offset(x: item.benefitListPosX ?? defaultPos(index).x, y: item.benefitListPosY ?? defaultPos(index).y)
//                    .gesture(drag)
//                    .onTapGesture {
//                        //
//                    }
//                
//            }
            
//        }
       
        
        
    }
}

struct LineView: View {
    
    var item : Item
    
    var startPos : CGPoint
    var endPos : CGPoint
    
    var index: Int
    
    
    
    var body: some View {
        
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 
                                        startPos.x, 
                                      y: (item.benefitListPosY == nil && defaultPos(index).y > 0) ||  (item.benefitListPosY! > 0) ?
                                      (item.benefitListPosY ?? defaultPos(index).y) - editorHeight/2 + 2 : (item.benefitListPosY ?? defaultPos(index).y) + editorHeight/2 - 2)
                           
                          
                   
                )
                
                // 始点移動
                //                    path.addLine(to: CGPoint(x: 0, y: 0))   // 直線描画
                
                //                    let globalCenter = geometry.frame(in: .global).center
                //                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))   // 直線描画
                path.addLine(to: endPos)   // 直線描画
                
                //                    CGPoint(x: geometry.frame(in: CoordinateSpace.global).midX, y: geometry.frame(in: CoordinateSpace.global).midY)
            }
            .stroke(colorForIndex(item.catIndex), lineWidth: 2)
            .overlay {
//                Text("\(rectCenter.x),\(rectCenter.y)")
            }
        }
     
    }
    
}


let editorHeight : CGFloat = 50

struct BenefitView: View  {
    
    var item: Item
    var index: Int
//    var rectCenter : CGPoint
    
//    @FocusState private var focusedField: Bool
//    @Binding var focused : Bool
    
    init(item: Item, index: Int) {
        if item.benefitListPosY == nil {
            item.benefitListPosY = defaultPos(index).y
        }
        
        if item.benefitListPosX == nil {
            item.benefitListPosX = defaultPos(index).x
        }
        self.item = item
        self.index = index
//        self.focused = focused
//        self.focusedField = focusedField
    }
    
    @State var showEditBenefitScreen = false
    
    @AppStorage(KeyString.icon_3.rawValue) var icon_3 : Int = 0

    
    var body: some View {
        
        VStack(spacing: 4) {

            if (item.benefitListPosY == nil && defaultPos(index).y > 0) ||  (item.benefitListPosY! > 0) {
                    
                    Capsule()
                        .fill(colorForIndex(item.catIndex))
                        .frame(width: 60, height: 20)
                        .padding(0)
                        .overlay(
                            
                            HStack(spacing: 4) {
                                Image(systemName: iconNames_3[icon_3])
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.white)
                                
                                Text("快楽")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                
                                
                                
                            }
                            
                         
                        )
                    
    
                    
                    ScrollView {
                    
//                            Spacer()
             
                            Text(item.benefitList ?? "それをやることの快楽")
                                .padding(5)
                            //                                .frame(alignment: .bottom)
                            //                                .background(.red)
                        
                         
                            
                        
                
           
                    }
                    .multilineTextAlignment(.center)
                    .frame(width: 150, height: editorHeight)
                    //                    .frame(width: 150)
                    .font(.system(size: 12))
                    .foregroundColor(colorForIndex(item.catIndex))
                    .background {
                        colorForIndex(item.catIndex).opacity(0.08)
                    }
                    .onTapGesture {
                        showEditBenefitScreen = true
                    }
                    .sheet(isPresented: $showEditBenefitScreen)
                    {
                        EditBenefitScreen(item: item)
                    }
                    
                
                
                
            
                
                
                  
                
//                    TextEditor(text: Binding(get: {
//                        withAnimation {
//                            item.benefitList ?? "それをやることの快楽"
//                        }
//                    }, set: { (newVal) in
//                        withAnimation {
//                            item.benefitList = newVal
//                        }
//                    }))
//                    .multilineTextAlignment(.center)
//                    .frame(width: 150, height: editorHeight)
//                    .font(.system(size: 12))
//                    .foregroundColor(colorForIndex(item.catIndex))
//                    .scrollContentBackground(Visibility.hidden)
//                    .padding(0)
//                    .background {
//                        colorForIndex(item.catIndex).opacity(0.08)
//                    }
                     
                } else {
                    

                    
                        ScrollView {
                            
                        
                                Text(item.benefitList ?? "それをやることの快楽")
                                    .padding(5)
                            
                            
                          
                            //                                    .frame(alignment: .bottom)
                            //                                    .background(.red)
                            
                            
                            
                            
                        }
                        .multilineTextAlignment(.center)
                        .frame(width: 150, height: editorHeight)
                        //                    .frame(width: 150)
                        .font(.system(size: 12))
                        .foregroundColor(colorForIndex(item.catIndex))
                        .background {
                            colorForIndex(item.catIndex).opacity(0.08)
                        }
                        .onTapGesture {
                            showEditBenefitScreen = true
                        }
                        .sheet(isPresented: $showEditBenefitScreen)
                        {
                            EditBenefitScreen(item: item)
                        }
                    
                     
                        
                    
               
                    
                    
//                    TextEditor(text: Binding(get: {
//                        withAnimation {
//                            item.benefitList ?? "それをやることの快楽"
//                        }
//                    }, set: { (newVal) in
//                        withAnimation {
//                            item.benefitList = newVal
//                        }
//                    }))
//                    .multilineTextAlignment(.center)
//                    .frame(width: 150, height: editorHeight)
//                    .font(.system(size: 12))
//                    .foregroundColor(colorForIndex(item.catIndex))
//                    .scrollContentBackground(Visibility.hidden)
//                    .padding(0)
//                    .background {
//                        colorForIndex(item.catIndex).opacity(0.08)
//                    }
                    
                    Capsule()
                        .fill(colorForIndex(item.catIndex))
                        .frame(width: 60, height: 20)
                        .padding(0)
                        .overlay(
                            
                            HStack(spacing: 4) {
                                Image(systemName: iconNames_3[icon_3])
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.white)
                                
                                Text("快楽")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                
                                
                                
                            }
                            
                            
                        )
                    
                }
        }
    }
    
}



/* ----------------------------------------------------------------------------
 MARK: - EditBenefitScreen
 ------------------------------------------------------------------------------*/


struct EditBenefitScreen: View  {
    
    var item: Item
    
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
 
                TextEditor(text: Binding(get: {
                    withAnimation {
                        item.benefitList ?? "それをやることの快楽"
                    }
                }, set: { (newVal) in
                    withAnimation {
                        item.benefitList = newVal
                    }
                }))
                .multilineTextAlignment(.center)
                .frame(height: 300)

                .foregroundColor(colorForIndex(item.catIndex))
                .scrollContentBackground(Visibility.hidden)
                .padding(.vertical, 5)
//                .padding(.vertical, 2)

                .background {
                    colorForIndex(item.catIndex).opacity(0.08)
                }
                
                Spacer()
                
            }
            .navigationTitle(item.title)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,20)
      
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

            
            
        }
        .padding(.horizontal, 5)
        .onAppear {
            makeDays()
        }
        
    }
}


