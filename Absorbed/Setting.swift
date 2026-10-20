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
    //                   "exclamationmark.circle",
    "exclamationmark.circle.fill",
    "bolt.badge.xmark",
    "xmark.seal.fill",
]


struct SettingScreen: View {
    
   
    @AppStorage(KeyString.icon_1.rawValue) var icon_1 : Int = 0
    @AppStorage(KeyString.icon_2.rawValue) var icon_2 : Int = 0
    @AppStorage(KeyString.icon_3.rawValue) var icon_3 : Int = 0
    @AppStorage(KeyString.icon_4.rawValue) var icon_4 : Int = 0
        
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    if let url = URL(string: "http://btw.html.xdomain.jp/app_manuals/Dreamer.pages.pdf") {
                        Link("チュートリアル", destination: url)
                    }
                    
                }
            
                
                Section {
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
