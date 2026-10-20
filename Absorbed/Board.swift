//
//  CategoryView.swift
//  Immersion
//
//  Created by forest on 2024/01/22.
//

import SwiftUI
import SwiftData
import UIKit

let scaleK : CGFloat = 1.0
//let todayImageName = "flame"
//let phaseImageName = "circle.grid.2x2"
//let phaseImageName = "directcurrent"
let phaseImageName = "rectangle.fill"


//class ItemsForCategory: ObservableObject {
//    @Published var data = [[Item]]()
//}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

let space : Double = 30

struct BoardScreen: View {
    
    @Environment(\.modelContext) var modelContext
    @Query private var dislikes: [Dislike]
    
    @AppStorage(KeyString.moveLocked.rawValue) var moveLocked = false
    @AppStorage(KeyString.moveLocked_item.rawValue) var moveLocked_item = false
    
    @AppStorage(KeyString.icon_4.rawValue) var icon_4 : Int = 0
    @AppStorage(KeyString.aligned.rawValue) var aligned : Bool = false

    @AppStorage(KeyString.autoAlignViews.rawValue) var autoAlignViews : Bool = true
    
    @Query (
        sort: [
            SortDescriptor(\Category.index, order: .forward)
        ]
    ) var categories: [Category]
    

    
    @EnvironmentObject var setData : ShareData

    @State var showMenu = false
    @State var showMenu_forItem = false
    
    @State var showSheet = false

    
    func makeDefaultDislikes() {
        
        let ary = [
            Dislike(title: "モノが多い", index: 0),
            Dislike(title: "能力がない", index: 1),
            Dislike(title: "満員電車", index: 2),
            Dislike(title: "単価の安い仕事", index: 3)
        ]
        
        for i in 0..<ary.count {
            let item = ary[i]
            modelContext.insert(item)
        }
    }
    
    func makeDefaultPhase() {
        
        let ary = [
            Phase(item: item_00, index: 0, title: "知識\n（本、ニュース）"), // 投資
            Phase(item: item_00, index: 1, title: "元本づくり\n（1,000万円）"),
            Phase(item: item_00, index: 2, title: "試行錯誤の繰り返し"),
            Phase(item: item_00, index: 3, title: "資産1億"),
            
            Phase(item: item_22, index: 0, title: "毎日10分（家）"), // 筋トレ
            Phase(item: item_22, index: 1, title: "・ジム\n・プロテイン"),
            Phase(item: item_22, index: 2, title: "ジムのウェイト全制覇"),
            
            Phase(item: item_10, index: 0, title: "学習とサンプル作成"),
            Phase(item: item_10, index: 1, title: "CWで集客"),
            Phase(item: item_10, index: 2, title: "受注")
        ]
        
        for i in 0..<ary.count {
            let item = ary[i]
            modelContext.insert(item)
        }
        
    }
    
    private func addCategory() {
        
        let index = categories.count
        let newItem = Item(title: "", posX :90, posY: 90, length: 60, stepNumber: 0, catIndex: index)
        let newCat =  Category(title: "新しいカテゴリー", posX: 0, posY: 0, length: 200, index: index, items: [newItem])
        
        newCat.posY = newCategoryViewY(cat: newCat)
        
        modelContext.insert(newItem)
        modelContext.insert(newCat)
            
        updateAllItemCatIndex(ary: categories)
        alignViews(categories: categories)
    }
    
    
    private func addItem(posX: CGFloat, posY: CGFloat, category: Category) {
//        let item = Item(posX: posX, posY: posY, created: true, catIndex: category.index)
        let item = Item(posX: category.length/2, posY: category.length/2, created: true, catIndex: category.index)
        category.items.append(item)
        modelContext.insert(item)
//        itemsForCategory.data[catIndex].append(item)
    }
    
    private func deletItem(_ item: Item) {
        withAnimation {
            modelContext.delete(item)
            try! modelContext.save()
        }
    }
    
    
    private func addDislike(title: String) {
        withAnimation {
            let item = Dislike(title: title, index: dislikes.count)
            modelContext.insert(item)
        }
    }
 
    private func deleteDislike(_ item: Dislike) {
        modelContext.delete(item)
        try! modelContext.save()
    }
    
    let grids = [GridItem(.fixed(50), spacing: 10, alignment: .center)]
    
    
    @State private var isAlertPresented_Dislike = false
    @State private var textDislike = ""
    @State private var editingDislike : Dislike! = nil
    

    @State private var frameX : CGFloat = 400
    @State private var frameY : CGFloat = 500
    
    @AppStorage(KeyString.magnifyBy.rawValue) var magnifyBy = 1.0
    @State private var lastMagnificationValue = 1.0
    

    
    func newCategoryViewY(cat: Category) -> CGFloat {
        let last = categories.last!
        let posY = last.posY + (last.length/2 * magnifyBy) + (cat.length/2 * magnifyBy) + (space * magnifyBy)
        return posY
    }
    
    @State var showReorderScreen = false
    

    
    

    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                // 前回の拡大率に対して今回の拡大率の割合を計算
                let changeRate = value / lastMagnificationValue
                // 前回からの拡大率の変更割合分を乗算する
                magnifyBy *= changeRate

                // 前回の拡大率を今回の拡大率で更新
                lastMagnificationValue = value
                
         
            }
            .onEnded { value in
                
                // 次回のジェスチャー時に1.0から始まる為、終了時に1.0に変更する
                lastMagnificationValue = 1.0
                alignViews(categories: categories)
            }
    }
    
 
    
//    @State private var scrollViewContentSize: CGSize = .zero
    
    let sHeight = 300.0
    
    var body: some View {
        
//        GeometryReader { geo in
        NavigationView {
            
    
                
                VStack(spacing: 0) {
                    
                    CaptionView(str: "やりたいことのピースを洗い出し分類・整理しよう")
                    
                    HStack(spacing: 20) {
                        
                        
                        Button(moveLocked ? "ロック中" : " ", systemImage: moveLocked ? "lock" : "lock.open")
                        {
                            moveLocked.toggle()
                        }
                        
                        Button(moveLocked_item ? "ロック中" : " ", systemImage: moveLocked_item ? "lock.fill" : "lock.open.fill")
                        {
                            moveLocked_item.toggle()
                        }
                        
                        Button("整列", systemImage: "line.3.horizontal")
                        {
                            alignViews(categories: categories)
                        }
                        
                        Button("並べ替え", systemImage: "arrow.up.arrow.down")
                        {
                     
                            showReorderScreen = true
                        }
                        
                    }
                    .font(.system(size: 16))
                    .padding(2)
                    .sheet(isPresented: $showReorderScreen, onDismiss: {
                        withAnimation{
                            
                            alignViews(categories: categories)
                        }
                        // use `self.imageURL` here to upload to server
//                        uploadToServer(url: self.imageURL)   // << eg.
                    }) {
                        ReorderScreen(categories: categories)
                        //I want to get the selected imageURL here to call uploadToServer()
                    }
                    
//                    
//                    .sheet(isPresented: $showReorderScreen) {
//                        ReorderScreen(categories: categories)
//                    }
//                  
//                    
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                        
                        
                        ScrollView(.vertical, showsIndicators: true)  {
                            ZStack {
                                ForEach(categories) { cat in
                                    
                                    CategoryView(categories: categories, category: cat, asDetail: false, showMenu: $showMenu, showMenu_forItem: $showMenu_forItem)
                                        .scaleEffect(magnifyBy, anchor: .center)
                                }
                                
                            }
                            .frame(width: UIScreen.screenWidth)
                            
                            Spacer(minLength: sHeight*magnifyBy*Double(categories.count))
                            
                        }
                        .gesture(magnification)
                        
 
                        if !showMenu && !showMenu_forItem {
                            
                            VStack(alignment: .center, spacing: 3) {
                                
                                HStack(spacing: 3) {
                                    Image(systemName: iconNames_4[icon_4])
                                    
                                    Text("やらないこと")
                                        .bold()
                                }
                                
                                
                                
                                ScrollView(.horizontal) {
                                    LazyHGrid(rows: grids, spacing: 10) {
                                        ForEach(dislikes) { item in
                                            Rectangle()
                                                .frame(width: 50)
                                                .foregroundStyle(Color("dislike_rect"))
                                                .overlay {
                                                    Text(item.title)
                                                        .foregroundStyle(.white)
                                                        .font(Font.system(size: 12))
                                                        .minimumScaleFactor(0.1)
                                                        .padding(3)
                                                    
                                                    
                                                }
                                                .onTapGesture {
                                                    editingDislike = item
                                                    textDislike = editingDislike.title
                                                    
                                                    isAlertPresented_Dislike = true
                                                }
                                            
                                                .alert("編集", isPresented: $isAlertPresented_Dislike) {
                                                    TextField("やらないこと", text: $textDislike)
                                                    
                                                    Button("削除", role: .destructive) {
                                                        deleteDislike(editingDislike)
                                                    }
                                                    Button("キャンセル") {}
                                                    Button("保存", role: .cancel) {
                                                        editingDislike.title = textDislike
                                                        
                                                    }
                                                    
                                                } message: {
                                                    // アラートのメッセージ...
                                                    //                                        Text("必要な情報を入力してください")
                                                }
                                            //                                            .onTapGesture {
                                            //                                                deleteDislike(item)
                                            //
                                            //                                            }
                                        }
                                        
                                        Button{
                                            withAnimation {
                                                addDislike(title: "やらないこと")
                                                
                                            }
                                            
                                        } label: {
                                            Text("＋")
                                                .foregroundStyle(.white)
                                                .font(Font.system(size: 30))
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                                .frame(height: 55)
                                .padding(5)
                                //                            .padding(.horizontal, 20)
                                .background(.gray.opacity(0.9))
                                .border(.gray, width: 3)
                                
                                
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            
                            
                            
                        } else {
                            
                            if showMenu_forItem {
                                MenuView(forItem: true)
                            }
                            
                            if showMenu {
                                MenuView(forItem: false)
                            }
                            
                            
                            
                            
                            //                    sliderVal = selectedCatView.category.length
                        }
                    }
                    
                    .navigationTitle(screenTitles[1])
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        /// ナビゲーションバー左
                        ToolbarItem(placement: .navigationBarLeading){
                            HStack(spacing: 0) {
                                Button(action: {
                                    addCategory()
                                }) {
                                    Image(systemName: "plus.square")
                                }
                                Text("カテゴリー")
                                    .font(.footnote)
                                
                            }
                            
                            
                        }
                        
                        /// ナビゲーションバー右１
                        ToolbarItem(placement: .navigationBarTrailing){
                            HStack(spacing: 0) {
                                Text("アイテム")
                                    .font(.footnote)
                                Button(action: {
                                    withAnimation {
                                        if let v = setData.selectedCatView {
                                            addItem(posX:v.category.posX, posY: v.category.posY, category: v.category)
                                            if setData.selectedCatView != nil {
                                                setData.selectedCatView.isSelected = false
                                                setData.selectedCatView = nil
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                }) {
                                    Image(systemName: "plus.square.fill")
                                }
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    //                }
                    //            }
                    .onTapGesture {
                        //                withAnimation {
                        
                        
                        //                    if selectedCatView != nil {
                        
                        if setData.selectedCatView != nil {
                            setData.selectedCatView.isSelected = false
                            //                        setData.selectedCatView.isFoc used = false
                            setData.selectedCatView = nil
                        }
                        //                        selectedCatView = nil
                        //                    }
                        
                        //                                    if selectedItemView != nil {
                        
                        if setData.selectedItemView != nil {
                            setData.selectedItemView.isSelected = false
                            setData.selectedItemView.isFocused = false
                            setData.selectedItemView.item.created = false
                            setData.selectedItemView = nil
                        }
                        
                        //                        selectedItemView = nil
                        //                    }
                        
                        showMenu = false
                        showMenu_forItem = false
                        
                        
                    }
                    
                    
                }
            }
     
            
        
            
//        }
        .onAppear {
            updateAllItemCatIndex(ary: categories)
            if autoAlignViews {
                alignViews(categories: categories)
            }
       
//            if aligned == false {
//                alignViews()
//                aligned = true
//            }

        }
        .onDisappear {
            if setData.selectedItemView != nil {
                setData.selectedItemView.isSelected = false
                setData.selectedItemView = nil
            }
        }
    }
}



/* ----------------------------------------------------------------------------
 MARK: - Category
 ------------------------------------------------------------------------------*/
//class CategoryData: ObservableObject {
//    @Published var categories = [Category]()
//}



//class ItemsForCategory: ObservableObject {
//    @Published var data = [[Item]]()
//}
//
//


struct CategoryView: View {
    
 
    
    var categories : [Category]
//    @EnvironmentObject var categoryData : CategoryData
//    @Environment(\.modelContext) var modelContext
//    @Query private var categories: [Category]
//    @Query private var items: [Item]
    
    
    static func == (lhs: CategoryView, rhs: CategoryView) -> Bool {
        return lhs.id == rhs.id
    }
    
//    @ObservedObject var itemsForCategory : ItemsForCategory
//    @StateObject var itemsForCategory = ItemsForCategory()
    
    
    @EnvironmentObject var setData : ShareData
    
//    @Binding var moveLocked : Bool
    @AppStorage(KeyString.moveLocked.rawValue) var moveLocked = false
    
    var id = UUID()


    @State var category : Category
    
    @State var posDiff = CGPoint.zero
    @State var dragStart = false
    @State var showDetail = false
    
    @State var isSelected = false
        
    @State var asDetail : Bool
    
    @Binding var showMenu : Bool
    @Binding var showMenu_forItem : Bool
    
    
    @State var showSheet = false

    @AppStorage(KeyString.magnifyBy.rawValue) var magnifyBy = 1.0
    
//    func alignViews() {
//        withAnimation {
//            categories[0].posY = 20 * magnifyBy
//            for i in 1..<categories.count {
//                let catPrev = categories[i-1]
//                let cat = categories[i]
//                cat.posY = catPrev.posY + (catPrev.length/2 * magnifyBy) + (cat.length/2 * magnifyBy) + (space * magnifyBy)
//            }
//        }
//
//    }

    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {

            Text(category.title)
                .font(.system(size: 20))
                .minimumScaleFactor(0.5)
                .foregroundStyle(colorForIndex(category.index))

            ZStack(alignment: .bottom) {
                Rectangle()
//                    .frame(height: category.length, alignment: .bottom)
                    .frame(width: category.length, height: category.length)
                    .foregroundColor(isSelected ? Color("viewSelected") : Color("categoryViewBack"))
                    .border(colorForIndex(category.index), width: 3)
                    .background(.white.opacity(0.2))
                
                
                ForEach(category.items) { item in
                        ItemView(item: item, asDetail: asDetail, showMenu: $showMenu, showMenu_forItem: $showMenu_forItem)
                }
            }
            .frame(width: category.length, height: category.length)


//            Spacer()
        }
//        .background(.red).opacity(0.5)
        .frame(height: category.length+30)
//        .background(.red).opacity(0.5)

        .zIndex(2)
//        .position(CGPoint(x: category.posX/magnifyBy, y: category.posY/magnifyBy))
        .offset(CGSize(width: category.posX/magnifyBy, height: category.posY/magnifyBy))
        .gesture(drag)
        .onAppear {
        }
        .onTapGesture {
            
            if isSelected {
                showSheet = true
            } else {
                
                if setData.selectedCatView != nil {
                    setData.selectedCatView.isSelected = false
                  
                }
                
                isSelected = true
                setData.selectedCatView = self
                
                
                if setData.selectedItemView != nil {
                    setData.selectedItemView.isSelected = false
                    setData.selectedItemView.item.created = false
                    setData.selectedItemView = nil
                }
                
                showMenu = true
                showMenu_forItem = false
                
            }
        }
        .sheet(isPresented: $showSheet) {
            CategoryDetailScreen(category: category)
        }
    }
    
    var drag: some Gesture {
        DragGesture()
       
            .onChanged { value in
                if !moveLocked {
                    if !dragStart {
                        posDiff = CGPoint(x: value.startLocation.x*magnifyBy - category.posX , y: value.startLocation.y*magnifyBy - category.posY)
                        dragStart = true
                    }
                    
                    category.posX =
                    value.startLocation.x*magnifyBy
                    + value.translation.width*magnifyBy
                    - posDiff.x
                    
         
//                    category.posX *= magnifyBy
                    
                    category.posY =
                    value.startLocation.y*magnifyBy
                    + value.translation.height*magnifyBy
                    - posDiff.y
                    
                    
//                    print(category.posY)
//                    category.posY *= magnifyBy
                    
            
                }
            }
            .onEnded { value in
                if !moveLocked {
                    if !asDetail {
                        
                        category.posX =
                        value.startLocation.x*magnifyBy
                        + value.translation.width*magnifyBy
                        - posDiff.x
                        
                        category.posY =
                        value.startLocation.y*magnifyBy
                        + value.translation.height*magnifyBy
                        - posDiff.y
                        
                    }
                    dragStart = false
                }
                alignViews(categories: categories)
             
            }
    }
    
}

//#Preview {
//    CategoryView(asDetail: true, showMenu: Binding.constant(false), showMenu_forItem: Binding.constant(false))
//        .modelContainer(for: Cat.self)
//}
//





@Model
class Category : Identifiable {

    let id = UUID()
    var title: String
    var posX: CGFloat
    var posY: CGFloat
    var length: CGFloat
    var index: Int
    var items : [Item]
    
    init(title: String, posX: CGFloat, posY: CGFloat, length: CGFloat, index: Int, items: [Item]) {
        self.title = title
        self.posX = posX
        self.posY = posY
        self.length = length
        self.index = index
        self.items = items
    }
        
//    init(title: String, posX: CGFloat, posY: CGFloat, length: CGFloat, index: Int) {
//        self.title = title
//        self.posX = posX
//        self.posY = posY
//        self.length = length
//        self.index = index
//    }
    
    
    
}





struct CategoryDetailScreen: View {
    
//    init() {
//        UITextField.appearance().clearButtonMode = .whileEditing
//    }
        
    @EnvironmentObject var setData : ShareData
    
//    var itemsForCategory : ItemsForCategory
    
    var category : Category
    
    @FocusState var isFocused
    
//    @State var titleStr : String

    var body: some View {
        
        VStack {
                        
//            Text(category.title)
//                .font(.title)
//                .foregroundStyle(colors[category.index])
//                .padding(.top, 20)
            
            TextField("タイトル入力", text: Binding(get: {
                     category.title
                 }, set: { (newVal) in
                     category.title = newVal
                 }))
                 .font(.title)
                 .minimumScaleFactor(0.5)
                 .multilineTextAlignment(.center)
                 .foregroundStyle(colorForIndex(category.index))
                 .padding(.top)
                 .focused($isFocused)
     //            .disabled(!isSelected)
//                 .onTapGesture {
//                     isSelected = true
//                     if isSelected {
//                         setData.selectedCatView = self
//                     }
//                 }
                 .onSubmit {
                     isFocused = false
                 }
            
            Spacer()
            
//            CategoryView(itemsForCategory: itemsForCategory, category: category, asDetail: true, showMenu: Binding.constant(false), showMenu_forItem: Binding.constant(false))
//            
        }
    }
}



/* ----------------------------------------------------------------------------
 MARK: - DislikeView
 ------------------------------------------------------------------------------*/

@Model
class Dislike {
    var title : String
    var index : Int
    
    init(title: String, index: Int) {
        self.title = title
        self.index = index
    }
}

//
//class Dislikes : ObservableObject {
//    @Published var data : [Want] = [
//        Want(title: "モノが多い", isWant: false),
//        Want(title: "能力がない", isWant: false),
//        Want(title: "満員電車", isWant: false),
//        Want(title: "単価の安い仕事", isWant: false)
//        
//    ]
//    
//}





//
//
//
//struct MenuView: View {
//    
//    @Environment(\.modelContext) var modelContext
//    
//    //    @EnvironmentObject var categoryData : CategoryData
//    
//    @EnvironmentObject var setData : ShareData
//    
//    @State var showSheet = false
//    
////    @Binding var sliderVal : Double
//    
//    var forItem : Bool
//    
//    private func deleteCategory(_ item: Category) {
//        withAnimation {
//            modelContext.delete(item)
//            try! modelContext.save()
//        }
//    }
//    
//    private func deleteItem(_ item: Item) {
//        withAnimation {
//            modelContext.delete(item)
//            try! modelContext.save()
//        }
//        
////        if let index = itemsForCategory.data[item.catIndex].firstIndex(of: item) {
////            itemsForCategory.data[item.catIndex].remove(at: index)
////        }
//        
//    }
//    
//    
//    func duplicateItem() {
//        
//    }
//    
//    func addToStep() {
//        
//    }
//    
//    @State  var opacity: Double = 0
//
//    @State private var isSliding : Bool = false
//    
//    func upfateValue() {
//        if setData.selectedCatView != nil {
//            deleteCategory(setData.selectedCatView.category)
//            //                        selectedCatView.deleteCategory()
//        } else {
//            //                        setData.setData.selectedCatView.deleteItem()
//            deleteItem(setData.selectedItemView.item)
//        }
//    }
//    
//    
//    
//    var body: some View {
//        
//        
//        VStack {
//            
////            Slider(value: $sliderVal, in: 0...300)
////                .padding(.horizontal)
////         
//            
//            HStack(spacing: 30) {
//                
//                Image(systemName: "pencil.line")
//                    .onTapGesture {
//                        showSheet = true
//                    }
//                    .sheet(isPresented: $showSheet) {
//                        if setData.selectedCatView != nil {
//                            //                        CategoryDetailScreen(itemsForCategory: itemsForCategory, category: selectedCatView.category)
//                        } else {
//                            ItemDetailScreen(item: setData.selectedItemView.item)
//                        }
//                    }
//                
//                Image(systemName: "trash")
//                    .onTapGesture {
//                        if setData.selectedCatView != nil {
//                            deleteCategory(setData.selectedCatView.category)
//                            //                        selectedCatView.deleteCategory()
//                        } else {
//                            //                        setData.setData.selectedCatView.deleteItem()
//                            deleteItem(setData.selectedItemView.item)
//                        }
//                    }
//                
//                Image(systemName: "plus.square.on.square")
//                
////                Image(systemName: "plus.square.on.square")
////                    .onTapGesture {
////
////                    }
//                
//                if forItem {
//                    Image(systemName: "rectangle.portrait.and.arrow.right")
//                        .onTapGesture {
//                            addToStep()
//                        }
//                }
//                
//                
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 10)
//            .background(Color("menu"))
//            .cornerRadius(20)
//            .offset(y: -10)
//            .onAppear {
//      
//
//            }
//            
//            
//        }
//
//  
//        
//    }
//}
