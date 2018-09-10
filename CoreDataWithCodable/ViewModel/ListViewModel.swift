//
//  ListViewModel.swift
//  CoreDataWithCodable
//
//  Created by Pratik Lad on 10/09/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ListViewModel {
    
    ///closure use for notifi
    var reloadList = {() -> () in }
    var errorMessage = {(message : String) -> () in }
    
    ///Array of List Model class
    var arrayOfList : [List] = []{
        ///Reload data when data set
        didSet{
            reloadList()
        }
    }
    
    ///get data from api
    func getListData()  {
        guard let listURL = URL(string: "https://jsonplaceholder.typicode.com/posts/")else {
            return
        }
        URLSession.shared.dataTask(with: listURL){
            (data,response,error) in
            guard let jsonData = data else { return }
            DispatchQueue.main.async {
                self.parseResponse(forData: jsonData)
            }
        }.resume()
    }
    
    ///parse response using decodable and store data 
    func parseResponse(forData jsonData : Data)  {
        do {
            guard let codableContext = CodingUserInfoKey.init(rawValue: "context") else {
                fatalError("Failed context")
            }
            
            let manageObjContext = appDelegate.persistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[codableContext] = manageObjContext
            // Parse JSON data
            _ = try decoder.decode([List].self, from: jsonData)
            ///context save
            try manageObjContext.save()
            UserDefaults.standard.set(true, forKey: "isAllreadyFetch")
            self.fetchLocalData()
        } catch let error {
            print("Error ->\(error.localizedDescription)")
            self.errorMessage(error.localizedDescription)
        }
    }
    
    ///Local data fetch from core data
    func fetchLocalData()  {
        let manageObjContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<List>(entityName: "List")
        ///Sort by id
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            self.arrayOfList = try manageObjContext.fetch(fetchRequest)
        } catch let error {
            print(error)
            self.errorMessage(error.localizedDescription)
        }
    }
    
}
