//
//  MyWidget.swift
//  MyWidget
//
//  Created by Alondra García Morales on 25/10/23.
//

import WidgetKit
import SwiftUI

///Modelo var
///Time line entry, nececitamos este protoclolo para decirle que lo campos o datos que vamos a utilizar se estaran en un widget
///el var date es obligatorio utilizarlo
struct Modelo : TimelineEntry{
    var date: Date
    var widgetData : [JsonData]
}

struct JsonData: Decodable{
    var id : Int
    var name, email : String
}


///Provider inicializa el widget y la logica principal
///el typealias es necesario ya que crea un puente entre el modelo y la vista
///la funcion placeholder nos retorna nuestro modelo, le estamos diciendo que modelo se estara utilizando en nuestro widget
///la funcion getSnapshot, nos da el tipo de dato que se utilizara en wl widget, lo completa
///la funcion getTimeLine, es odne llenamos los datos que se veran en el wodget
struct Provider : TimelineProvider{
    
    func placeholder(in context: Context) -> Modelo {
        return Modelo(date: Date(), widgetData: Array(repeating: JsonData(id: 0, name: "", email: ""), count: 2))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Modelo) -> Void) {
        completion(Modelo(date: Date(), widgetData: Array(repeating: JsonData(id: 0, name: "", email: ""), count: 2)))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Modelo>) -> Void) {
        
        getJson{ (modelData) in
            let data = Modelo(date: Date(), widgetData: modelData)
            guard let update = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) else {return}
            let timeline = Timeline(entries: [data], policy: .after(update))
            completion(timeline)
        }
    }
    
    typealias Entry = Modelo
    
    
}

func getJson(completion: @escaping([JsonData]) -> ()){
    guard let url  = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=1") else {return}
    
    URLSession.shared.dataTask(with: url){data,_,_ in
        guard let data = data else {return}
        
        do {
            let json = try JSONDecoder().decode([JsonData].self, from: data)
            DispatchQueue.main.async{
                completion(json)
            }
        }catch let error as NSError{
            print("fallo", error.localizedDescription)
        }
    }.resume()
}
///Diseño del widget (vista)

struct vista: View {
    
    let entry : Provider.Entry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View{
        
        switch family {
        case .systemSmall:
            VStack(alignment: .center){
                Text("Mi Lista")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                Spacer()
                Text(String(entry.widgetData.count)).font(.custom("Arial", size: 80)).bold()
                Spacer()
            }
        case .systemMedium:
            VStack(alignment: .center){
                Text("Mi Lista")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                Spacer()
                VStack(alignment: .leading){
                    Text(entry.widgetData[0].name).bold()
                    Text(entry.widgetData[0].email)
                    Text(entry.widgetData[1].name).bold()
                    Text(entry.widgetData[1].email)
                }.padding(.leading)
                Spacer()
            }
        default:
            VStack(alignment: .center){
                Text("Mi Lista")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                Spacer()
                VStack(alignment: .leading){
                    ForEach(entry.widgetData, id:\.id){ item in
                        Text(item.name).bold()
                        Text(item.email)
                    }
                }.padding(.leading)
                Spacer()
            }
            
        }
    }
}



///configutacion es la parte donde tendremas el tamaño del widget

@main
struct HelloWidget : Widget{
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind: "Widget", provider: Provider()) {entry in
            vista(entry : entry)
        }.description("Description of widget")
         .configurationDisplayName("Name of the widget")
         .supportedFamilies([.systemSmall,.systemMedium, .systemLarge])
         .contentMarginsDisabled()
    }
}
