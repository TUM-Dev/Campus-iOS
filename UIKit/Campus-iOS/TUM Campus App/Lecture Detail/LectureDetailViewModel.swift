//
//  LectureDetailViewModel.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 6.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation

struct LectureDetailViewModel: Hashable {
    let sections: [Section]

    struct Section: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let cells: [AnyHashable]
    }

    struct Header: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let subtitle: String
    }

    struct Cell: Identifiable, Hashable {
        let id = UUID()
        let key: String
        let value: String
    }

    struct LinkCell: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let link: URL
    }

    init(lecture: Lecture) {
        let header = Header(title: lecture.title ?? "", subtitle: lecture.eventType ?? "")

        var general: [AnyHashable] = []
        if let duration = lecture.duration?.description {
            general.append(Cell(key: "Duration".localized, value: duration))
        }

        if let semester = lecture.semester {
            general.append(Cell(key: "Semester".localized, value: semester))
        }

        if let chair = lecture.organisation {
            general.append(Cell(key: "Chair".localized, value: chair))
        }

        if let speaker = lecture.speaker {
            general.append(Cell(key: "Speaker".localized, value: speaker))
        }

        self.sections = [
            Section(name: "Header", cells: [header]),
            Section(name: "General", cells: general)
            ].filter { !$0.cells.isEmpty }
    }

    init(lectureDetail: LectureDetail) {
        let header = Header(title: lectureDetail.title, subtitle: lectureDetail.eventType)

        var general = [
            // TODO: format duration
            Cell(key: "Duration".localized, value: lectureDetail.duration.description),
            Cell(key: "Semester".localized, value: lectureDetail.semester),
            Cell(key: "Chair".localized, value: lectureDetail.organisation),
            Cell(key: "Speaker".localized, value: lectureDetail.speaker),
        ]

        if let firstScheduledDate = lectureDetail.firstScheduledDate, !firstScheduledDate.isEmpty {
            general.append(Cell(key: "First Meeting".localized, value: firstScheduledDate))
        }

        var course: [Cell] = []
        if let courseContents = lectureDetail.courseContents, !courseContents.isEmpty {
            course.append(Cell(key: "Course Contents", value: courseContents))
        }

        if let courseObjective = lectureDetail.courseObjective, !courseObjective.isEmpty {
            course.append(Cell(key: "Course Objective", value: courseObjective))
        }

        if let note = lectureDetail.note, !note.isEmpty {
            course.append(Cell(key: "Note".localized, value: note))
        }

        var urls: [LinkCell] = []
        if let curriculumURL = lectureDetail.curriculumURL {
            urls.append(LinkCell(name: "Curiculum".localized, link: curriculumURL))
        }

        if let scheduledDatesURL = lectureDetail.scheduledDatesURL {
            urls.append(LinkCell(name: "Dates".localized, link: scheduledDatesURL))
        }

        if let examDateURL = lectureDetail.examDateURL {
            urls.append(LinkCell(name: "Exam".localized, link: examDateURL))
        }

        self.sections = [
            Section(name: "Header", cells: [header]),
            Section(name: "General", cells: general.filter { !$0.value.isEmpty }),
            Section(name: "Course", cells: course.filter { !$0.value.isEmpty }),
            Section(name: "URLs", cells: urls)
            ].filter { !$0.cells.isEmpty }
    }
}
