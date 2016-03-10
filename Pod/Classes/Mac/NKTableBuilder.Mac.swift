//
//  NKTableBuilder.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 05/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit


public class NKTableBuilder: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    // MARK: - Properties
    // ------------------------------------------------------------------------

    // Core props
    public let scrollView: NSScrollView
    public let tableView: NKTableView
    public let mainView: NKView
    public var items = [NKTableItem]() {
        didSet {
            reload()
        }
    }
    let hiddenIndexes = NSMutableIndexSet()

    // UI
    public var showsVerticalScrollIndicator: Bool = false // Doesn't do anything
    public var padding: NKPadding? {
        didSet { setPadding(padding!) } // TODO: This should be done through styles
    }
    public var enableReordering: Bool = false {
        didSet { applyEnableReordering(enableReordering) }
    }
    public var menu: NSMenu? {
        get { return self.tableView.menu }
        set { self.tableView.menu = newValue }
    }
    public var columnWidth: CGFloat { return tableView.tableColumns[0].width }

    // Classic API
    public var numberOfSections: (() -> Int)?
    public var numberOfRows: ((section: Int) -> Int)?
    public var itemForRow: ((section: Int, row: Int) -> NKTableItem)?

    // Section headers
    public var viewForHeader: ((section: Int) -> NKView)?
    public var headerHeight: CGFloat?

    // Height
    public var calcRowHeight: ((row: Int) -> CGFloat)?
    public var rowHeight: CGFloat?

    // Selecting
    public var onSelectRow: ((index: Int) -> ())?
    public var onDeselectRow: (() -> ())?
    public var selectedView: NKTableCellView?
    dynamic var _selectionIndexes: NSIndexSet?

    // Events
    public var onTap: (() -> ())?                      // iOS only - doesn't do anything here
    public var onTapOut: (() -> ())?                   // iOS only - doesn't do anything here
    public var onDelete: ((row: Int) -> ())?           // TODO: Implement
    public var onScroll: ((offset: CGPoint) -> ())?    // Not sure about this one
    public var onStartScrolling: NKSimpleCallback?
    public var onDoubleClick: (() -> ())? {
        get { return tableView.onDoubleClick }
        set { tableView.onDoubleClick = newValue }
    }
    
    // Reordering callbacks
    public var canMoveItem: ((at: Int) -> Bool)?
    public var targetRowForMove: ((from: Int, to: Int) -> Int)?    // Not used here, TODO: make it somehow work with iOS
    public var canDropItem: ((from: Int, to: Int) -> Bool)?
    public var moveItem: ((atIndex: Int, toIndex: Int) -> ())?



    // MARK: - Lifecycle
    // ------------------------------------------------------------------------

    public override init() {
        scrollView = NSScrollView.init()
        tableView = NKTableView.init()
        mainView = NKView()
        mainView.addSubview(scrollView)
        scrollView.expand()
        
        super.init()

        let column = NSTableColumn(identifier: "column")
        column.resizingMask = .AutoresizingMask
        tableView.addTableColumn(column)

        tableView.selectionHighlightStyle = .None
        tableView.intercellSpacing = CGSizeMake(0, 0)
        
        tableView.setDelegate(self)
        tableView.setDataSource(self)
        
        tableView.headerView = nil
        scrollView.documentView = tableView

        tableView.bind("selectionIndexes", toObject: self, withKeyPath: "_selectionIndexes", options: nil)
        self.addObserver(self, forKeyPath: "_selectionIndexes", options: .New, context: nil)
    }

    public func reload() {
//        print("Reloading! 😈")

        hiddenIndexes.removeAllIndexes()

        let indexes = tableView.selectedRowIndexes

        tableView.reloadData()

        NSTimer.schedule(delay: 0) { _ in
            // - Come on Vojto, this code is shit and you know it!
            // - But it works.
            self.reselectIndexes(indexes)
        }

    }

    // MARK: Public API
    // ------------------------------------------------------------------------

    public func viewAt(index: Int) -> NSView? {
        return tableView.viewAtColumn(0, row: index, makeIfNecessary: false)
    }

    public func indexForView(view: NKTableCellView) -> Int? {
        return items.indexOf { $0.view == view }
    }
    

    // MARK: - UI Helpers
    // ------------------------------------------------------------------------

    func setPadding(padding: NKPadding) {
        if let padding = self.padding {
            self.scrollView.automaticallyAdjustsContentInsets = false
            self.scrollView.contentInsets = padding.edgeInsets
        } else {
            self.scrollView.automaticallyAdjustsContentInsets = true
        }
    }

    func applyEnableReordering(enable: Bool) {
        if enable {
            tableView.registerForDraggedTypes(["public.data"])
        } else {
            tableView.unregisterDraggedTypes()
        }
    }

    // MARK: - Main data source methods
    // ------------------------------------------------------------------------

    
    public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if isCustomMode {
            return self.numberOfRowsInCustomMode()
        } else {
            return items.count
        }
    }
    
    public func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

        // Return the header view if that's the case
        if isCustomMode {
            let (section, row) = self.indexPathAtOuterRow(row)
            if row == 0 {
                return self.viewForHeader!(section: section)
            }

        }

        let item = self.itemAt(row)

        let identifier = String(item.viewClass)
        var view = tableView.makeViewWithIdentifier(identifier, owner: self) as! NKTableCellView?

        if view == nil {
//            Log.t("Initializing viewg mit identifier: \(identifier)")
            view = item.viewClass!.init(reuseIdentifier: identifier)
            view!.builder = self
        } else {
//            Log.t("Reused view mit identifier: \(identifier) = \(view)")
        }

        item.view = view

        view!.update(item)
        
        return view
    }
    
    public func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let height = heightForRowAt(row)

        if height == 0 {
            return 1
        } else {
            return height
        }
    }

    func heightForRowAt(row: Int) -> CGFloat {
        if hiddenIndexes.containsIndex(row) {
            return 1
        }

        if let height = self.rowHeight {
            return height
        }

        let item = itemAt(row)

        if let height = item.height {
            return height
        }

        if self.calcRowHeight != nil {
            return self.calcRowHeight!(row: row)
        } else {
            return 22.0
        }
    }



    // MARK: Accessing items
    // ------------------------------------------------------------------------

    func itemAt(row: Int) -> NKTableItem {
        if isCustomMode {
            return self.itemForCustomModeAt(row)
        } else {
            return items[row]
        }
    }




    // MARK: Custom mode functionality
    // ------------------------------------------------------------------------

    var isCustomMode: Bool {
        return numberOfRows != nil
    }

    // MARK: Sections cache

    var cachedSections: [Int]?

    func buildSectionsCache() {
        cachedSections = [Int]()

        for var i = 0; i < self.numberOfSections!(); i++ {
            let count = self.numberOfRows!(section: i) + 1
            cachedSections?.append(count)
        }
    }

    // MARK: Getting numbers

    func numberOfRowsInCustomMode() -> Int {
        if cachedSections == nil {
            buildSectionsCache()
        }

        return cachedSections!.reduce(0) { $0 + $1 }
    }

    func itemForCustomModeAt(outerRow: Int) -> NKTableItem {
        // Find section

        let (section, row) = indexPathAtOuterRow(outerRow)

        if section == 0 {
            return NKTableItem()
        } else {
            return self.itemForRow!(section: section, row: row - 1)
        }
    }

    func indexPathAtOuterRow(row: Int) -> (Int, Int) {
        var totalRow = 0

        for var i = 0; i < cachedSections!.count; i++ {
            let sectionRows = cachedSections![i]
            totalRow += sectionRows

            if row < totalRow {
                return (i, row - (totalRow - sectionRows))
            }
        }

        fatalError("Outer row out of bounds")
    }


    // MARK: Selecting items
    // ------------------------------------------------------------------------

    public var selectedRow: Int? {
        return tableView.selectedRow
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        handleSelectionChange(tableView.selectedRowIndexes)
    }

    public func selectRow(index: Int) {
        selectIndexes(NSIndexSet(index: index))
    }

    public func selectIndexes(indexes: NSIndexSet) {
        tableView.selectRowIndexes(indexes, byExtendingSelection: false)

        handleSelectionChange(indexes)
    }

    public func reselectIndexes(proposedIndexes: NSIndexSet) {
        let indexes = indexesForReselection(proposedIndexes)

        selectIndexes(indexes)
    }

    func indexesForReselection(indexes: NSIndexSet) -> NSIndexSet {
        if indexes.count > 0 {
            var index = indexes.firstIndex

            var item: NKTableItem!

            while true {
                item = itemAt(index)

                if item.selectable {
                    return NSIndexSet(index: index)
                } else {
                    if index - 1 >= 0 {
                        index = index - 1
                    } else {
                        return NSIndexSet()
                    }
                }
            }
        }

        return NSIndexSet()
    }

    public func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let item = self.itemAt(row)
        return item.selectable
    }

    func handleSelectionChange(indexes: NSIndexSet) {
        if indexes.count > 0 {
//            Log.w("Selection just changed to: \(indexes.firstIndex)")

            let item = self.itemAt(indexes.firstIndex)
            if let view = item.view {
                self.makeViewSelected(view)
            }

            onSelectRow?(index: indexes.firstIndex)
        } else {
//            Log.w("Deselected")

            self.resetSelectedView()

            onDeselectRow?()
        }
    }

    public func deselect() {
        fatalError("Deselect not implemented yet")
    }

    func makeViewSelected(view: NKTableCellView) {
        if let currentView = self.selectedView {
            currentView.setSelected(false, animated: false)
        }

        view.setSelected(true, animated: false)

        self.selectedView = view
    }

    func resetSelectedView() {
        if let currentView = self.selectedView {
            currentView.setSelected(false, animated: false)
        }
    }

    /*
    func markSelectedView(indexes: NSIndexSet) {
        forgetSelectedView()

        if indexes.count > 0 {
            let index = indexes.firstIndex

            if let view = tableView.viewAtColumn(0, row: index, makeIfNecessary: false) as? NKTableCellView {
                view.selected = true
                selectedView = view
            }
            
        }
    }

    func forgetSelectedView() {
        selectedView?.selected = false
        selectedView = nil
    }
    */

    
    
    // MARK: Recalculating heights
    
    public func recalculateHeightForView(view: NKTableCellView) {
        let indexes = NSMutableIndexSet()
        
        self.tableView.enumerateAvailableRowViewsUsingBlock { rowView, index in
            if view.isDescendantOf(rowView) {
                indexes.addIndex(index)
            }
        }
        
        recalculateHeights(indexes)
    }
    
    public func recalculateAllHeights() {
        let indexes = NSIndexSet(indexesInRange: NSMakeRange(0, tableView.numberOfRows))
        recalculateHeights(indexes)
    }
    
    public func recalculateHeights(indexes: NSIndexSet) {
        let context = NSAnimationContext.currentContext()
        
        NSAnimationContext.beginGrouping()
        context.duration = 0
        
        self.tableView.noteHeightOfRowsWithIndexesChanged(indexes)
        
        NSAnimationContext.endGrouping()
    }
    
    // MARK: Reordering
    
    public func tableView(tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        if !enableReordering {
            return nil
        }
        
        var canMove = true
        
        if let fun = self.canMoveItem {
            canMove = fun(at: row)
        }
        
        if canMove {
            let item = NSPasteboardItem()
            item.setString(String(row), forType: "public.data")
            return item
        } else {
            return nil
        }
        
    }
    
    public func tableView(tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        var canMove = true

        if let contents = info.draggingPasteboard().stringForType("public.data") {
            let index = Int(contents)
        
            if let fun = self.canDropItem {
                canMove = fun(from: index!, to: row)
            }
            
            if canMove && dropOperation == .Above {
                return .Move
            } else {
                return .None
            }

        }

        return .None
    }
    
    public func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        var oldIndexes = [Int]()
        info.enumerateDraggingItemsWithOptions(.Concurrent, forView: tableView, classes: [NSPasteboardItem.self], searchOptions: [:]) {
            if let index = Int(($0.0.item as! NSPasteboardItem).stringForType("public.data")!) {
                oldIndexes.append(index)
            }
        }
        
        var oldIndexOffset = 0
        var newIndexOffset = 0
        
        
        // For simplicity, the code below uses `tableView.moveRowAtIndex` to move rows around directly.
        // You may want to move rows in your content array and then call `tableView.reloadData()` instead.
        tableView.beginUpdates()
        for oldIndex in oldIndexes {
            if oldIndex < row {
//                tableView.moveRowAtIndex(oldIndex + oldIndexOffset, toIndex: row - 1)
                moveItem(oldIndex + oldIndexOffset, toIndex: row - 1)
                --oldIndexOffset
            } else {
//                tableView.moveRowAtIndex(oldIndex, toIndex: row + newIndexOffset)
                moveItem(oldIndex, toIndex: row + newIndexOffset)
                ++newIndexOffset
            }
        }
        
        tableView.endUpdates()
        
        return true
    }
    
    func moveItem(atIndex: Int, toIndex: Int) {
        if let fun = self.moveItem {
            fun(atIndex: atIndex, toIndex: toIndex)
        }
    }

    public func toggleReordering() { // Doesn't do anything on Mac
    }

    // MARK: Hiding/showing rows
    // -----------------------------------------------------------------------

    public func hideRowAt(index: Int) {
        if hiddenIndexes.containsIndex(index) {
            return
        }

        hiddenIndexes.addIndex(index)

        if let view = itemAt(index).view {
            view.hide()
        }

        recalculateAllHeights()
    }

    public func unhideRowAt(index: Int) {
        if !hiddenIndexes.containsIndex(index) {
            return
        }

        hiddenIndexes.removeIndex(index)

        if let view = itemAt(index).view {
            view.show()
        }
        
        recalculateAllHeights()
    }

    public func isRowHidden(index: Int) -> Bool {
        return hiddenIndexes.containsIndex(index)
    }

    // MARK: Scrolling
    // -----------------------------------------------------------------------

    public func scrollToBottom() {
        let rows = tableView.numberOfRows
        tableView.scrollRowToVisible(rows - 1)
    }
}


class NKTableRowView: NSTableRowView {
    var isLast = false
    var drawSelection: ((rect: NSRect) -> ())?
    
    override func drawSelectionInRect(dirtyRect: NSRect) {
        self.drawSelection?(rect: self.bounds)
    }

    override func drawSeparatorInRect(dirtyRect: NSRect) {
        if !isLast {
            super.drawSeparatorInRect(dirtyRect)
        }
    }
}
