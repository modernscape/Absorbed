//
//  Setting.swift
//  Immersion
//
//  Created by forest on 2024/02/08.
//

import SwiftUI


let pickerNames = ["ビジョン", "ボード", "ステップ"]
let screenTitles = ["やりたいこと／やりたくないこと", "ボード", "ステップ"]

// 没入
let iconNames_1 = [
    "circle.dotted.circle",
    "livephoto",
    "aqi.medium",
    "rays",
    "circle.dotted.and.circle",
    "eye.circle",
    "circle.dashed.inset.filled",
    "target"
]

// 俯瞰
let iconNames_2 = [
    "rotate.3d.fill", 
    "skew",
    //                   "lightspectrum.horizontal",
    "squareshape.squareshape.dotted",
    "rectangle.3.group",
    "square.on.square.squareshape.controlhandles",
    "square.stack.3d.down.forward",
    "square.stack.3d.forward.dottedline.fill",
    "camera.filters",
    
    "cube.transparent.fill",
    "square.stack.3d.up",
    "applepencil.and.scribble",
    "pencil.and.outline",
]

// やりたいこと
let iconNames_3 = [
    "fireworks",
    "flame",
    "flame.circle.fill",
    "bolt.fill",
    "bolt.circle.fill",
    "checkmark.seal",
]

// やりたくないこと
let iconNames_4 = [
    "nosign",
    "nosign.app.fill",
    "exclamationmark.triangle.fill",
    "exclamationmark.octagon",
    "exclamationmark.circle.fill",
    "bolt.badge.xmark",
    "xmark.seal.fill",
]


// 障害
let iconNames_5 = [
    "cloud.heavyrain.fill",
    "cloud.sleet.circle",
    "poweroutlet.type.i.fill",
    "figure.fall.circle.fill",
    "figure.fall.circle",
    "figure.fall",

]






let imgSizeStrs = ["1", "2", "3", "4"]
let imgSizes : [CGFloat] = [40, 50, 65, 80]

struct SettingScreen: View {
    
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    @AppStorage(KeyString.icon_2.rawValue) var icon_2 : Int = 4
    @AppStorage(KeyString.icon_3.rawValue) var icon_3 : Int = 0
    @AppStorage(KeyString.icon_4.rawValue) var icon_4 : Int = 0
    @AppStorage(KeyString.autoAlignViews.rawValue) var autoAlignViews : Bool = true
    @AppStorage(KeyString.imgSizeIndex.rawValue) var imgSizeIndex : Int = 0
    
    @State private var isToggleOn = false
    
    @State var showDreamView = false
        
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    Text("夢を決める")
                        .bold()
                        .onTapGesture {
                            showDreamView = true
                        }
                        .sheet(isPresented: $showDreamView) {
                            DreamView()
                        }
                }
                
                Section {
                    if let url = URL(string: "http://cf549269.cloudfree.jp/app_manuals/Dreamer.pdf") {
                        Link("チュートリアル", destination: url)
                    }
                }
                
                Section {
                    if let url = URL(string: "https://apps.apple.com/jp/app/dreamer/id6477915849?action=write-review") {
                        Link("App Storeで評価", destination: url)
                    }
                }
            
                Section(header: Text("アイコン設定")) {
                    VStack(alignment: .leading) {
                        Text("「没入」アイコン")
                        
                        Picker("want", selection: $icon_1) {
                            
                            
                            ForEach(Array(iconNames_1.enumerated()), id: \.element) { index, str in
                                // View
                                Image(systemName: str)
                                //                        Text(str)
                                    .tag(index)
                            }
                            
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("「俯瞰」アイコン")
                        
                        Picker("want", selection: $icon_2) {
                            
                            
                            ForEach(Array(iconNames_2.enumerated()), id: \.element) { index, str in
                                // View
                                Image(systemName: str)
                                //                        Text(str)
                                    .tag(index)
                            }
                            
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("「やりたいこと」アイコン")
                        
                        Picker("want", selection: $icon_3) {
                            
                            
                            ForEach(Array(iconNames_3.enumerated()), id: \.element) { index, str in
                                // View
                                Image(systemName: str)
                                //                        Text(str)
                                    .tag(index)
                            }
                            
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("「やりたくないこと」アイコン")
                        
                        Picker("want", selection: $icon_4) {
                            
                            
                            ForEach(Array(iconNames_4.enumerated()), id: \.element) { index, str in
                                // View
                                Image(systemName: str)
                                //                        Text(str)
                                    .tag(index)
                            }
                            
                        }
                        .pickerStyle(.segmented)
                    }
                    
                }

                Section(header: Text("その他設定")) {
                    VStack(alignment: .leading) {
//                        Text("画面表示時")
//                            .font(.system(size: 12))
//                            .foregroundStyle(.gray)
//                            .padding(0)
                        Toggle("自動整列（画面表示時）", isOn: $autoAlignViews)
                        

                    }
                    
//                    HStack {
//                        Picker("", selection: Binding(get: {
//                            imgSizeIndex
//                        }, set: { (newVal) in
//                            withAnimation {
//                                imgSizeIndex = newVal
//                                print(newVal)
//                            }
//                        })) {
//                            
//                           
//                            ForEach(Array(imgStrs.enumerated()), id: \.element) { index, elm in
//                                HStack {
//                                    Text(elm)
//                                        .tag(index)
//                                }
//                            }
//                           
//                        }
//                        .pickerStyle(.segmented)
//                        .padding(.vertical, 3)
//                        
//                    }
                    
                    VStack(alignment: .leading) {
                        Text("夢画像サイズ")
                        HStack {
                            Picker("", selection: Binding(get: {
                                imgSizeIndex
                            }, set: { (newVal) in
                                withAnimation {
                                    imgSizeIndex = newVal
//                                    print(newVal)
                                }
                            })) {
                    
                                
                                Text(imgSizeStrs[0])
                                    .tag(0)
                                
                                Text(imgSizeStrs[1])
                                    .tag(1)
                                
                                Text(imgSizeStrs[2])
                                    .tag(2)
                                
                                Text(imgSizeStrs[3])
                                    .tag(3)
                            }
                            .pickerStyle(.segmented)
                            .padding(.vertical, 3)
                            
                        }
                        
                    }
         
                }
  
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                /// ナビゲーションバー左
                ToolbarItem(placement: .navigationBarLeading){
                    HStack(spacing: 0) {
                        Button(action: {
                  
                            
                        }) {
//                            Image(systemName: "plus")
                        }
                        
                        
                    }
                    
                    
                }
                
                /// ナビゲーションバー右１
                ToolbarItem(placement: .navigationBarTrailing){
//                    EditButton()
                    
                       }
                    
                }
                
            }
        }
 
    
}

#Preview {
    SettingScreen()
}
