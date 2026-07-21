//
//  Navigation.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftUI
import SwiftData

/// Used to share the navigation state.
@Observable final class Navigation {
    var erasPath = NavigationPath()
    var eventsPath = NavigationPath()
    var subjectsPath = NavigationPath()
    var poemsPath = NavigationPath()
    var selectedEra: Era?
    var selectedEvent: Event?
    var selectedSubject: Subject?
    var pageSelection: Int = 1

    var selectedTab: TabValue = .poems {
        willSet(tappedTab) {
            switch tappedTab {
            case .book:
                pageSelection = 1
            case .eras:
                if tappedTab == selectedTab {
                    self.selectedEra = nil
                }
                self.selectedEvent = nil
                self.selectedSubject = nil
            case .events:
                if tappedTab == selectedTab {
                    self.selectedEvent = nil
                }
                self.selectedEra = nil
                self.selectedSubject = nil
            case .subjects:
                if tappedTab == selectedTab {
                    self.selectedSubject = nil
                }
                self.selectedEra = nil
                self.selectedEvent = nil
            case .poems:
                ()
            }
            if !self.erasPath.isEmpty {
                self.erasPath = .init()
            }
            if !self.eventsPath.isEmpty {
                self.eventsPath = .init()
            }
            if !self.subjectsPath.isEmpty {
                self.subjectsPath = .init()
            }
            if !self.poemsPath.isEmpty {
                self.poemsPath = .init()
            }
        }
    }
    
    func resetNavigationPath(for item: any PersistentModel) {
        switch item {
        case is Era:
            erasPath = .init()
            if selectedEra == item as? Era {
                selectedEra = nil
            }
        case is Event:
            eventsPath = .init()
            if selectedEvent == item as? Event {
                selectedEvent = nil
            }
        case is Subject:
            subjectsPath = .init()
            if selectedSubject == item as? Subject {
                selectedSubject = nil
            }
        default:
            ()
        }
    }
}
