//
//  APIRequest.swift
//  ridesharing
//
//  Created by Sebastian Wagner on 22.04.17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIRequest
{
    let baseUrl = ""
    let lang = "en"
    
    
    func sendRequest(session: Int, request: String, callback: @escaping (String) -> ())
    {
        let escapedRequest = request.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //let queryUrl = baseUrl+"query="+escapedRequest!
        //let completeUrl = queryUrl+"&lang="+lang+"&sessionId="+String(session)
        let url = URL(string: baseUrl)
        print(request);
        var urlRequest = URLRequest(url: url!) //make a request out of the URL
        urlRequest.httpMethod = "POST"
        let postString = "user_id="+String(session)+"&input="+escapedRequest!
        urlRequest.httpBody = postString.data(using: .utf8)
        //urlRequest.setValue("Bearer "+clientKey, forHTTPHeaderField: "Authorization")//set HTTP auth header
        let session = URLSession.shared
        //perform data request
        let task = session.dataTask(with: urlRequest) { data, response, error in
            //Json Datei, erzeugt von Chatbot, wird hier ausgelesen
            if let returnedData = data
            {
                print("Data has been returned.")
                let json = JSON(data: returnedData)
                if let result = json["result"]["speech"].string {
                    //Now you got your value
                    print("The response from Watson was retrieved and is: ")
                    print(result)
                    callback(result) //The result will be accessible via the variable resultResponse
                }
            }
            
        }
        task.resume()
    }
        
    

}
