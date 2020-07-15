//
//  CourseDates.swift
//  edX
//
//  Created by Muhammad Umer on 01/07/2020.
//  Copyright © 2020 edX. All rights reserved.
//

import Foundation

enum CourseStatusType {
    case completed
    case pastDue
    case dueNext
    case unreleased
    case verifiedOnly
    case event
    
    case assignment
    case verifiedUpgradeDeadline
    case courseExpiredDate
    case verificationDeadlineDate
    case certificateAvailbleDate
    case courseStartDate
    case courseEndDate
    
    var localized: String {
        switch self {
        case .completed:
            return Strings.Coursedates.completed
            
        case .pastDue:
            return Strings.Coursedates.pastDue
            
        case .dueNext:
            return Strings.Coursedates.dueNext
            
        case .unreleased:
            return Strings.Coursedates.unreleased
            
        case .verifiedOnly:
            return Strings.Coursedates.verfiedOnly
            
        case .event:
            return Strings.Coursedates.event
            
        case .assignment:
            return "Assignment Due Date"
            
        case .verifiedUpgradeDeadline:
            return "Verified Upgrade Deadline"
            
        case .courseExpiredDate:
            return "Course Expired Date"
            
        case .verificationDeadlineDate:
            return "Verification Deadline Date"
            
        case .certificateAvailbleDate:
            return "Certificate Available Date"
            
        case .courseStartDate:
            return "Course Start Date"
            
        case .courseEndDate:
            return "Course End Date"
        }
    }
    
    static func typeOf(dateType: String) -> CourseStatusType {
        switch dateType {
        case "assignment-due-date":
            return .assignment
            
        case "verified-upgrade-deadline":
            return .verifiedUpgradeDeadline
            
        case "course-expired-date":
            return .courseExpiredDate
            
        case "verification-deadline-date":
            return .verificationDeadlineDate
            
        case "certificate-available-date":
            return .certificateAvailbleDate
            
        case "course-start-date":
            return .courseStartDate
            
        case "course-end-date":
            return .courseEndDate
            
        case "event":
            return .event
            
        default:
            return .event
        }
    }
    
    static func isAssignment(type: String) -> Bool {
        return type == "assignment-due-date"
    }
}

public class CourseDateModel: NSObject {
    var courseDateBlocks: [CourseDateBlock] = []
    let datesBannerInfo: DatesBannerInfo?
    let learnerIsFullAccess: Bool
    let missedDeadlines: Bool
    let missedGatedContent: Bool
    let userTimezone : String
    let verifiedUpgradeLink: String
    
    public init?(json: JSON) {
        let courseDateBlocksArray = json["course_date_blocks"].array ?? []
        for courseDateBlocksJsonObject in courseDateBlocksArray {
            if let courseDateblock = CourseDateBlock(json: courseDateBlocksJsonObject) {
                courseDateBlocks.append(courseDateblock)
            }
        }
        let datesBannerInfoJson = json["dates_banner_info"]
        datesBannerInfo = DatesBannerInfo(json: datesBannerInfoJson) ?? nil
        learnerIsFullAccess = json["learner_is_full_access"].bool ?? false
        missedDeadlines = json["missed_deadlines"].bool ?? false
        missedGatedContent = json["missed_gated_content"].bool ?? false
        userTimezone = json["user_timezone"].string ?? ""
        verifiedUpgradeLink = json["verified_upgrade_link"].string ?? ""
    }
}

class DatesBannerInfo: NSObject {
    let contentTypeGatingEnabled: Bool
    let missedDeadlines: Bool
    let missedGatedContent: Bool
    let verifiedUpgradeLink: String
    
    public init?(json: JSON) {
        contentTypeGatingEnabled = json["content_type_gating_enabled"].bool ?? false
        missedDeadlines = json["missed_deadlines"].bool ?? false
        missedGatedContent = json["missed_gated_content"].bool ?? false
        verifiedUpgradeLink = json["verified_upgrade_link"].string ?? ""
    }
}

class CourseDateBlock: NSObject{
    let complete: Bool
    var blockDate: Date = Date()
    let dateType: String
    let descriptionField: String
    let learnerHasAccess: Bool
    let link: String
    let linkText: String
    let title: String
    let dateText: String
    let isAssignment: Bool
    
    var blockStatus: CourseStatusType {
        get {
            return calculateStatus(date: blockDate, type: dateType)
        }
    }
    
    public init?(json: JSON) {
        complete = json["complete"].bool ?? false
        let date = json["date"].string ?? ""
        dateType = json["date_type"].string ?? ""
        descriptionField = json["description"].string ?? ""
        learnerHasAccess = json["learner_has_access"].bool ?? false
        link = json["link"].string ?? ""
        linkText = json["link_text"].string ?? ""
        title = json["title"].string ?? ""
        isAssignment = CourseStatusType.isAssignment(type: dateType)
        
        guard let formattedDate = DateFormatting.date(withServerString: date) else {
            dateText = ""
            return
        }
        blockDate = formattedDate as Date
        dateText = formattedDate.formattedDate(with: .medium)
    }
    
    private var isInPast: Bool {
        return DateFormatting.compareTwoDates(fromDate: blockDate, toDate: Date()) == .orderedAscending
    }
    
    private var isToday: Bool {
        return DateFormatting.compareTwoDates(fromDate: blockDate, toDate: Date()) == .orderedSame
    }
    
    private var isInFuture: Bool {
        return DateFormatting.compareTwoDates(fromDate: blockDate, toDate: Date()) == .orderedDescending
    }
    
    /*
     For completeness sake, here are the badge triggers:
     completed: should be if the item has the currently-never-present-by-accident completed boolean to true (and is an assignment)
     past due: is an assignment, the learner has access, is not complete, and due in the past
     due next: is an assignment, the learner has access, is not complete, and is the next assignment due
     unreleased: is an assignment, the learner has access, and there's no link property (and/or it's empty, I forget which)
     verified only: the learner does not have access (note that it can be an assignment or something else)
     verification-deadline-date:
     certificate-available-date:
     course-start-date:
     course-end-date:
     */
    private func calculateStatus(date: Date, type: String) -> CourseStatusType {
        if complete {
            return .completed
        } else {
            if learnerHasAccess {
                if isAssignment {
                    if !complete {
                        if isInPast {
                            return .pastDue
                        } else if isInFuture {
                            return .dueNext
                        }
                    } else if link.isEmpty {
                        return .unreleased
                    }
                } else {
                    return CourseStatusType.typeOf(dateType: type)
                }
            } else {
                return .verifiedOnly
            }
        }
        return .event
    }
}
