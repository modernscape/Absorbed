/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view modifier for showing sample data in previews.
*/

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: 
                Item.self,
                Category.self,
                Want.self,
                Keyword.self,
                Step.self,
                Dislike.self,
                Phase.self,
                BenefitImage.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<Category>()).isEmpty {
            
            SampleDeck.contents.forEach {                
                container.mainContext.insert($0)
            }
            
//            SampleItems.contents.forEach {
//                container.mainContext.insert($0)
//            }
                         
            SampleWants.contents.forEach {
                container.mainContext.insert($0)
            }
            
            SampleKeywords.contents.forEach {
                container.mainContext.insert($0)
            }
            
            SampleSteps.contents.forEach {
                container.mainContext.insert($0)
            }
            
            SamplePhases.contents.forEach {
                container.mainContext.insert($0)
            }
            
            SampleDislikes.contents.forEach {
                container.mainContext.insert($0)
            }

        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()


//struct SamplePhases {
//    static var contents: [Phase] = [
//        Phase(item: item_00, index: 0, title: "知識\n（本、ニュース）"), // 投資
//        Phase(item: item_00, index: 1, title: "元本づくり\n（1,000万円）"),
//        Phase(item: item_00, index: 2, title: "試行錯誤の繰り返し"),
//        Phase(item: item_00, index: 3, title: "資産1億"),
//        
//        Phase(item: item_22, index: 0, title: "毎日10分（家）"), // 筋トレ
//        Phase(item: item_22, index: 1, title: "・ジム\n・プロテイン"),
//        Phase(item: item_22, index: 2, title: "ジムのウェイト全制覇"),
//        
//        Phase(item: item_10, index: 0, title: "学習とサンプル作成"),
//        Phase(item: item_10, index: 1, title: "CWで集客"),
//        Phase(item: item_10, index: 2, title: "受注")
//    ]
//}



//Category.self,
//                    Item.self,
//                    Want.self,
//                    Keyword.self,
//                    Step.self,
//                    Dislike.self,
//                    Phase.self
