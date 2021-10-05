import UIKit
import CalendarKit
import Alamofire
import CoreData
import XMLCoder

final class CalendarWeekViewController: DayViewController, ProfileImageSettable {
    typealias ImporterType = Importer<CalendarEvent,APIResponse<CalendarAPIResponse,TUMOnlineAPIError>,XMLDecoder>

    @IBOutlet private weak var profileImageBarButtonItem: UIBarButtonItem!
    var profileImage: UIImage? {
        get { return profileImageBarButtonItem.image }
        set { profileImageBarButtonItem.image = newValue?.imageAspectScaled(toFill: CGSize(width: 32, height: 32)).imageRoundedIntoCircle().withRenderingMode(.alwaysOriginal) }
    }

    private static let endpoint: URLRequestConvertible = TUMOnlineAPI.calendar
    private static let primarySortDescriptor = NSSortDescriptor(keyPath: \CalendarEvent.startDate, ascending: true)
    private static let secondarySortDescriptor = NSSortDescriptor(keyPath: \CalendarEvent.id, ascending: true)
    private static let predicate = NSPredicate(format: "%K != %@", #keyPath(CalendarEvent.status), "CANCEL")
    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: primarySortDescriptor, secondarySortDescriptor, predicate: predicate, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))


    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileImage()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetch(animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let date = Date()
        let currentTime = Calendar.current.component(.hour, from: date)
        dayView.scrollTo(hour24: Float(currentTime))
    }

    private func setupUI() {
        title = "Calendar".localized
        edgesForExtendedLayout = UIRectEdge.all

        dayView.backgroundColor = .systemBackground
        dayView.autoScrollToFirstEvent = false

        navigationController?.navigationBar.prefersLargeTitles = true

        var style = CalendarStyle()
        style.header.backgroundColor = .systemBackground
        style.header.daySelector.todayActiveBackgroundColor = .tumBlue
        style.header.daySelector.todayInactiveTextColor = .tumBlue
        style.timeline.backgroundColor = .systemBackground
        style.timeline.timeIndicator.color = .tumBlue
        dayView.updateStyle(style)
    }

    @objc private func fetch(animated: Bool = true) {
        importer.performFetch(success: { [weak self] in
            self?.reload()
        }, error: { [weak self] error in
            switch error {
            case is TUMOnlineAPIError:
                guard let context = self?.importer.context else { break }
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: CalendarEvent.fetchRequest())
                _ = try? context.execute(deleteRequest) as? NSBatchDeleteResult
                self?.reload()
            default: break
            }
        })
    }

    private func reload() {
        try? importer.fetchedResultsController.performFetch()
        dayView.reloadData()
    }

    // MARK: - EventDataSource

    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let events = importer.fetchedResultsController.fetchedObjects ?? []
        return events.compactMap { CalendarEventViewModel(event: $0) }
    }

    // MARK: - Actions

    @IBAction func showToday(_ sender: Any) {
        let date = Date()
        let currentTime = Calendar.current.component(.hour, from: date)
        
        dayView.state?.move(to: Date())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dayView.scrollTo(hour24: Float(currentTime))
        }
    }
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        let attrTxt = eventView.descriptor?.attributedText
        let s = attrTxt?.string
                        
        if let range = s!.range(of: "LvNr=") {
            let lvNr = String(s![range.upperBound...])
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let detailVC = storyboard.instantiateViewController(withIdentifier: "LectureDetailCollectionViewController") as? LectureDetailCollectionViewController else { return }
            navigationController?.pushViewController(detailVC, animated: true)
            detailVC.setLecture(withLVNr: lvNr)
        }
    }
}
