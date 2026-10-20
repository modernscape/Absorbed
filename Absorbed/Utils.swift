//
//  Utils.swift
//  Immersion
//
//  Created by forest on 2024/02/05.
//

import SwiftUI
import SwiftData
import Foundation

struct Utils: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Utils()
}

func colorForIndex(_ index: Int) -> Color {
    return index < colors.count ? colors[index] : .gray
}

//func aColor(category: Category) -> Color {
//    return colors.count > category.index ? colors[category.index] : .gray
//}

struct CaptionView: View {
    var str : String
    var body: some View {
        Text(str)
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .font(.system(size: 12))
            .foregroundStyle(.gray)
//            .background(.gray.opacity(0.8))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(.gray, lineWidth: 1)
              
                
            }
        
  
    }
}



//-64, 80
//41, 190
//128, 195


func defaultPos(_ index: Int) -> CGPoint {
    switch index {
    case 0:
        return CGPoint(x: 80, y: -64)
    case 1:
        return CGPoint(x: 40, y: 190)
    case 2:
        return CGPoint(x: 120, y: 190)
    default:
        return CGPoint(x: 0, y: 0)
    }
}



func sameWeek(date1: Date, date2: Date) -> Bool {
    return weekFor(date: date1) == weekFor(date: date2)
}

// String型からDate型への型変換（キャスト）
func stringToDate(dateValue: String, format: String = dateFormatStr) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: dateValue) ?? Date()
}

// Date型からString型への型変換（キャスト）
func dateToString(date: Date, format: String = dateFormatStr) -> String {
//    var date = Date()
//    print(date)
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateStyle = .medium
    dateFormatter.dateFormat = format //"yyyy-MM-dd"
    
//    print(dateFormatter.string(from: date))
    return dateFormatter.string(from: date)
}


// 曜日
func weekdayFor(date: Date) -> Int {
    
    
    // 西暦カレンダー（gregorian）生成
    var calendar = Calendar(identifier: .gregorian)
    
    // カレンダーのlocaleを「日本語、日本地域」に設定
    calendar.locale = Locale(identifier: "ja_JP")
    
    // 生成したカレンダーを使って 2022/7/1 の日付生成
//    let date = calendar.date(from: DateComponents(year: 2022, month: 7, day: 1))
    
    // 対象日付の曜日識別子を取得
    let weekday = calendar.component(.weekday, from: date)     // => 6（金曜日）
    
    // 対象日付の曜日を表示
//    print(calendar.weekdaySymbols[weekday-1])           // "金曜日"
    
    
    
    
    return weekday
}


func isToday(_ index: Int) -> Bool {
    
    var today = index+2
    let weekday = weekdayFor(date: Date())  //  1:日, 2:月, ...  ,6:金, 7:土    
    if index == 6 { // 日
        today = 1
    }
    return weekday == today
}


func spanStr(from: Date, to: Date) -> String {
    var str = ""
    let dateComponentsFormatter = DateComponentsFormatter()
    dateComponentsFormatter.allowedUnits = [.year, .month, .day]
    dateComponentsFormatter.unitsStyle = .brief
    dateComponentsFormatter.maximumUnitCount = 3
    str = dateComponentsFormatter.string(from: from, to: to)!
    
    return str
}


func zeroDate(_ date: Date) -> Date {
    // 今日の日付を取得
    let today = Calendar.current.date(byAdding: .day, value: 0, to: Calendar.current.startOfDay(for: date))!
    return today
}


func resetItemsCount(items: [Item]) {
    for item in items {
        item.todayCount? = 0
    }
}



func saveCountUpdateDateStr() {
    @AppStorage(KeyString.countUpdateDateStr.rawValue) var countUpdateDateStr = ""
    countUpdateDateStr = dateToString(date: Date(), format: dateFormatStr)
}

func countUp(_ phase: Phase) {
    phase.item.todayCount! += 1
    phase.item.count! += 1
    saveCountUpdateDateStr()
}

func countDown(_ phase: Phase) {
    phase.item.todayCount! -= 1
    if phase.item.todayCount! < 0 {
        phase.item.todayCount! = 0
    }

    phase.item.count! -= 1
    if phase.item.count! < 0 {
        phase.item.count! = 0
    }
    saveCountUpdateDateStr()
}


func vivrate(_ type: Int = 0) {
    switch type {
    case 0:
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    case 1:
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    case 2:
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    case 3:
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    default:
        break
//        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}


func updateAllItemCatIndex(ary: [Category]) {
    @Environment(\.modelContext) var modelContext
    
    for i in 0..<ary.count {
        let cat = ary[i]
        cat.index = i
        let items = cat.items
        for j in 0..<items.count {
            let item = items[j]
            item.catIndex = i
        }
    }
    try! modelContext.save()
}


func alignViews(categories: [Category]) {
    @EnvironmentObject var setData : ShareData
    @AppStorage(KeyString.magnifyBy.rawValue) var magnifyBy = 1.0
    
    print("整列！")
    withAnimation {
        categories[0].posY = 20 * magnifyBy
        for i in 1..<categories.count {
            let catPrev = categories[i-1]
            let cat = categories[i]
            cat.posY = catPrev.posY + (catPrev.length/2 * magnifyBy) + (cat.length/2 * magnifyBy) + (space * magnifyBy)
        }
    }
    

      

}


// 今日の目標量
func calcTodayGoal(item: Item, steps: [Step]) -> Int {
    
    if item.stepNumber == 0 {
        return 0
    } else {
        let step = steps[item.stepNumber-1]
        // 残り日数
        let last = step.date.timeIntervalSinceNow
        let lastDay = last/60/60/24
        
        if item.goalCount == nil {
            item.goalCount = 100
        }
        
        return Int(ceil(Double(item.goalCount!) / floor(lastDay)))
    }
}


// その日の週の初めの日
func weekFor(date: Date) -> String {
    let calendar = Calendar.current
    let d = calendar.initialDayOfWeek(date, start: .monday)
    return dateToString(date: d)
}



//extension Calendar {
//    func weekFor(_ date: Date) -> Int {
//        let weekNumber = self.component(.weekOfYear, from: date)
//        return weekNumber
//    }
//}
//

extension Calendar {
    //月曜始まりor日曜始まり
    enum startOfWeek {
        case sunday
        case monday
    }
    
    func initialDayOfWeek(_ date: Date = Date(), start: startOfWeek = .sunday) -> Date {
        //当日0:00の日時を取得
        let am = self.startOfDay(for: date)
        //曜日番号を取得
        let weekNumber = self.component(.weekday, from: am)
        
        if start == .sunday { //日曜始まりの場合
            return self.date(byAdding: .day, value: -(weekNumber - 1), to: am)!
        } else { //月曜始まりの場合
            if weekNumber == 1 {
                return self.date(byAdding: .day, value: -6, to: am)!
            } else {
                return self.date(byAdding: .day, value: -(weekNumber - 2), to: am)!
            }
        }
    }
}


func spanString(toDateString: String) -> String {
    
    //        let birth = stringToDate(dateValue: birthDayStr, format: dateFormatStr)
    let limitDate = stringToDate(dateValue: toDateString, format: dateFormatStr)
    let span = limitDate.timeIntervalSince(Date()) // 1209600秒差
    //        let daySpan : TimeInterval = span // 14 (日)
    
    //        let time:TimeInterval = 3661
    
    let dateFormatter = DateComponentsFormatter()
    dateFormatter.unitsStyle = .full
    dateFormatter.allowedUnits = [.year, .month, .day]
    //        dateFormatter.allowedUnits = [.year, .month ,.day,.hour, .minute, .second]
    
    
    return dateFormatter.string(from: span)!
    
}





//func fetchTodayItems() -> [String] { //-> [Item] {
//    
//    
//    @Environment(\.modelContext) var modelContext
// 
//    
//    var descriptor = FetchDescriptor<Item>()
//    var strs = [String]()
//    //        let tripName = trip.name
//    descriptor.predicate = #Predicate { item in
//        item.stepNumber == 1
//    }
//    if let filteredList = try? modelContext.fetch(descriptor) {
//        for i in filteredList {
//            //                str += " \(i.title)"
//            strs.append(i.title)
//        }
//    }
//    
//    print(strs)
//    
//    
//    return strs
//    //        return filteredList!
//}

// 【SwiftUI】袋文字を作る(Textに外枠を付ける)

//import SwiftUI

struct StrokeBackground: ViewModifier {
    private let id = UUID()
    
    private var strokeSize: CGFloat
    
    private var strokeColor: Color
    
    init(strokeSize: CGFloat, strokeColor: Color) {
        self.strokeSize = strokeSize
        self.strokeColor = strokeColor
    }
    
    func body(content: Content) -> some View {
        if strokeSize > 0 {
            strokeBackgroundView(content: content)
        } else {
            content
        }
    }
    
    private func strokeBackgroundView(content: Content) -> some View {
        content
            .padding(strokeSize * 2)
            .background(strokeView(content: content))
    }
    
    private func strokeView(content: Content) -> some View {
        Rectangle()
            .foregroundColor(strokeColor)
            .mask(maskView(content: content))
    }
    
    private func maskView(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { ctx in
                if let resolvedView = context.resolveSymbol(id: id) {
                    ctx.draw(resolvedView, at: .init(x: size.width / 2, y: size.height / 2))
                }
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}

extension View {
    public func stroke(color: Color, width: CGFloat = 1) -> some View {
        modifier(StrokeBackground(strokeSize: width, strokeColor: color))
    }
}


//
//extension Sequence {
//    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
//        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
//    }
//    
//    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T?>) -> [Element] {
//        sorted {
//            guard let l = $0[keyPath: keyPath],
//                  let r = $1[keyPath: keyPath] else { return false }
//            return l < r
//        }
//    }
//}


/* ----------------------------------------------------------------------------
 MARK: - onWillDisappear の対応手順
 ------------------------------------------------------------------------------*/

struct ViewWillDisappearHandler: UIViewControllerRepresentable {
    func makeCoordinator() -> ViewWillDisappearHandler.Coordinator {
        Coordinator(onWillDisappear: onWillDisappear)
    }
    
    let onWillDisappear: () -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewWillDisappearHandler>) -> UIViewController {
        context.coordinator
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ViewWillDisappearHandler>) {
    }
    
    typealias UIViewControllerType = UIViewController
    
    class Coordinator: UIViewController {
        let onWillDisappear: () -> Void
        
        init(onWillDisappear: @escaping () -> Void) {
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
    }
}


struct ViewWillDisappearModifier: ViewModifier {
    let callback: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(ViewWillDisappearHandler(onWillDisappear: callback))
    }
}


extension View {
    func onWillDisappear(_ perform: @escaping (() -> Void)) -> some View {
        self.modifier(ViewWillDisappearModifier(callback: perform))
    }
}


/* ----------------------------------------------------------------------------
 MARK: - onWillAppear の対応手順
 ------------------------------------------------------------------------------*/
struct ViewWillAppearHandler: UIViewControllerRepresentable {
    func makeCoordinator() -> ViewWillAppearHandler.Coordinator {
        Coordinator(onWillAppear: onWillAppear)
    }
    
    let onWillAppear: () -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewWillAppearHandler>) -> UIViewController {
        context.coordinator
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ViewWillAppearHandler>) {
    }
    
    typealias UIViewControllerType = UIViewController
    
    class Coordinator: UIViewController {
        let onWillAppear: () -> Void
        
        init(onWillAppear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
    }
}


struct ViewWillAppearModifier: ViewModifier {
    let callback: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(ViewWillAppearHandler(onWillAppear: callback))
    }
}


extension View {
    func onWillAppear(_ perform: @escaping (() -> Void)) -> some View {
        self.modifier(ViewWillAppearModifier(callback: perform))
    }
}
