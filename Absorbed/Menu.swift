//
//  Menu.swift
//  Immersion
//
//  Created by forest on 2024/02/04.
//

import SwiftUI
import SwiftData


struct MenuView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query (
        sort: [
            SortDescriptor(\Category.index, order: .forward)
        ]
    ) var categories: [Category]
    
//    @Query private var items: [Item]
    
    //    @EnvironmentObject var categoryData : CategoryData
    
    @EnvironmentObject var setData : ShareData
    
//    @State var itemsForCategory : ItemsForCategory
    
    @State var showSheet = false
    
    @State var showStepScreen = false
    
//    var item : Item
    
    //    @Binding var sliderVal : Double
    
    var forItem : Bool = false
    
    private func deleteCategory(_ cat: Category) {
        withAnimation {
            for item in cat.items {
                modelContext.delete(item)
            }
            modelContext.delete(cat)
            try! modelContext.save()
            updateAllItemCatIndex(ary: categories)
            alignViews(categories: categories)
            setData.resetSelection()
        }
    }
    

    
    private func deleteItem(_ item: Item) {
        withAnimation {
            modelContext.delete(item)
            try! modelContext.save()
//            alignViews(categories: categories)
            setData.resetSelection()
            
        }
    }
    
    private func deleteItemOfCategory(_ cat: Category, item: Item) {
        if let index = cat.items.firstIndex(of: item) {
            cat.items.remove(at: index)
        }
    }
    
    
    
    
//    func deleteFromItemsForCategory() {
//        withAnimation {
//            if setData.selectedItemView != nil {
//                let item = setData.selectedItemView.item
//                if let index = itemsForCategory.data[item.catIndex].firstIndex(of: item) {
//                    itemsForCategory.data[item.catIndex].remove(at: index)
//                }
//            }
//        }
//       
//    }
//    
    
    func duplicateItem() {
        
    }
    
    func addToStep() {
        
    }
    
    func doneItem() {
   
        if setData.selectedItemView != nil {
            
            withAnimation {
                setData.selectedItemView.item.isDone.toggle()
                //            setData.selectedItemView.isSelected = false
                //            setData.selectedItemView = nil
                
                //            try! modelContext.save()
            }
            
            
        }

    }
    
    
    @State  var opacity: Double = 0
    
    @State private var isSliding : Bool = false
    
    func upfateValue() {
        if setData.selectedCatView != nil {
            deleteCategory(setData.selectedCatView.category)
            //                        selectedCatView.deleteCategory()
        } else {
            //                        setData.setData.selectedCatView.deleteItem()
            deleteItem(setData.selectedItemView.item)
        }
    }
    
    
    
//    func sliderChanged() {
////        print("Slider value changed to \(setData.selectedItemView.item.length)")
////        print("Slider value changed to \(setData.selectedCatView.category.length)")
//    }
    
    @State var sliderChanging = false
    @State var cancelAlign = false
    
    let alignInterval = 0.6
    
    @State var timer : Timer!
    @State var time : TimeInterval!
    
    func startTimer() {
        timer?.invalidate()
        time = 0
        
//        var count = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            time += 0.2
//            print(count)
        }
        
//        print(time)
//        return time
    }
    
    
    var body: some View {
        
        
        VStack {
      
            if setData.selectedItemView != nil  {
                Slider(value: Binding(get: {
                    
                    if setData.selectedItemView != nil {
                        setData.selectedItemView.item.length
                        
                    } else {
                        50
                    }
                }, set: { (newVal) in
                    
          

                    if setData.selectedItemView != nil {
                        setData.selectedItemView.item.length = newVal
                    }
                    
                    startTimer()
                
                    let delay = alignInterval
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
  
                        if time >= alignInterval-0.2 {
                            alignViews(categories: categories)
                            setData.resetSelection()
                            
                  
                        }
                    }
                    
                }), in: 40...150)
                .padding(.all)
                
            }
            
            
            if setData.selectedCatView != nil {
                Slider(value: Binding(get: {
                    
                    if setData.selectedCatView != nil {
                        setData.selectedCatView.category.length
                        
                    } else {
                        150
                    }

                }, set: { (newVal) in
                    
                    if setData.selectedCatView != nil {
                        setData.selectedCatView.category.length = newVal
                    }
                    
                    startTimer()
                    
                    let delay = alignInterval
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
       
                        if time >= alignInterval-0.2 {
                            alignViews(categories: categories)
                            setData.resetSelection()
               
                        }
                    }

                }), in: 200...350)
                .padding(.all)
                .tint(.red)
            }
            
            
            HStack(spacing: 30) {
                
                Image(systemName: "pencil.line")
                    .onTapGesture {
                        showSheet = true
                    }
                    .sheet(isPresented: $showSheet) {
                        if setData.selectedCatView != nil {
                            
                            CategoryDetailScreen(category: setData.selectedCatView.category)
//                                                    CategoryDetailScreen(itemsForCategory: itemsForCategory, category: selectedCatView.category)
                        } else {
                            ItemDetailScreen(item: setData.selectedItemView.item)
                        }
                    }
                
                Image(systemName: "trash")
                    .onTapGesture {
                        if setData.selectedCatView != nil {
                            deleteCategory(setData.selectedCatView.category)
                    
                        } else {
                  

                            deleteItemOfCategory(categories[setData.selectedItemView.item.catIndex], item: setData.selectedItemView.item)
                
//                                deleteFromItemsForCategory()
                                deleteItem(setData.selectedItemView.item)
                                
                            withAnimation {
//                                setData.resetSelection()
//                                setData.selectedItemView.isSelected = false
//                                setData.selectedItemView = nil
                       
                            }
                            
                        
                        }
                    }
                
                Image(systemName: "plus.square.on.square")
                
           
                if forItem {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .onTapGesture {
                            showStepScreen = true
                            
                        }
                    
                        .sheet(isPresented: $showStepScreen) {
                            StepsScreen(forAddItem: true)
                            
                        }
                    
                    
                    Image(systemName: "checkmark.circle")
                        .onTapGesture {
                            doneItem()
                        }
                }
                
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color("menu"))
            .cornerRadius(20)
            .offset(y: -10)
            .onAppear {
                
                
            }
            
            
        }
        
        
        
    }
}


//#Preview {
//    MenuView()
//        .environmentObject(ShareData())
//        .modelContainer(for: Item.self)
//}
