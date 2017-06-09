/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/***********************************************************

 Create Issue in Jira.  Issue is encoded as a JSON object
 in the form:

 {
 "fields": {
 "project":
 {
 "key": "TEST"
 },
 "summary": "REST ye merry gentlemen.",
 "description": "Creating of an issue using project keys and issue type names using the REST API",
 "issuetype": {
 "name": "Bug"
 }
 }
 }

 For project, key is the key value assigned to a Jira project, e.g. "MyAwesomeScrumProject"
 may have the key "MYAW"

 @param issue the jsonObject representing the issue
 @return response from Jira representing succes or failure

 ***********************************************************/
import Foundation
import Dispatch
import KituraNet
import KituraSys

func main(args: [String:Any]) -> [String:Any] {

    guard let username = args["jiraUsername"] as? String else {
        return ["error":"Jira username not set"]
    }

    guard let password = args["jiraPassword"] as? String else {
        return ["error": "Jira password not set"]
    }

    guard let host = args["jiraHost"] as? String else {
        return ["error": "Jira host not set"]

    }

    let loginString = ("\(username):\(password)")

    let loginData: NSData = loginString.data(using: NSUTF8StringEncoding)!
    let base64LoginString = loginData.base64EncodedString(NSDataBase64EncodingOptions(rawValue: 0))

    let headers = ["Content-Type" : "application/json",
                   "Authorization" : "Basic \(base64LoginString)"]

    let requestOptions = [ClientRequestOptions.schema("https://"),
                          ClientRequestOptions.method("post"),
                          ClientRequestOptions.hostname(host),
                          ClientRequestOptions.path("/rest/api/2/issue/"),
                          ClientRequestOptions.headers(headers),
                          ClientRequestOptions.disableSSLVerification]

    let request = HTTP.request(requestOptions) { response in
        if response != nil {
            do {
                // this is odd, but that's just how KituraNet has you get
                // the response as NSData
                let jsonData = NSMutableData()
                try response!.readAllData(into: jsonData)

                let resp = try NSJSONSerialization.jsonObject(with: jsonData, options: [])
                let r = resp as! [String:Any]

                print("Got response \(r)")


            } catch {
                print("error Could not parse a valid JSON response.")
            }
        } else {
            print("error Did not receive a response.")
        }
    }

    do {
        #if os(OSX)
            let jsonData = try NSJSONSerialization.data(withJSONObject: args as! [String:AnyObject], options: [])
        #elseif os(Linux)
            let jsonData = try NSJSONSerialization.data(withJSONObject: args.bridge(), options: [])
        #endif



        request.write(from: jsonData)
        request.end()

    } catch {
        print("JSON Error \(error)")
    }

    return args
}
