//
//  Want.swift
//  Immersion
//
//  Created by forest on 2024/01/28.
//

import SwiftUI
import SwiftData

let color_OK = Color("want_OK")
let color_NG = Color("want_NG")

// やりたいこと
//let imageNames_1 = ["fireworks",
//                   "flame",
//                   "checkmark.seal",
//                   "bolt.fill"
//]

let laurel_left = "laurel.leading"
let laurel_right = "laurel.trailing"

//let imageName_1 = imageNames_1[Int.random(in: 0..<imageNames_1.count)]


// やりたくないこと
//let imageNames_2 = ["nosign",
//                    "exclamationmark.triangle.fill",
//                    "exclamationmark.octagon",
//                    "exclamationmark.circle"
//]

//let imageName_2 = imageNames_2[Int.random(in: 0..<imageNames_2.count)]


struct IntentionScreen: View {
    
//    @Environment(\.modelContext) var modelContext
//    @Query var wants_new: [Want]
    
    
//    @ObservedObject var wants = Wants() // old
        
//    @FocusState private var isFocused: Bool
    @State private var showSheet = false
    @State private var text = ""
    
    @State var showSetting = false
    
    
    @AppStorage(KeyString.icon_3.rawValue) var icon_3 : Int = 0
    @AppStorage(KeyString.icon_4.rawValue) var icon_4 : Int = 0
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    

//    func makeDefaultWants() {
//        
//        let ary = [
//            Want(title: "お金持ちになる", isWant: true),
//            Want(title: "高い月収", isWant: true),
//            Want(title: "モノを持たない", isWant: true),
//            Want(title: "パートナー", isWant: true),
//            Want(title: "扱う金額の桁を変える", isWant: true),
//            Want(title: "環境の良いところに住む", isWant: true),
//            Want(title: "自分も嬉しい他者も嬉しい", isWant: true),
//            
//            Want(title: "お金に不自由な生活", isWant: false),
//            Want(title: "能力がない", isWant: false),
//            Want(title: "ストレスの多い仕事", isWant: false),
//            Want(title: "単価の安い仕事", isWant: false),
//            Want(title: "不安の多い仕事", isWant: false),
//            Want(title: "ムダな時間があること", isWant: false),
//            Want(title: "要らないモノを持っている", isWant: false),
//            Want(title: "満員電車", isWant: false)
//        
//        ]
//        
//        for i in 0..<ary.count {
//            let item = ary[i]
//            modelContext.insert(item)
//        }
//        
//    }
    
    
//    func makeDefaultKewords() {
//        
//        let ary = [
//            Keyword(title: "貢献", isWant: true),
//            Keyword(title: "シンプルな生き方", isWant: true),
//            Keyword(title: "環境", isWant: true),
//            Keyword(title: "パートナー", isWant: true),
//            Keyword(title: "お金", isWant: true),
//            Keyword(title: "クリエイティブ", isWant: true),
//            Keyword(title: "心身の健康", isWant: true),
//            Keyword(title: "時間", isWant: true),
//            Keyword(title: "単価が高い", isWant: true),
//            
//            Keyword(title: "ストレス", isWant: false),
//            Keyword(title: "低所得", isWant: false),
//            Keyword(title: "不安", isWant: false),
//            Keyword(title: "能力がない", isWant: false),
//            Keyword(title: "単価が低い", isWant: false)
//        ]
//        
//        for i in 0..<ary.count {
//            let item = ary[i]
//            modelContext.insert(item)
//        }
//    }

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                CaptionView(str: "夢、人生でやりたいこと／やりたくないことを自由に書き出そう")
        
                HStack(alignment: .center, spacing: 0) {
                    HalfView(title:"やりたいこと", imageName: iconNames_3[icon_3], isWant: true)
                        .padding(.leading, 2)
                    
                    HalfView(title:"やりたくないこと", imageName: iconNames_4[icon_4], isWant: false)
                        .padding(.trailing, 2)
                }
                .navigationTitle(screenTitles[0])
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    /// ナビゲーションバー左
                    ToolbarItem(placement: .navigationBarLeading) {
                        //                    HStack(spacing: 0) {
                        Button(action: {
                            showSetting = true
                        }) {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                
            }
            .sheet(isPresented: $showSetting) {
                SettingScreen()
            }
            

            
        }
        .onAppear {
            

            
//            if _ud.object(forKey: KeyString.wantsMaken.rawValue) == nil {
//                makeDefaultWants()
//                _ud.setValue("Done", forKey: KeyString.wantsMaken.rawValue)
//            }
//            if _ud.object(forKey: KeyString.kewordsMaken.rawValue) == nil {
//                makeDefaultKewords()
//                _ud.setValue("Done", forKey: KeyString.kewordsMaken.rawValue)
//            }
        }
    }
}


#Preview {
    IntentionScreen()
}


/* ----------------------------------------------------------------------------
 MARK: - Want
 ------------------------------------------------------------------------------*/

@Model
class Want : Identifiable, Equatable {
    
    var id = UUID()
    var title : String
    var isWant : Bool
    var index : Int
    
    init(id: UUID = UUID(), title: String, isWant: Bool, index: Int) {
        self.id = id
        self.title = title
        self.isWant = isWant
        self.index = index
    }
    
    

}





func colorForWant(_ isWant: Bool) -> Color {
    return isWant ? color_OK : color_NG
}


@ViewBuilder
func WantRow(_ want: Want, isWant: Bool) -> some View {
    
    HStack(alignment: .center) {
        
        Spacer()
        
        Text(want.title)
            .foregroundStyle(colorForWant(isWant))
            .padding(.vertical, 3)
            .font(Font.system(size: 14))
            .minimumScaleFactor(0.1)
 

        Spacer()
        
    }
    
}


struct HalfView : View {
    
    @Environment(\.modelContext) private var modelContext
//    @Query var wants: [Want]
    @Query var keywords: [Keyword]
    
    @Query (
        sort: [
            SortDescriptor(\Want.index, order: .forward)
//            SortDescriptor(\Step.date, order: .forward)
        ]
    ) var wants: [Want]
    
    @State var wantAry : [Want] = []
    
    
//    struct HalfView(_ title: String, imageName: String, wants: Wants , isWant: Bool) : View {
    
    var title : String
    var imageName : String
//    var wants : Wants
    var isWant : Bool
    
    func filteredWants(_ isWant: Bool) -> [Want] {
        print("filteredWants!")
        return wants.compactMap { item in
            return item.isWant == isWant ? item : nil
        }
    }
    
    // catIndex == indexのものをフィルタ
    func filteredKeywords(_ isWant: Bool) -> [Keyword] {
        return keywords.compactMap { item in
            return item.isWant == isWant ? item : nil
        }
    }

//    @ObservedObject var keywords = Keywords()
    
    
    // Want
    private func addWant(isWant: Bool) {
        let item = Want(title: isWant ? "" : "", isWant: isWant, index: filteredWants(isWant).count)
        wantAry.append(item)
        modelContext.insert(item)
        
        
        editingWant = item
        textWant = ""// isWant ? "やりたいこと" : "やりたくないこと"//editingWant.title
        isAlertPresented_Want = true
        

    }
    
    
    private func deleteWant(_ want: Want) {
//        withAnimation {
        
        if let index = wantAry.firstIndex(of: want) {
            wantAry.remove(at: index)
        }
        
        modelContext.delete(want)

        
        let delay = 1.0 //遅延
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            //
            updateWantsIndex()
            try! modelContext.save()
            
            
            
        }
        
      
//        }
    }
    
    // Keyword
    private func addKeyword(isWant: Bool) {
        let item = Keyword(title: "キーワード", isWant: isWant, index: filteredKeywords(isWant).count)
            modelContext.insert(item)
    }
    
   
    private func deleteKeyword(_ item: Keyword) {
//        withAnimation {
        modelContext.delete(item)
        try! modelContext.save()
    
        updateKeywordsIndex()
        

            
            
//            for index in offsets {
//                modelContext.delete(keywords_new[index])
//                try! modelContext.save()
//            }
            
//        }
    }
    
    let grids = [
        GridItem(.adaptive(minimum: 35, maximum: .infinity), spacing: 5)
    ]
    
    @State private var isAlertPresented_Want = false
    @State private var isAlertPresented_Keyword = false
    @State private var textWant = ""
    @State private var textKeyword = ""
    @State private var editingWant : Want! = nil
    @State private var editingKeyword : Keyword! = nil
    

    
//    func updateWantsIndex() {
//        for i in 0..<sortedWants.count {
//            sortedWants[i].index = i
//        }
//        try! modelContext.save()
//    }
//    
    
    func updateWantsIndex() {
        for i in 0..<wantAry.count {
            wantAry[i].index = i
            wantAry[i].index = i
        }
        try! modelContext.save()
    }
    
    func updateKeywordsIndex() {
        for i in 0..<keywords.count {
            keywords[i].index = i
        }
        try! modelContext.save()
    }
    
    
    var sortedWants: [Want] {
        get {
            wantAry.sorted(by: { $0.index < $1.index })
        }
        set {
            wantAry = newValue
        }
    }
    
    func move(offset: IndexSet, index: Int) {
//        var ary = wantAry
        wantAry.move(fromOffsets: offset, toOffset: index)
        
  
        let delay = 1.0 //遅延
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//            withAnimation {
//                updateArrayIndex(ary)
//                wants = ary
            updateArrayIndex(wantAry)
//                try! modelContext.save()
                
//            }
        }
        
        
        
//        try! modelContext.save()
    }
    
    func updateArrayIndex(_ ary: [Want]) {
        for i in 0..<ary.count {
//            let a = ary[i]
            ary[i].index = i
//            if a.isWant {
//                print(a.title)
//            }
     
        }
    }
    
        
    var body: some View {
        
        VStack() {
            GroupBox {
                Text(title)
                    .font(Font.system(size: 14))
                    .padding(.vertical, 3)
                    .padding(.horizontal, 10)
                    .background(colorForWant(isWant))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .foregroundColor(colorForWant(isWant))
                
                List {
                    Section {
                        
                        //                        ForEach(isWant ? wants.data_OK : wants.data_NG) { item in
                        //                            WantRow(item, isWant: isWant)
                        //                        }
                        //
//                        ForEach(filteredWants(isWant)) { item in
                        ForEach(wantAry) { item in
                            //                            Rect(title: item.title, isWant: isWant)
                            WantRow(item, isWant: isWant)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteWant(item)
                                    } label: {
                                        Label("削除", systemImage: "trash")
                                    }
                                }
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    editingWant = item
                                    textWant = editingWant.title
                                    isAlertPresented_Want = true
                                }
                                .alert("編集", isPresented: $isAlertPresented_Want) {
                                    TextField(isWant ? "やりたいこと": "やりたくないこと", text: $textWant)
                                    
                                    Button("削除", role: .destructive) {
                                        isAlertPresented_Want = false
                                        withAnimation {
                                            deleteWant(editingWant)
                            
                                        }
                                    }
                                    Button("キャンセル") {
                                        isAlertPresented_Want = false
                                        
//                                        withAnimation {
//                                            wantAry.removeLast()
//                                            modelContext.delete(editingWant)
//                                        }
                                 
                                    }
                                    Button("保存", role: .cancel) {
                                        withAnimation {
                                            editingWant.title = textWant
                                        }
                                    }
                                    
                                } message: {
                                    // アラートのメッセージ...
                                    //                                        Text("必要な情報を入力してください")
                                }
                        }
                        .onMove(perform: move)
                        
                        
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    addWant(isWant: isWant)
                                }
                                //                                addKeyword(isWant: isWant)
                                //                                print("isWant")
                                //                                print(isWant)
                                //                                if isWant {
                                //                                    isAlertPresented_OK = true
                                //                                } else {
                                //                                    isAlertPresented_NG = true
                                //                                }
                                
                                
                                
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                    .foregroundColor(colorForWant(isWant))
                            }
                            
                            
                            
                            //                            .alert("LogIn", isPresented: $isAlertPresented_OK) {
                            //
                            //                                TextField("メールアドレス", text: $text)
                            ////                                SecureField("パスワード", text: $password)
                            //
                            //                                Button("キャンセル") {}
                            //                                Button("OK") {}
                            //
                            //                            } message: {
                            //                                // アラートのメッセージ...
                            //                                Text("必要な情報を入力してください")
                            //                            }
                            
                            
                            //                            .alert("やりたいこと追加", isPresented: isWant ? $isAlertPresented_OK : $isAlertPresented_NG, actions: {
                            //                                     TextField("やりたいこと", text: $text)
                            ////                                     SecureField("Password", text: $password)
                            //                                     Button("保存", action: {
                            ////                                         addWant(str: text)
                            //                                     })
                            //                                     Button("Cancel", role: .cancel, action: {})
                            //                                 }, message: {
                            //                                     Text("Please enter your username and password.")
                            //                                 })
                            
                            //                            .alert("アラート", isPresented: $isAlertPresented) {
                            //                                       TextField("テキストフィールド", text: $text)
                            //
                            //                                       Button {
                            //                                           print("OK")
                            //                                           addWant(str: text)
                            //
                            //
                            //
                            //                                       } label: {
                            //                                           Text("OK")
                            //                                       }
                            //                                   }
                            
                            Spacer()
                        }
                        .frame(height: 45)
                        
                        
                    }
                    .background(.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    
                    
                }
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 10)
                
                Spacer()
                
                Text("キーワード")
                    .font(Font.system(size: 14).bold())
                    .foregroundStyle(colorForWant(isWant))
                    .offset(y: 7)
                
                HStack(alignment: .center) {
                    
                    ScrollView {
                        LazyVGrid(columns: grids, spacing: 5) {
                            ForEach(filteredKeywords(isWant)) { item in
                                Rect(title: item.title, isWant: isWant)
                                    .onTapGesture {
                                        editingKeyword = item
                                        textKeyword = editingKeyword.title
                                        
                                        isAlertPresented_Keyword = true
                                    }
                                
                                    .alert("編集", isPresented: $isAlertPresented_Keyword) {
                                        TextField("キーワード", text: $textKeyword)
                                        
                                        Button("削除", role: .destructive) {
                                            deleteKeyword(editingKeyword)
                                        }
                                        Button("キャンセル") {}
                                        Button("保存", role: .cancel) {
                                            editingKeyword.title = textKeyword
                                            
                                        }
                                        
                                    } message: {
                                        // アラートのメッセージ...
                                        //                                        Text("必要な情報を入力してください")
                                    }
                                
                                
                            }
                            Button {
                                withAnimation {
                                    addKeyword(isWant: isWant)
                                }
                            } label: {
                                Text("＋")
                                    .foregroundStyle(colorForWant(isWant))
                                    .font(Font.system(size: 30))
                            }
                        }
                        .padding(5)
                    }
                    .frame(height: 140)
                }
            }
            .groupBoxStyle(StandardGroupBoxStyle(isWant: isWant))
        }
        .onAppear{
            wantAry = filteredWants(isWant) //wants
            print(wantAry)
        }
    }
}


/* ----------------------------------------------------------------------------
 MARK: - keyword
 ------------------------------------------------------------------------------*/

@Model
class Keyword : Identifiable {
    var id = UUID()
    var title: String
    var isWant: Bool
    var index : Int
    
    init(id: UUID = UUID(), title: String, isWant: Bool, index: Int) {
        self.id = id
        self.title = title
        self.isWant = isWant
        self.index = index
    }

}

//class Keywords : ObservableObject {
//    
//    @Published var data_OK = [
//        Keyword(title: "貢献", isWant: true),
//        Keyword(title: "シンプルな生き方", isWant: true),
//        Keyword(title: "環境", isWant: true),
//        Keyword(title: "パートナー", isWant: true),
//        Keyword(title: "お金", isWant: true),
//        Keyword(title: "クリエイティブ", isWant: true),
//        Keyword(title: "心身の健康", isWant: true),
//        Keyword(title: "時間", isWant: true),
//        Keyword(title: "単価が高い", isWant: true)
//
//
//        
//    ]
//    
//    @Published var data_NG = [
//        Keyword(title: "ストレス", isWant: false),
//        Keyword(title: "低所得", isWant: false),
//        Keyword(title: "不安", isWant: false),
//        Keyword(title: "能力がない", isWant: false),
//        Keyword(title: "単価が低い", isWant: false)
//    ]
//    
//}



struct Rect: View {
    
    var title: String
    var isWant: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(colorForWant(isWant), lineWidth: 2)
            .frame(width: 35, height: 35)
            .overlay {
                Text(title)
                    .font(.system(size: 14))
                    .minimumScaleFactor(0.1)
                    .foregroundColor(colorForWant(isWant))
                    .padding(3)
            }
    }
}



/* ----------------------------------------------------------------------------
 MARK: - misc
 ------------------------------------------------------------------------------*/

public struct StandardGroupBoxStyle: GroupBoxStyle {
    var isWant : Bool
    public func makeBody(configuration: Self.Configuration) -> some View {
        VStack(alignment: .center) {
//            configuration.label
            configuration.content
        }
        .padding(.top,8)
        .padding(.horizontal, 3)
//        .background(Color(.red))
        .background(colorForWant(isWant).opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))       // << debug?
    }
}
