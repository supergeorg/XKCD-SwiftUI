//
//  PersistentStore.swift
//  XKCD
//
//  Created by Georg Meissner on 15.07.20.
//

import Foundation
import CoreData

struct XKCDComicjson: Codable {
    let month: String
    let num: Int
    let link: String
    let year: String
    let news: String
    let safe_title: String
    let transcript: String
    let alt: String
    let img: String
    let title: String
    let day: String
}


final class PersistentStore: ObservableObject {
    static let shared = PersistentStore()
    
    func fetchComics() -> NSFetchRequest<XKCDComic>{
        let request: NSFetchRequest<XKCDComic> = XKCDComic.fetchRequest()
        let sortTitle = NSSortDescriptor(key: "num", ascending: true)
        request.sortDescriptors = [sortTitle]
        let sortComicFav = NSSortDescriptor(key: "favourite", ascending: false)
        let sortComicNumber = NSSortDescriptor(key: "num", ascending: false)
        request.sortDescriptors = [sortComicFav, sortComicNumber]
        return request
    }
    
    func loadXKCDComic(number: Int? = nil, userCompletionHandler: @escaping (XKCDComicjson?, Error?) -> Void) {
        
        let url = (number == nil) ? URL(string: "https://xkcd.com/info.0.json")!:URL(string: "https://xkcd.com/\(String(number!))/info.0.json")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let comicjson = try decoder.decode(XKCDComicjson.self, from: data)
                userCompletionHandler(comicjson, nil)
            } catch let parseErr {
                print("JSON Parsing Error", parseErr)
                userCompletionHandler(nil, parseErr)
            }
        })
        task.resume()
    }
    
    func checkIfComicExists(num: Int, managedObjectContext: NSManagedObjectContext) -> Bool {  
        let fetchRequest: NSFetchRequest<XKCDComic> = XKCDComic.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "num = %d", num)
        
        var results: [XKCDComic] = []
        
        do {
            results = try managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func getNewestComicNumber(userCompletionHandler: @escaping (Int?, Error?) -> Void) {
        
        let url = URL(string: "https://xkcd.com/info.0.json")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let comicjson = try decoder.decode(XKCDComicjson.self, from: data)
                let newestNum = comicjson.num
                userCompletionHandler(newestNum, nil)
            } catch let parseErr {
                print("JSON Parsing Error", parseErr)
                userCompletionHandler(nil, parseErr)
            }
        })
        task.resume()
    }
    
    func addComic(context: NSManagedObjectContext, number: Int) {
        if !self.checkIfComicExists(num: number, managedObjectContext: context) {
            loadXKCDComic(number: number, userCompletionHandler: { comic, error in
                let comicentityName = "XKCDComic"
                guard let newcomicEntity = NSEntityDescription.entity(forEntityName: comicentityName, in: context) else {return}
                
                let newComic = NSManagedObject(entity: newcomicEntity, insertInto: context)
                let id = UUID()
                newComic.setValue(id, forKey: "id")
                var comicdatec = DateComponents()
                comicdatec.year = Int(comic!.year)
                comicdatec.month = Int(comic!.month)
                comicdatec.day = Int(comic!.day)
                let comicdate = Calendar.current.date(from: comicdatec)!
                newComic.setValue(comicdate, forKey: "date")
                newComic.setValue(comic?.num, forKey: "num")
                newComic.setValue(comic?.link, forKey: "link")
                newComic.setValue(comic?.news, forKey: "news")
                newComic.setValue(comic?.safe_title, forKey: "safe_title")
                newComic.setValue(comic?.transcript, forKey: "transcript")
                newComic.setValue(comic?.alt, forKey: "alt")
                newComic.setValue(URL(string: comic!.img), forKey: "img")
                newComic.setValue(comic?.title, forKey: "title")
                newComic.setValue(false, forKey: "favourite")
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            })
        } else {}//print("comic exists")}
    }
    
    func addAllComics(context: NSManagedObjectContext) {
        getNewestComicNumber(userCompletionHandler: { newestnumber, error in
            // Comic 404 doesn't exist, it's a joke.
            for number in (1...(newestnumber ?? 1)).reversed() where number != 404{
            //for number in stride(from: newestnumber ?? 1, to: 1, by: -1){
                self.addComic(context: context, number: number)
            }
        })
    }
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "XKCD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
