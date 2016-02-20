//
//  CoreDataTableViewController.swift
//  LightControl
//
//  Created by Stanislav Sidelnikov on 09/02/16.
//  Copyright © 2016 Stanislav Sidelnikov. All rights reserved.
//  https://github.com/5amfung/CoreDataTableViewController/blob/master/CoreDataTableViewController.swift
//

import Foundation
import UIKit
import CoreData


class CoreDataTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Instance variables
    var preventUIUpdates = false

    var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            self.setUpFetchedResultsController()
        }
    }

    // MARK: - Fetching

    func performFetch() {
        do {
            try self.fetchedResultsController!.performFetch()
        } catch let err as NSError {
            NSLog("%@", err.localizedDescription)
            return
        }
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController!.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if self.fetchedResultsController!.sections!.count > 0 {
            let sectionInfo = self.fetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
            rows = sectionInfo.numberOfObjects
        }
        return rows
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.name
    }

    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.fetchedResultsController!.sectionForSectionIndexTitle(title, atIndex: index)
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.fetchedResultsController!.sectionIndexTitles
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        if !preventUIUpdates {
            self.tableView.beginUpdates()
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if !preventUIUpdates {
            self.tableView.endUpdates()
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        if !preventUIUpdates {
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
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if !preventUIUpdates {
            switch type {
            case NSFetchedResultsChangeType.Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Update:
                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }

    // MARK: - Private

    private func setUpFetchedResultsController() {
        self.fetchedResultsController!.delegate = self
        if self.title == nil && (self.navigationController == nil || self.navigationItem.title == nil) {
            self.title = self.fetchedResultsController!.fetchRequest.entity?.name
        }
        self.performFetch()
    }
}