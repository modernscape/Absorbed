//
//  ContentView.swift
//  Immersion
//
//  Created by forest on 2024/01/15.
//

import SwiftUI
import SwiftData

let _ud = UserDefaults.standard
//@ObservedObject var categories = Categorys()


/* ----------------------------------------------------------------------------
 MARK: - Watcht連携
 ------------------------------------------------------------------------------*/

import UIKit
//import WatchConnectivity



class ShareData : ObservableObject {
    @Published var selectedCatView : CategoryView! = nil
    @Published var selectedItemView : ItemView! = nil
    
    func resetSelection() {
        if selectedCatView != nil {
            selectedCatView.isSelected = false
            selectedCatView = nil
        }
        if selectedItemView != nil {
            selectedItemView.isSelected = false
            selectedItemView = nil
        }

    }
//    @Published var todayItems : [Item] = []
//    @Published var itemsForCategory = ItemsForCategory()
    
  

}

//var selectedCatView : CategoryView!
//var setData.setData.selectedCatView : ItemView!


enum KeyString: String {
    case category_pos
    case category_length
    case wantsMaken
    case kewordsMaken
    case stepsMaken
    case dislikesMaken
    case categoriesMaken
    case itemsMaken
    case inputText_hindrance
    case inputText_lisk
    case startDay
    case phasesMaken
    case moveLocked
    case moveLocked_item
    case todayItems
    case icon_1
    case icon_2
    case icon_3
    case icon_4
    case selectionTab
    case selectedPicker
    case numOfTodayItems
    case magnifyBy
    case aligned
    case autoAlignViews
    case showFields
    case stepScreenB
    case dreamStr
    case dreamLimitStr
    case birthDayStr
    case age
    case nowAge
    case imgData
    case imgSizeIndex
    case selectedViewPicker
    case countUpdateDateStr
    case tutorialShown
    case dreamViewShown
    
    case camera_posX
    case camera_posY
    case camera_posZ
    case camera_rotX
    case camera_rotY
    case camera_rotZ
    case camera_rotW
    // camera
    case focalLength
    case fieldOfView
    
    case taskViewHiddenDateStr
    
    
    
    
//    case angle
//    case axisX
//    case axisY
//    case axisZ
//    case anchorZ
//    case perspective
    
}




//let iconName_2 = iconNames_2[Int.random(in: 0..<iconNames_2.count)]

//let iconName_2 = "network"


//let pickerName_1 = "Board"
//let pickerName_2 = "Steps"

let pickerItemCount = 3

let colors : [Color] = [Color("color_2"), .green, .yellow, .blue, .mint, .cyan,
                        .purple, .brown, .orange, .indigo, .teal, .gray]

//　初期item
//let item_00 = Item(title: "投資", posX :232, posY: 63, length: 90, stepNumber: 1, hasPhase: true)
//let item_01 = Item(title: "起業", posX :139, posY: 89, length: 50)
//let item_02 = Item(title: "CW", posX :203, posY: 158, length: 65, stepNumber: 2)
//
//
//let item_10 = Item(title: "Shader", posX :232, posY: 63, length: 80, stepNumber: 1, hasPhase: true)
//let item_11 = Item(title: "建築", posX :140, posY: 90, length: 50, stepNumber: 4)
//let item_12 = Item(title: "アプリ", posX :200, posY: 160, length: 65)
//
//let item_20 = Item(title: "食事", posX :255, posY: 70, length: 80)
//let item_21 = Item(title: "テニス", posX :202, posY: 157, length: 50, stepNumber: 3)
//let item_22 = Item(title: "筋トレ", posX :122, posY: 95, length: 85, stepNumber: 1, hasPhase: true)


// 初期category
//let cat0 = Category(title: "お金", posX: 100, posY: 100, length: 200, index: 0, items: [item_00, item_01, item_02])
//let cat1 = Category(title: "ライフワーク", posX: 100, posY: 100, length: 200, index: 1, items: [item_10, item_11, item_12])
//let cat2 = Category(title: "健康", posX: 100, posY: 100, length: 250, index: 2, items: [item_20, item_21, item_22])


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
//    @Query private var cats: [Cat]
    
    @EnvironmentObject var setData : ShareData
    
    
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "color_1")
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
//    func makeDefaultCategoriesData() {
//        categoryData.categories.append(cat0)
//        categoryData.categories.append(cat1)
//        categoryData.categories.append(cat2)
//    }
//    
    

    @AppStorage(KeyString.selectionTab.rawValue) var selectionTab : Int = 0
    @AppStorage(KeyString.selectedPicker.rawValue) var selectedPicker : Int = 0
    
    
    
    
    
//    @State var selection = 0
//    @State var selectedPicker = 1

    
    @State var showMenu = false
    @State var showMenu_forItem = false
    
    // 定数
    let animDur = 0.0
        
    @State var opacity_wantA : Double = 0
    @State var opacity_wantB : Double = 0
    
    
//    private let viewModel = WatchConnectViewModel()
//    @ObservedObject var viewModel = WatchConnectViewModel()
    
//    private let langs = ["Swift", "Kotlin", "Objective-C", "Java", "Dart"]

    

    
    
//    func makeDefaultItems() {
//        
//        let ary = [
////            item_00,
//            item_01,
//            item_02,
////            item_10,
//            item_11,
//            item_12,
//            item_20,
//            item_21,
////            item_22
//        ]
//        
//        for i in 0..<ary.count {
//            let item = ary[i]
//            modelContext.insert(item)
//        }
//    }
//    
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    @AppStorage(KeyString.icon_2.rawValue) var icon_2 : Int = 4
    

    @AppStorage(KeyString.tutorialShown.rawValue) var showTutorial = false
    @AppStorage(KeyString.dreamViewShown.rawValue) var dreamViewShown = true
    
//    @State var showTutorial = true
    
    var body: some View {
        
        TabView(selection: $selectionTab) {
            
            /* ----------------------------------------------------------------------------
             MARK: - 没入
             ------------------------------------------------------------------------------*/


//            VolumeView()
            
            
            SceneScreen()
  
            
            
//            ImmersionScreen()
            
                .tabItem {
                    Label("没入", systemImage: iconNames_1[icon_1])
                }
                .tag(0)
            
            
            /* ----------------------------------------------------------------------------
             MARK: - 俯瞰
             ------------------------------------------------------------------------------*/
            VStack {
                
                switch selectedPicker {
                case 0:
                    IntentionScreen()
                case 1:
                    BoardScreen()
                case 2:
                    StepsScreen(forAddItem: false)
                default:
                    Text("")
                }
                
                HStack {
                    Picker("want", selection: $selectedPicker) {
                        Text(pickerNames[0])
                            .tag(0)

                        Text(pickerNames[1])
                            .tag(1)
                        
                        Text(pickerNames[2])
                            .tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding([.bottom, .horizontal])
                    
                }
                
            }
            .animation(.easeIn, value: selectedPicker)
            .tabItem {
//                Label("俯瞰", systemImage: "rectangle.3.group")
//                Label("俯瞰", systemImage: "eye")
                Label("俯瞰", systemImage: iconNames_2[icon_2])
            }
            .tag(1)
            
        }
        .onAppear {
//            _ud.removeObject(forKey: KeyString.tutorialShown.rawValue)
//            _ud.removeObject(forKey: KeyString.dreamViewShown.rawValue)
        }
        .sheet(isPresented: Binding(get: {
            dreamViewShown
        }, set: { (newVal) in
            dreamViewShown = newVal
        }), onDismiss: {
            showTutorial = true
        }) {
            DreamView()
        }
        .alert("アプリの使い方を見る",isPresented: Binding(get: {
            showTutorial
//            dreamViewShown
        }, set: { (newVal) in
         

        }))
        {

//            DreamIView()
            
            Button("見る", role: .cancel, action: {
                if let url = URL(string: "http://cf549269.cloudfree.jp/app_manuals/Dreamer.pdf") {
                    UIApplication.shared.open(url)
                    
                }
                showTutorial = false
            })
            
            Button("今は見ない", role: .none, action: {
                showTutorial = false

            })
            
        } message: {
                Text("設定画面からいつでも見られます\n\n（俯瞰タブ＞ビジョン＞左上「設定」ボタン＞チュートリアル）")
        }

        
    }

}

//struct MagnificationGestureView: View {
//    
//    @GestureState var magnifyBy = 1.0
//    
//    var magnification: some Gesture {
//        MagnificationGesture()
//            .updating($magnifyBy) { currentState, gestureState, transaction in
//                gestureState = currentState
//            }
//    }
//    
//    var body: some View {
//        Circle()
//            .frame(width: 100, height: 100)
//            .scaleEffect(magnifyBy)
//            .gesture(magnification)
//    }
//}
//


#Preview {
    ContentView()
}






//struct PhaseView: View {
//    
//    var body: some View {
//        Text(itemPickerName_2)
//    }
//    
//}
//
