//
//  DownloadPlan.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 18.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire

class PlanDownloader {
    
    init() {}
    
    // download the pdf plan, if the file does not exist
    func downloadPlan(urlString url: String, withName name: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentsURL!.appendingPathComponent("plans/"+name)
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let fileManager = FileManager.default
        if !(fileManager.fileExists(atPath: fileURL.path)) {
            Alamofire.download(url, to: destination).response { response in
                print(response)
            }
        }
    }
}
