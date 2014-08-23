import Foundation
import UIKit
import CoreData


class CoreDataTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Instance variables

    var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            self.setUpFetchedResultsController()
        }
    }

    // MARK: - Fetching

    func performFetch() {
        var error: NSError?
        self.fetchedResultsController!.performFetch(&error)
        if let err = error {
            NSLog("%@", err.localizedDescription)
        }
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return self.fetchedResultsController!.sections.count
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if self.fetchedResultsController!.sections.count > 0 {
            var sectionInfo = self.fetchedResultsController!.sections[section] as NSFetchedResultsSectionInfo
            rows = sectionInfo.numberOfObjects
        }
        return rows
    }

    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        let sectionInfo = self.fetchedResultsController!.sections[section] as NSFetchedResultsSectionInfo
        return sectionInfo.name
    }

    override func tableView(tableView: UITableView!, sectionForSectionIndexTitle title: String!, atIndex index: Int) -> Int {
        return self.fetchedResultsController!.sectionForSectionIndexTitle(title, atIndex: index)
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView!) -> [AnyObject]! {
        return self.fetchedResultsController!.sectionIndexTitles
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.endUpdates()
    }

    func controller(controller: NSFetchedResultsController!, didChangeSection sectionInfo: NSFetchedResultsSectionInfo!, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let indexSet = NSIndexSet(index: sectionIndex)
        switch type {
            case NSFetchedResultsChangeType.Insert:
                self.tableView.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Delete:
                self.tableView.deleteSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Update:
                break
            case NSFetchedResultsChangeType.Move:
                break
        }
    }

    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        switch type {
            case NSFetchedResultsChangeType.Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Update:
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    // MARK: - Private

    private func setUpFetchedResultsController() {
        self.fetchedResultsController!.delegate = self
        if self.title == nil && (self.navigationController == nil || self.navigationItem.title == nil) {
            self.title = self.fetchedResultsController!.fetchRequest.entity.name
        }
        self.performFetch()
    }
}
