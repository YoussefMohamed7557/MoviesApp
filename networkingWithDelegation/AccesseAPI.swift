//
//  AccesseAPI.swift
//  networkingWithDelegation
//
//  Created by Yossef on 3/17/21.
//  Copyright © 2021 Yossef. All rights reserved.
//

import Foundation
import Reachability
class AccessAPI {
    
    var PathMovieArrayProtocolReferece : PathMovieArrayProtocol?
    let reachability = try! Reachability()
    init(delegationReference theReference:PathMovieArrayProtocol) {
        PathMovieArrayProtocolReferece = theReference
    }
    
    func connectAPIWithURL(URLstring str : String)  {
        //=========== in case of connection is reachable ==========//
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("API is Reachable via WiFi")
                
        //=========== 1- create url object  ================================================//
        let myURL = URL(string: str )

        //=========== 2- create requist object =============================================//
        let myRequist = URLRequest(url: myURL!)

        //=========== 3 create session configuration object ================================//
        let mySession = URLSession(configuration: URLSessionConfiguration.default)

        //=========== 4- create task object ================================================//
        let task = mySession.dataTask(with: myRequist) { (JSONDataParameter , responseParameter , errorParameter) in
            do{
                //=============== GET DATA FROM JSON ============================//
                
               let JSONArray = try (JSONSerialization.jsonObject(with: JSONDataParameter!, options: .allowFragments)as! [Dictionary<String, Any>])
                
                //=============== PATH DATA TO MOVIE ARRAY ======================//
               print("in do")
                var movieArray : [Movie] = [Movie]()
                for item in JSONArray{
       
                    let tempMovie :Movie = Movie(title: ( item["title"] as! String) , rate:  (item["rating"] as! Double), releaseYear: (item["releaseYear"]as! Int) , image: (item["image"] as! String), genre: (item["genre"] as! [String]))
                        movieArray.append(tempMovie)
                    print("number of elements in movies array = \(movieArray.count)")
                }
                
                //============= PATH MOVIE ARRAY TO DELEGATION METHOD =============//
                DispatchQueue.main.async {
                    self.PathMovieArrayProtocolReferece!.pathMovieArray(JSONArray: movieArray)
                }
            } catch let error{
                print(error)
            }
        }
        
        //=========== 5- start connection ...! ================================================//
        task.resume()
            } else {
                print("API is not reachable")
            }
  }
}
}
/*
 reachability.whenReachable = { reachability in
 if reachability.connection == .wifi {
 print("Reachable via WiFi")
 
 } else {
 print("Reachable via Cellular")
 }
 }
 reachability.whenUnreachable = { _ in
 print("Not reachable")
 }
 do {
 try reachability.startNotifier()
 } catch {
 print("Unable to start notifier")
 }
*/
