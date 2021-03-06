//
//  Constants.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/20/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//

import Foundation

public final class Constants {
    private init() {}
    
    //public static let BaseUrl: String = "https://analytics.startupsoft.org/" // prod
    public static let BaseUrl: String = "https://qa-startupsoft-analytics.azurewebsites.net/" //dev
    
    //public static let ImageStorageUrl: String = "https://prodssanalytics.blob.core.windows.net" // prod
    public static let ImageStorageUrl: String = "https://qassanalytics.blob.core.windows.net" // dev
}
