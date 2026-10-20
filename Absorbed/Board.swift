//
//  CategoryView.swift
//  Immersion
//
//  Created by forest on 2024/01/22.
//

import SwiftUI
import SwiftData

let scaleK : CGFloat = 1.0
//let todayImageName = "flame"
//let phaseImageName = "circle.grid.2x2"
//let phaseImageName = "directcurrent"
let phaseImageName = "rectangle.fill"


class ItemsForCategory: ObservableObject {
    @Published var data = [[Item]]()
}

struct BoardScreen: View {
    
    @Environment(\.modelContext) var modelContext
    @Query private var dislikes: [Dislike]
    
    @AppStorage(KeyString.moveLocked.rawValue) var moveLocked = false
    @AppStorage(KeyString.moveLocked_item.rawValue) var moveLocked_item = false
    
    @AppStorage(KeyString.icon_4.rawValue) var icon_4 : Int = 0
    
    @Query (
        sort: [
            SortDescriptor(\Category.index, order: .forward)
        ]
    ) var categories: [Category]
    
    
    
    @Query private var items: [Item]
    
//    @ObservedObject var itemsForCategory = ItemsForCategory()
    
    @StateObject var itemsForCategory = ItemsForCategory()
    
    @EnvironmentObject var setData : ShareData
    
    func updateItemsForCategory() {
        for cat in categories {
            let items = filteredItems(cat)
            itemsForCategory.data.append(items)
        }

    }
    
    
//
//    @EnvironmentObject var categoryData : CategoryData
    
    @State var showMenu = false
    @State var showMenu_forItem = false
    
    @State var showSheet = false
    
    
//    @ObservedObject var dislikes = Dislikes()
    
    func makeDefaultCategories() {
        
        let ary = [
            cat0,
            cat1,
            cat2
        ]
        
        for i in 0..<ary.count {
            let item = ary[i]
            modelContext.insert(item)
        }
        
    }
    
    
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
        let cat =  Category(title: "新しいカテゴリー", posX: 200, posY: 50, length: 200, index: categories.count) //Want(title: "お金持ちになる", isWant: true)
        

        
        let item_new = Item(title: "アイテム", posX :232, posY: 63, length: 60, catIndex: categories.count, stepNumber: 0)
        var items = [Item]()
        items.append(item_new)
        itemsForCategory.data.append(items)
        
        modelContext.insert(item_new)
        modelContext.insert(cat)
    }
    
    
    private func addItem(catIndex: Int, posX: CGFloat, posY: CGFloat) {
        let item = Item(posX: posX, posY: posY, catIndex: catIndex, focused: true)
        modelContext.insert(item)
        itemsForCategory.data[catIndex].append(item)
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
        withAnimation {
            modelContext.delete(item)
            try! modelContext.save()
        }
    }

    let grids = [GridItem(.fixed(50), spacing: 10, alignment: .center)]
    
    
    func filteredItems(_ category: Category) -> [Item] {
        return items.compactMap { item in
            return item.catIndex == category.index ? item : nil
        }
    }
    
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                
                CaptionView(str: "やりたいことのピースを洗い出し分類・整理しよう")
                
                HStack(spacing: 20) {
//                    Spacer()
                    
                    Button(moveLocked ? "ロック中" : " ", systemImage: moveLocked ? "lock" : "lock.open")
                    {
                        moveLocked.toggle()
                    }
//                    .font(.system(size: 16))
                 
//                    Spacer(minLength: 1)
                    
                    Button(moveLocked_item ? "ロック中" : " ", systemImage: moveLocked_item ? "lock.fill" : "lock.open.fill")
                    {
                        moveLocked_item.toggle()
                    }
                    
//                    Spacer()
      
          
                    
                }
                .font(.system(size: 16))
                .padding(2)
         
          

                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    
               

                    ScrollView {
                        ForEach(categories) { cat in
                            //                        CategoryView(items: filteredItems(cat), category: cat, asDetail: false, showMenu: $showMenu, showMenu_forItem: $showMenu_forItem)
                            CategoryView(itemsForCategory: itemsForCategory, category: cat, asDetail: false, showMenu: $showMenu, showMenu_forItem: $showMenu_forItem)
                            
                            
                        
                        }
                        Spacer()
                            .frame(height: 110.0)
                    }
                    
                    
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
                                                deleteDislike(item)
                                            }
                                    }
                                    
                                    Button{
                                        withAnimation {
                                            addDislike(title: "嫌なこと")
                                        
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
                            .background(.gray.opacity(0.9))
                            .border(.gray, width: 3)
                            
                            
                        }
                        .padding(.horizontal, 5)
                        
                        
                        
                    } else {
                        
                        if showMenu_forItem {
                            MenuView(itemsForCategory: itemsForCategory, forItem: true)
                        }
                        
                        if showMenu {
                            MenuView(itemsForCategory: itemsForCategory, forItem: false)
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
                                        addItem(catIndex: v.category.index, posX:v.category.posX, posY: v.category.posY)
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
                        setData.selectedCatView.isFocused = false
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
        .onAppear {
            if _ud.object(forKey: KeyString.categoriesMaken.rawValue) == nil {
                makeDefaultCategories()
                _ud.setValue("Done", forKey: KeyString.categoriesMaken.rawValue)
            }
            if _ud.object(forKey: KeyString.dislikesMaken.rawValue) == nil {
                makeDefaultDislikes()
                _ud.setValue("Done", forKey: KeyString.dislikesMaken.rawValue)
            }
            if _ud.object(forKey: KeyString.phasesMaken.rawValue) == nil {
                makeDefaultPhase()
                _ud.setValue("Done", forKey: KeyString.phasesMaken.rawValue)
            }
            updateItemsForCategory()
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
    
 
//    @EnvironmentObject var categoryData : CategoryData
//    @Environment(\.modelContext) var modelContext
//    @Query private var categories: [Category]
//    @Query private var items: [Item]
    
    
    static func == (lhs: CategoryView, rhs: CategoryView) -> Bool {
        return lhs.id == rhs.id
    }
    
//    @ObservedObject var itemsForCategory : ItemsForCategory
    @StateObject var itemsForCategory = ItemsForCategory()
    
    
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
    
    @FocusState var isFocused

    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {

            
            TextField("タイトル入力", text: Binding(get: {
                category.title
                
            }, set: { (newVal) in
                category.title = newVal
            }))
            .font(.title)
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            .foregroundStyle(aColor(category: category))
            .padding(.top)
            .focused($isFocused)
//            .disabled(!isSelected)
            .onTapGesture {
                isSelected = true
                if isSelected {
                    setData.selectedCatView = self
                }
            }
            .onSubmit {
                isFocused = false
            }
            
            ZStack {
                Rectangle()
                    .frame(width: category.length, height: category.length, alignment: .center)
                    .foregroundColor(isSelected ? Color("viewSelected") : Color("categoryViewBack"))
                    .border(colors[category.index], width: 3)

                ForEach(itemsForCategory.data[category.index]) { item in
                    ItemView(item: item, asDetail: asDetail, showMenu: $showMenu, showMenu_forItem: $showMenu_forItem)
                }
            }
        }
//        .scaleEffect(asDetail ?  CGSize(width: scaleK, height: scaleK) : CGSize(width: 1, height: 1))
//        .position(asDetail ? CGPoint(x: 200, y: 400) : CGPoint(x: category.posX, y: category.posY)) // 画面の中心　: pos
        .zIndex(2)
        .position(CGPoint(x: category.posX, y: category.posY)) // 画面の中心　: pos
        .gesture(drag)
        .onAppear {
//            updateItemsForCategory()
        }
        .onTapGesture {
//            withAnimation {
            
            
            if setData.selectedCatView != nil {
                setData.selectedCatView.isSelected = false
              
            }
            
            isSelected = true
            setData.selectedCatView = self
            
            
            //                if selectedItemView != nil {
            if setData.selectedItemView != nil {
                setData.selectedItemView.isSelected = false
                setData.selectedItemView.item.created = false
                setData.selectedItemView = nil
            }
            
            
            showMenu = true
            showMenu_forItem = false
            
            
            
          

      
        }
 
    }
    
    var drag: some Gesture {
        DragGesture()
       
            .onChanged { value in
                if !moveLocked {
                    if !dragStart {
                        posDiff = CGPoint(x: value.startLocation.x - category.posX , y: value.startLocation.y - category.posY)
                        dragStart = true
                    }
                    
                    category.posX =
                    value.startLocation.x
                    + value.translation.width
                    - posDiff.x
                    
                    category.posY =
                    value.startLocation.y
                    + value.translation.height
                    - posDiff.y
                }
            }
            .onEnded { value in
                if !moveLocked {
                    if !asDetail {
                        
                        category.posX =
                        value.startLocation.x
                        + value.translation.width
                        - posDiff.x
                        
                        category.posY =
                        value.startLocation.y
                        + value.translation.height
                        - posDiff.y
                        
                    }
                    dragStart = false
                }
           
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
    
    init(title: String, posX: CGFloat, posY: CGFloat, length: CGFloat, index: Int) {
        self.title = title
        self.posX = posX
        self.posY = posY
        self.length = length
        self.index = index
    }
    

}





struct CategoryDetailScreen: View {
    
    @EnvironmentObject var setData : ShareData
    
    var itemsForCategory : ItemsForCategory
    
    var category : Category
    
//    @State var titleStr : String

    var body: some View {
        
        VStack {
                        
            Text(category.title)
                .font(.title)
                .foregroundStyle(colors[category.index])
                .padding(.top, 20)
            
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
