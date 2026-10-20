//
//  ContentView.swift
//  Immersion Watch App
//
//  Created by forest on 2024/01/15.
//

import SwiftUI
import SwiftData
import UIKit
import WatchConnectivity


let colors : [Color] = [Color("color_2"), .green, .yellow, .blue, .mint, .cyan,
                        .purple, .brown, .orange, .indigo, .teal, .gray]


let todayImageName = "flame"


enum KeyString: String {
    case todayItems
}



struct SelectedItemModel {
//    private(set) var selectedAnimal: String = "🐱"
    private(set) var selectedTitles: [[String : Any]] = []
//    private(set) var selectedWeather: String = "☀️"
//    private(set) var selectedImage: UIImage? = nil
    
//    mutating func changeSelected(animal: String) {
//        selectedAnimal = animal
//    }
    
    mutating func changeSelected(titles: [[String : Any]]) {
        selectedTitles = titles
    }
    
//    mutating func changeSelected(weather: String) {
//        selectedWeather = weather
//    }
//    
//    mutating func changeSelected(image: UIImage?) {
//        selectedImage = image
//    }
}



class iOSConnectViewModel: NSObject, ObservableObject {
    

//    @Published  var titles: [String] = []
//    @Published var todayItems : [Item] = []
    
    @Published var selectedItemModel: SelectedItemModel
    
    
    var session: WCSession = .default
    
    init(selectedItemModel: SelectedItemModel) {
//        self.stateModel = stateModel
        self.selectedItemModel = selectedItemModel
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    
    
    
//    var session: WCSession
//    init(session: WCSession = .default) {
//        self.session = session
////        super.init()
//        if WCSession.isSupported() {
//            self.session.delegate = self
//            self.session.activate()
//        }
//    }
    
    var selectedFruit: [[String : Any]] {
        get {
            return selectedItemModel.selectedTitles
        }
        set {
            selectedItemModel.changeSelected(titles: newValue)
        }
    }
    
//    func send(lang: String) {
//        let langDic: [String: String] = ["lang": lang]
//        self.session.sendMessage(langDic) { error in
//            print(error)
//        }
//    }
//    


}


extension iOSConnectViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("セッション：アクティベート")
        }
    }
    

    
    internal func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [self] in
            self.selectedItemModel.changeSelected(titles: applicationContext["items"] as? [[String : Any]] ?? [])
//            print(self.selectedItemModel.selectedFruit)
        }
    }
    
    

    
    
    
}






struct ContentView: View {
    

//    @StateObject var viewModel = iOSConnectViewModel()
//    @ObservedObject var viewModel = iOSConnectViewModel(selectedItemModel: SelectedItemModel())
    @StateObject var viewModel = iOSConnectViewModel(selectedItemModel: SelectedItemModel())
    

    
    
    @State var isConnect = false
    

    
    let space : CGFloat = 10
    


    let key1 = "title"
    let key2 = "catIndex"
    
    var body: some View {
        

        
//        if viewModel.selectedFruit.count == 0 {
//            Text("no item")
//        } else {
//            List {
//                ForEach(viewModel.selectedFruit, id: \.self) { item in
//                    Text(item)
//                }
//                
//                
//            }
//            
//        }
            
            
            
   
            
          
        GeometryReader { g in
            
            VStack {
                
                switch viewModel.selectedFruit.count {
                    //        switch ["創始","水泳","Shader"].count {
                case 1:
                    ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[0][key1] as! String, catIndex: viewModel.selectedFruit[0][key2] as! Int, count: 1)
                    
                case 2:
                    HStack(spacing: space) {
                        
                        ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[0][key1] as! String, catIndex: viewModel.selectedFruit[0][key2] as! Int, count: 2)
                        ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[1][key1] as! String, catIndex: viewModel.selectedFruit[1][key2] as! Int, count: 2)
                        
                      
                    }
                case 3:
                    VStack(spacing: 20)  {
                        ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[0][key1] as! String, catIndex: viewModel.selectedFruit[0][key2] as! Int, count: 3)
                        
                        HStack(spacing: 20) {
                            ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[1][key1] as! String, catIndex: viewModel.selectedFruit[1][key2] as! Int, count: 3)
                            ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[2][key1] as! String, catIndex: viewModel.selectedFruit[2][key2] as! Int, count: 3)
                            
                 
                        }
                    }
                case 4:
                    VStack(spacing: space)  {
                        HStack(spacing: space) {
                            ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[0][key1] as! String, catIndex: viewModel.selectedFruit[0][key2] as! Int, count: 4)
                            ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[1][key1] as! String, catIndex: viewModel.selectedFruit[1][key2] as! Int, count: 4)
                     
                        }
                        HStack(spacing: space) {
                            ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[2][key1] as! String, catIndex: viewModel.selectedFruit[2][key2] as! Int, count: 4)
                            ItemRectView(screenWidth: g.size.width, title: viewModel.selectedFruit[3][key1] as! String, catIndex: viewModel.selectedFruit[3][key2] as! Int, count: 4)
                            
                          
                        }
                    }
                default:
                    Text(viewModel.session.isReachable ? "接続中" : "未接続")
                }
                
            }
            .frame(width: g.size.width, height: g.size.height)
//            .background(.gray)
            .onAppear {
//                viewModel.selectedFruit =  ["投資","水泳","Shader", "パートナー"]
//                viewModel.selectedFruit =  ["投資","水泳","Shader"]
//                viewModel.selectedFruit =  ["投資","水泳"]
//                viewModel.selectedFruit =  ["投資"]
            }
            
            
        }

       
    }
}

#Preview {
    ContentView()
}



struct ItemRectView: View {
    
    var screenWidth : CGFloat = 10
    
    
    var lengthes : [CGFloat] = [0.7, 0.45, 0.35, 0.35]
    
//    var item : Item
    var title : String
    var catIndex : Int
    
    var count = 1
    
    @State var showItemDetailScreen = false
    
    var body: some View {
        

            
            ZStack {
                Rectangle()
                    .fill(colors[catIndex])
//                    .frame(width: lengthes[count-1], height: lengthes[count-1])
//                    .frame(width: screenWidth*0.3, height: screenWidth*0.3)
                    .overlay {
                        Text(title)
                            .foregroundStyle(.white)
                            .font(.system(size: 40*lengthes[count-1]).bold())
                            .minimumScaleFactor(0.1)
                            .frame(width: screenWidth*lengthes[count-1], height: screenWidth*lengthes[count-1])
                    }
                
                VStack {
                    Image(systemName: todayImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24*lengthes[count-1])
                        .padding(.top, 5)
                        .foregroundColor(.white)
                    Spacer()
                }
//                .frame(width: screenWidth*0.3, height: screenWidth*0.3)
//                .frame(width: lengthes[count-1], height: lengthes[count-1])
            }
            .frame(width: screenWidth*lengthes[count-1], height: screenWidth*lengthes[count-1])
//            .background(.gray)
            
            
        
        

        
        
        
//        .onTapGesture {
//            showItemDetailScreen = true
//        }
//        .sheet(isPresented: $showItemDetailScreen) {
//            ItemDetailScreen(item: item)
//        }
//        
        
    }
}



/* ----------------------------------------------------------------------------
 MARK: - iOS連携
 ------------------------------------------------------------------------------*/

//class Item : Identifiable {
//    
//    
//    let id = UUID()
//    var title: String
//    var posX : CGFloat
//    var posY : CGFloat
//    var length: CGFloat
//    var catIndex: Int
//    var stepNumber: Int // 0:Stepに属さない
//    var dislike : Bool
//    var created : Bool
//    var isDone : Bool
//    var hasPhase : Bool
//    var continuing : Bool
//    
//    
//    
//    init(title: String = "", posX: CGFloat = 0, posY: CGFloat = 0, length: CGFloat = 50, catIndex: Int, stepNumber: Int = 0, dislike: Bool = false, focused: Bool = false, isDone: Bool = false, hasPhase : Bool = false, continuing : Bool = false) {
//        self.title = title
//        self.posX = posX
//        self.posY = posY
//        self.length = length
//        self.catIndex = catIndex
//        self.stepNumber = stepNumber
//        self.dislike = dislike
//        self.created = focused
//        self.isDone = isDone
//        self.hasPhase = hasPhase
//        self.continuing = continuing
//    }
//    
//}



