//
//  ARSharingState.swift
//  ChemistryAR
//
//  Created by Admin on 11/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import ARKit

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        }
    }
}
