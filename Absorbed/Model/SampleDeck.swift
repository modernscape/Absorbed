/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Sample cards to use during development.
*/
import Foundation

//　初期item
let item_00 = Item(title: "投資", posX :90, posY: 50, length: 90, stepNumber: 1, hasPhase: true, catIndex: 0, benefitList: "仕事をやめられる")
let item_01 = Item(title: "起業", posX :50, posY: 145, length: 50, catIndex: 0)
let item_02 = Item(title: "商品", posX :140, posY: 150, length: 65, stepNumber: 2, catIndex: 0)


let item_10 = Item(title: "執筆", posX :90, posY: 50, length: 80, stepNumber: 1, hasPhase: true, catIndex: 1, benefitList: "自分を表現できる")
let item_11 = Item(title: "建築", posX :50, posY: 145, length: 50, stepNumber: 4, catIndex: 1)
let item_12 = Item(title: "キャンプ", posX :140, posY: 150, length: 65, catIndex: 1)

let item_20 = Item(title: "食事", posX :90, posY: 50, length: 80, continuing: true, catIndex: 2)
let item_21 = Item(title: "ヨガ", posX :50, posY: 145, length: 50, stepNumber: 3, catIndex: 2)
let item_22 = Item(title: "筋トレ", posX :140, posY: 150, length: 85, stepNumber: 1, hasPhase: true, catIndex: 2, benefitList: "人にかっこいい体と思われる")

//let phase_000 = Phase(item: item_00  , index: 0, title: "投資1")
//let phase_001 = Phase(item: item_00  , index: 1, title: "投資2")
//let phase_002 = Phase(item: item_00  , index: 2, title: "投資3")



//let cat0 = Category(title: "お金", posX: 100, posY: 100, length: 200, index: 0, items: [item_00, item_01, item_02])

struct SampleDeck {
    static var contents: [Category] = [
        Category(title: "お金", posX: 0, posY: 120, length: 200, index: 0, items: [item_00, item_01, item_02]),
        Category(title: "ライフワーク", posX: 0, posY: 130, length: 200, index: 1, items: [item_10, item_11, item_12]),
        Category(title: "健康", posX: 0, posY: 160, length: 200, index: 2, items: [item_20, item_21, item_22])
    ]
    

}

//struct SampleItems {
//    static var contents: [Item] = [
//        item_00,
//        item_01,
//        item_02,
//        item_10,
//        item_11,
//        item_12,
//        item_20,
//        item_21,
//        item_22
//    ]
//}


struct SampleWants {
    static var contents: [Want] = [
        Want(title: "お金持ちになる", isWant: true, index: 0),
        Want(title: "高い月収", isWant: true, index: 1),
        Want(title: "モノを持たない", isWant: true, index: 2),
        Want(title: "パートナー", isWant: true, index: 3),
        Want(title: "扱う金額の桁を変える", isWant: true, index: 4),
        Want(title: "環境の良いところに住む", isWant: true, index: 5),
        Want(title: "自分も嬉しい他者も嬉しい", isWant: true, index: 6),
        
        Want(title: "お金に不自由な生活", isWant: false, index: 0),
        Want(title: "能力がない", isWant: false, index: 1),
        Want(title: "ストレスの多い仕事", isWant: false, index: 2),
        Want(title: "単価の安い仕事", isWant: false, index: 3),
        Want(title: "不安の多い仕事", isWant: false, index: 4),
        Want(title: "ムダな時間があること", isWant: false, index: 5),
        Want(title: "要らないモノを持っている", isWant: false, index: 6),
        Want(title: "満員電車", isWant: false, index: 7)
    ]
}

struct SampleKeywords {
    static var contents: [Keyword] = [
        Keyword(title: "貢献", isWant: true, index: 0),
        Keyword(title: "シンプルな生き方", isWant: true, index: 1),
        Keyword(title: "環境", isWant: true, index: 2),
        Keyword(title: "パートナー", isWant: true, index: 3),
        Keyword(title: "お金", isWant: true, index: 4),
        Keyword(title: "クリエイティブ", isWant: true, index: 5),
        Keyword(title: "心身の健康", isWant: true, index: 6),
        Keyword(title: "時間", isWant: true, index: 7),
        Keyword(title: "単価が高い", isWant: true, index: 8),
        
        Keyword(title: "ストレス", isWant: false, index: 1),
        Keyword(title: "低所得", isWant: false, index: 2),
        Keyword(title: "不安", isWant: false, index: 3),
        Keyword(title: "能力がない", isWant: false, index: 4),
        Keyword(title: "単価が低い", isWant: false, index: 5)
    ]
}



/// カレンダーを生成
let calendar = Calendar(identifier: .gregorian)    // 西暦（gregorian）カレンダー

// 2020/04/10 21:00:00 の日時を生成
let date_0 = calendar.date(from: DateComponents(year: 2024, month: 5, day: 15, hour: 0, minute: 0, second: 0))
let date_1 = calendar.date(from: DateComponents(year: 2024, month: 6, day: 30, hour: 0, minute: 0, second: 0))
let date_2 = calendar.date(from: DateComponents(year: 2024, month: 12, day: 31, hour: 0, minute: 0, second: 0))
let date_3 = calendar.date(from: DateComponents(year: 2030, month: 6, day: 15, hour: 0, minute: 0, second: 0))
let date_4 = calendar.date(from: DateComponents(year: 2050, month: 6, day: 15, hour: 0, minute: 0, second: 0))






struct SampleSteps {
    static var contents: [Step] = [
        Step(index: 0, date: date_0!, span: Date()),
        Step(index: 1, date: date_1!, span: Date()),
        Step(index: 2, date: date_2!, span: Date()),
        Step(index: 3, date: date_3!, span: Date()),
        Step(index: 4, date: date_4!, span: Date()),

    ]
}



struct SamplePhases {
    static var contents: [Phase] = [
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
}


struct SampleDislikes {
    static var contents: [Dislike] = [
        Dislike(title: "モノが多い", index: 0),
        Dislike(title: "能力がない", index: 1),
        Dislike(title: "満員電車", index: 2),
        Dislike(title: "単価の安い仕事", index: 3)
    ]
}


