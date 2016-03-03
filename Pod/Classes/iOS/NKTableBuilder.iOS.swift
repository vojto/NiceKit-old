//
//  NKTableBuilder.iOS.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 05/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit




class NKTableBuilder: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    var padding: NKPadding? {
        get {
            return nil
        }
        set {
            tableView.contentInset = newValue!.edgeInsets
        }
    }

    var controller: UITableViewController?
    let tableView: UITableView
    let mainView: NKView

    var selectedRow: Int?

    var enableReordering = false


    var items = [NKTableItem]() {
        didSet {
            reload()
        }
    }

//    var viewIdentifierForRow: ((row: Int) -> String)?
//    var createCellView: ((row: Int) -> NKTableCellView?)?
//    var updateCellView: ((view: NKTablespoCellView, row: Int) -> Void)?

    var calcRowHeight: ((row: Int) -> CGFloat)?
    var rowHeight: CGFloat?

    // Classic API
    var numberOfSections: (() -> Int)?
    var numberOfRows: ((section: Int) -> Int)?
    var itemForRow: ((section: Int, row: Int) -> NKTableItem)?
    var viewForHeader: ((section: Int) -> NKView)?
    var headerHeight: CGFloat?

    var onSelectRow: ((row: Int) -> ())?
    var onSelect: ((item: NKTableItem) -> ())?
    var onDeselectRow: (() -> ())?

    var onDelete: ((row: Int) -> ())?

    var onStartScrolling: NKSimpleCallback?
    var onScroll: ((offset: CGPoint) -> ())?

    // Reordering callbacks
    var canMoveItem: ((at: Int) -> Bool)?
    var moveItem: ((atIndex: Int, toIndex: Int) -> ())?
    var targetRowForMove: ((from: Int, to: Int) -> Int)?
    var canDropItem: ((from: Int, to: Int) -> Bool)? // Not used here

    var showsVerticalScrollIndicator: Bool {
        get { return tableView.showsVerticalScrollIndicator }
        set { tableView.showsVerticalScrollIndicator = newValue }
    }


    let selectedBackgroundView = NKTableSelectedBackgroundView()
    var drawSelection: ((rect: CGRect) -> ())? {
        didSet {
            selectedBackgroundView.drawingBlock = drawSelection
        }
    }

    var columnWidth: CGFloat {
        return tableView.frame.size.width
    }

    override init() {
        tableView = NKTableView()

        tableView.separatorStyle = .None
        tableView.separatorInset = UIEdgeInsetsZero

        mainView = NKView()
        mainView.addSubview(tableView)
        tableView.expand()

        super.init()

        tableView.dataSource = self
        tableView.delegate = self

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "handleKeyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "handleKeyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        NSNotificationCenter.on("NKTextArea.focus") { obj in
            let field = obj as! NKTextArea

            var view: UIView? = field.superview

            while view != nil {
                if let cell = view as? UITableViewCell {
                    if let index = self.tableView.indexPathForCell(cell) {
                        self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: .Middle, animated: true)
                    }
                    break
                }

                view = view?.superview
            }
        }

    }

    func selectRow(index: Int) {
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .None)
    }

    func deselect() {
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selection, animated: false)
            handleRowSelection()
        }

    }

    func viewAt(index: Int) -> UITableViewCell? {
        return tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
    }

    func recalculateHeightForView(view: NKTableCellView) {
        recalculateHeights()
    }

    func recalculateHeights() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    func reload() {
        hiddenIndexes.removeAllIndexes()

        tableView.reloadData()

        handleRowSelection()
    }

    // MARK: UITableView delegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let fun = numberOfSections {
            return fun()
        } else {
            return 1
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fun = numberOfRows {
            return fun(section: section)
        } else {
            return items.count
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeader?(section: section)
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row

        let item = itemAt(indexPath)

        let identifier = String(item.viewClass)

        var view = tableView.dequeueReusableCellWithIdentifier(identifier) as! NKTableCellView?

        if view == nil {
            view = item.viewClass!.init(reuseIdentifier: identifier)
            view!.builder = self
        }

        if let _ = drawSelection {
            view?.selectedBackgroundView = selectedBackgroundView
        }

        item.update?(view!)

        view!.update(item)

        item.row = row
        item.view = view

        view?.selectionStyle = .None
        view?.showsReorderControl = true

        return view!
    }

    func itemAt(indexPath: NSIndexPath) -> NKTableItem {
        let section = indexPath.section
        let row = indexPath.row

        if let fun = itemForRow {
            return fun(section: section, row: row)
        } else {
            return items[row]
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row

        if hiddenIndexes.contains(row) {
            return 0
        }

        if let height = rowHeight {
            return height
        }

        let item = itemAt(indexPath)

        if let height = item.height {
            return height
        }

        if let height = calcRowHeight?(row: row) {
            return height
        }

        return 40
    }

    // MARK: Handling selection

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let item = itemAt(indexPath)

        if item.selectable {
            return indexPath
        } else {
            return nil
        }
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        handleRowSelection()
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        handleRowSelection()
    }

    func handleRowSelection() {
        let selected = tableView.indexPathForSelectedRow
        let row = selected?.row

        if row != selectedRow {
            selectedRow = row

            if let row = row {
                onSelectRow?(row: row)
                onSelect?(item: itemAt(selected!))
            } else {
                onDeselectRow?()
            }
        }


    }

    // MARK: Hiding rows

    let hiddenIndexes = NSMutableIndexSet()

    func hideRowAt(index: Int) {
        hiddenIndexes.addIndex(index)
        recalculateHeights()
    }

    func unhideRowAt(index: Int) {
        hiddenIndexes.removeIndex(index)
        recalculateHeights()
    }

    // MARK: Recognizing tap gestures

    var tapGestureRecognizer: UITapGestureRecognizer?
    var onTap: SimpleCallback? {
        didSet {
            if tapGestureRecognizer == nil {
                tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                tapGestureRecognizer!.cancelsTouchesInView = false
                tableView.addGestureRecognizer(tapGestureRecognizer!)
            }
        }
    }

    var onTapOut: SimpleCallback?

    func handleTap(sender: UITapGestureRecognizer) {
        onTap?()

        let location = sender.locationInView(tableView)

        let view = tableView.hitTest(location, withEvent: nil)

        if view === tableView {
            onTapOut?()
        }


    }


    // MARK: Scrolling

    func scrollTo(view: NKTableCellView) {
        if let indexPath = tableView.indexPathForCell(view) {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }

    func scrollToPoint(point: CGPoint) {
        tableView.setContentOffset(point, animated: false)
    }

    func scrollToBottom() {
        scrollToPoint(CGPointMake(0, CGFloat.max))
    }

    // MARK: Row actions

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let item = itemAt(indexPath)
        return item.deletable
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if tableView.editing {
            return .Delete
        } else {
            return .None
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            onDelete?(row: indexPath.row)
        }
    }

    /*
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let item = items[indexPath.row]
        if let actions = item.actions {
            let xactions = actions.map { action in
                return XTableViewRowAction(style: .Default, title: action.title) { _, _ in
                    action.handler(row: indexPath.row)
                }
            }

            Swift.print("Returning \(xactions.count) actions for item at \(indexPath.row)")

            return xactions
        }

        return nil
    }
    */

    // MARK: - Keyboard support

    func handleKeyboardWillShow(notif: NSNotification) {
        if tableView.window == nil {
            return
        }

        print("Showing keyboard")

        guard let info = notif.userInfo else { return }
        guard let rect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else { return }
        let height = rect.height
        guard let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return }
        guard let curveValue = info[UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntegerValue else { return }
        let options = UIViewAnimationOptions(rawValue: UInt(curveValue << 16))

        UIView.animateWithDuration(duration, delay: 0, options: options, animations: { () -> Void in
            let insets = UIEdgeInsetsMake(0, 0, height, 0)
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        }, completion: nil)
    }

    func handleKeyboardWillHide(notif: NSNotification) {
        if tableView.window == nil {
            let insets = UIEdgeInsetsZero
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
            return
        }

        guard let info = notif.userInfo else { return }
        guard let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return }
        guard let curveValue = info[UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntegerValue else { return }
        let options = UIViewAnimationOptions(rawValue: UInt(curveValue << 16))

        UIView.animateWithDuration(duration, delay: 0, options: [options, UIViewAnimationOptions.BeginFromCurrentState], animations: { () -> Void in
            let insets = UIEdgeInsetsZero
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        }, completion: nil)
    }


    // MARK: - Responding to scrolling

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        onStartScrolling?()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset

        onScroll?(offset: offset)
    }

    // MARK: - Reordering

    func toggleReordering() {
        if tableView.editing {
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let cb = canMoveItem {
            return cb(at: indexPath.row)
        } else {
            return false
        }
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        moveItem?(atIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }

    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        let from = sourceIndexPath.row
        let to = proposedDestinationIndexPath.row

        if let cb = targetRowForMove {
            let row = cb(from: from, to: to)
            return NSIndexPath(forRow: row, inSection: 0)
        } else {
            return proposedDestinationIndexPath
        }
    }
}


class NKTableSelectedBackgroundView: XView {
    var drawingBlock: ((rect: CGRect) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        opaque = false
        backgroundColor = XColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
//        XColor.clearColor().set()
//        let ctx = XGraphicsGetCurrentContext()
//
//        CGContextFillRect(ctx, rect)

        drawingBlock?(rect: rect)
    }

}


