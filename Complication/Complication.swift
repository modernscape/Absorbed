//
//  Complication.swift
//  Complication
//
//  Created by forest on 2023/12/21.
//

import WidgetKit
import SwiftUI
//import WatchConnectivity

//let _ud = UserDefaults(suiteName: "group.com.BreakThroughWorks.Synergy.watchkitapp")


//enum KeyString: String {
//
//    case per_A
//    case per_B
//   
//}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Dreamer")]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct ComplicationEntryView : View {
    

  
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .accessoryCorner:
            CornerComplication()
        case .accessoryCircular:
            CircularComplication()
        case .accessoryInline:
            InlineComplication()
        case .accessoryRectangular:
            RectangularComplication()
        @unknown default:
            Text("No　Complication")
        }
        

        
//        VStack {
//            HStack {
//                Text("Time2:")
//                Text(entry.date, style: .time)
//            }
//
//            Text("Favorite Emoji:")
//            Text(entry.configuration.favoriteEmoji)
//        }
    }
}


struct InlineComplication : View {
    var body: some View {
        Text("Dreamer")
            .font(.system(size: 12.0))
            .onReceive(timer) { _ in
                print("timer!")
            }
        
        
    }
}





struct CircularComplication : View {
    
    @Environment(\.widgetRenderingMode) var renderingMode
    
//    var body: some View {
//        Text("CircularComp")
//            .font(.system(size: 12.0))
//    }
//
    var body: some View {
    
        if renderingMode == .fullColor {
            // フルカラーの画像
            Image("CircularComplication")
                .resizable()
                .scaledToFit()
                .widgetLabel {
                    Text("Dreamer")
                }
        } else {
            // アルファチャネルに画像を用意した画像
            Image("CircularComplication_alpha")
                .resizable()
                .scaledToFit()
                .widgetAccentable() // アクセント色に追従
                .widgetLabel {
                    Text("Dreamer")
                }
        }
        
        
        
//        Image("CircularComplication_alpha")
//            .widgetAccentable() // アクセント色に追従
//            .widgetLabel {
//                Text("Dreamer")
//            }

    }
    

    
    
    
}

struct CornerComplication : View {

    
    @Environment(\.widgetRenderingMode) var renderingMode
//    @AppStorage(KeyString.per_A.rawValue) var per_A : Int = 0
//    @AppStorage(KeyString.per_B.rawValue) var per_B : Int = 0
    @State var count = 0
    @State var per_A : Int = 0
    @State var per_B : Int = 0
    
   
    
    
    var body: some View {
        
        

        if renderingMode == .fullColor {
            
            Image("CircularComplication_corner")
                .resizable()
                .widgetLabel {
                    Text("Dreamer")
                }
            
            
//            Text("🐶")
//                .font(.system(size: 20.0))
//                .widgetLabel {
//                    Text("Dreamer")
//                }
            
            
            // フルカラーの画像
//            Image("CircularComplication")
//                .resizable()
//                .scaledToFit()
        } else {
            
            
            Image("CircularComplication_corner_alpha")
                .resizable()
                .widgetAccentable() // アクセント色に追従
                .widgetLabel {
                    Text("Dreamer")
                }
            
            // アルファチャネルに画像を用意した画像
//            Image("CircularComplication_corner_alpha")
//                .resizable()
//                .scaledToFit()
//                .widgetAccentable() // アクセント色に追従
        }
        
        
//        Text("\(per_A)")
//        Image("CircularComplication")
//            .widgetCurvesContent()
//            .widgetLabel("\(per_A*100) + \(per_B*100)%")
//            .scaledToFit()
//            .widgetAccentable() // アクセント色に追従
//            .widgetLabel {
//                Gauge(value: 50,
//                      in: 0 ... 100) {
//                } currentValueLabel: {
//                    Text("\(per_A) + \(per_B)%")
//                }
//
//            }
//            .onReceive(timer) { _ in
//
//                per_A = Int(_ud!.double(forKey: KeyString.per_A.rawValue)*100)
//
//
//            }

        

        
//        if renderingMode == .fullColor {
//
//
//
//
//
//
//
//            Text("\(per_A) + \(per_B)%")
//                .widgetCurvesContent()
//                .widgetLabel("World!")
//
//                .scaledToFit()
//                .widgetAccentable() // アクセント色に追従
//                .widgetLabel {
//                    Gauge(value: Float(per_A + per_B)*100,
//                          in: 0 ... 100) {
//                    } currentValueLabel: {
//                        Text("\(per_A) + \(per_B)%")
//                    }
//
//                }
//
//        } else {
//            // アルファチャネルに画像を用意した画像
//
//
//            Image("CircularComplication_corner_alpha")
//                .resizable()
//                .scaledToFit()
//                .widgetAccentable() // アクセント色に追従
//                .widgetLabel {
//                    Gauge(value: Float(per_A + per_B)*100,
//                          in: 0 ... 100) {
//                    } currentValueLabel: {
//                        Text("\(per_A) + \(per_B)%")
//                    }
//
//                }
//
//        }
        
        
         
    }
}



struct RectangularComplication : View {
    
    @Environment(\.widgetRenderingMode) var renderingMode
    
    var body: some View {
        
        
        HStack(alignment: .center) {
            
            if renderingMode == .fullColor {
                // フルカラーの画像
                Image("CircularComplication")
                    .resizable()
                    .scaledToFit()
            } else {
                // アルファチャネルに画像を用意した画像
                Image("CircularComplication_alpha")
                    .resizable()
                    .scaledToFit()
                    .widgetAccentable() // アクセント色に追従
            }
            Spacer()
            Text("Dreamer")
                .font(.system(size: 18.0))
            Spacer()
        }
    }
}


@main
struct Complication: Widget {
    let kind: String = "Complication"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ComplicationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    Complication()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
