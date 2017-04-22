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
    let baseUrl: String = "http://46.101.236.70/chat"
    let lang: String = "en"
    
    
    func sendRequest(session: Int, request: String, callback: @escaping (String) -> ())
    {
        let escapedRequest = request.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //let queryUrl = baseUrl+"query="+escapedRequest!
        //let completeUrl = queryUrl+"&lang="+lang+"&sessionId="+String(session)
        let url = URL(string: baseUrl)
        print(request);
        var urlRequest = URLRequest(url: url!) //make a request out of the URL
        urlRequest.httpMethod = "POST"
        let requestDict = ["user_id": String(session), "input": request]
        do {
        let jsonData = try JSONSerialization.data(withJSONObject: requestDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        urlRequest.httpBody = jsonData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //urlRequest.setValue("Bearer "+clientKey, forHTTPHeaderField: "Authorization")//set HTTP auth header
        let session = URLSession.shared
        //perform data request
        let task = session.dataTask(with: urlRequest) { data, response, error in
            //Json Datei, erzeugt von Chatbot, wird hier ausgelesen
            if let returnedData = data
            {
                print("Data has been returned.")
                let json = JSON(data: returnedData)
                var r = (returnedData.base64EncodedString())
                print("result here !")
                r = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                print(r)
                if let result = json["responds"][0].string {
                    //Now you got your value
                    print("The response from Watson was retrieved and is: ")
                    print(result)
                    callback(result) //The result will be accessible via the variable resultResponse
                }
                if let errorMessage = json["message"].string
                {
                    print("Some server error occured.")
                    callback("Sorry, we are experiencing some server errors at the moment.")
                }
            }
            
            
        }
        task.resume()
        } catch let error as NSError{
            NSLog(error.localizedDescription)
        }
    }
        
        
    

}
