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


open class NKTableBuilder: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    // MARK: - Properties
    // ------------------------------------------------------------------------

    // Core props
    open let scrollView: NSScrollView
    open let tableView: NKTableView
    open let mainView: NKView
    open var items = [NKTableItem]() {
        didSet {
            reload()
        }
    }
    let hiddenIndexes = NSMutableIndexSet()

    // UI
    open var showsVerticalScrollIndicator: Bool = false // Doesn't do anything
    open var padding: NKPadding? {
        didSet { setPadding(padding!) } // TODO: This should be done through styles
    }
    open var enableReordering: Bool = false {
        didSet { applyEnableReordering(enableReordering) }
    }
    open var menu: NSMenu? {
        get { return self.tableView.menu }
        set { self.tableView.menu = newValue }
    }
    open var columnWidth: CGFloat { return tableView.tableColumns[0].width }

    // Classic API
    open var numberOfSections: (() -> Int)?
    open var numberOfRows: ((_ section: Int) -> Int)?
    open var itemForRow: ((_ section: Int, _ row: Int) -> NKTableItem)?

    // Section headers
    open var viewForHeader: ((_ section: Int) -> NKView)?
    open var headerHeight: CGFloat?

    // Height
    open var calcRowHeight: ((_ row: Int) -> CGFloat)?
    open var rowHeight: CGFloat?

    // Selecting
    open var onSelectRow: ((_ index: Int) -> ())?
    open var onDeselectRow: (() -> ())?
    open var selectedView: NKTableCellView?
    dynamic var _selectionIndexes: IndexSet?

    // Events
    open var onTap: (() -> ())?                      // iOS only - doesn't do anything here
    open var onTapOut: (() -> ())?                   // iOS only - doesn't do anything here
    open var onDelete: ((_ row: Int) -> ())?           // TODO: Implement
    open var onScroll: ((_ offset: CGPoint) -> ())?    // Not sure about this one
    open var onStartScrolling: NKSimpleCallback?
    open var onDoubleClick: (() -> ())? {
        get { return tableView.onDoubleClick }
        set { tableView.onDoubleClick = newValue }
    }
    open var onMenu: ((Int) -> (NSMenu?))? {
        get { return tableView.onMenu }
        set { tableView.onMenu = newValue }
    }

    
    // Reordering callbacks
    open var canMoveItem: ((_ at: Int) -> Bool)?
    open var targetRowForMove: ((_ from: Int, _ to: Int) -> Int)?    // Not used here, TODO: make it somehow work with iOS
    open var canDropItem: ((_ from: Int, _ to: Int) -> Bool)?
    open var moveItem: ((_ atIndex: Int, _ toIndex: Int) -> ())?



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
        column.resizingMask = .autoresizingMask
        tableView.addTableColumn(column)

        tableView.selectionHighlightStyle = .none
        tableView.intercellSpacing = CGSize(width: 0, height: 0)
        
        tableView.delegate = self
        tableView.dataSource = self

        
        tableView.headerView = nil
        scrollView.documentView = tableView

        tableView.bind("selectionIndexes", to: self, withKeyPath: "_selectionIndexes", options: nil)
        self.addObserver(self, forKeyPath: "_selectionIndexes", options: .new, context: nil)
    }

    open func reload() {
//        NiceKit.log?("Reloading! 😈")

        hiddenIndexes.removeAllIndexes()

        let indexes = tableView.selectedRowIndexes

        tableView.reloadData()
        tableView.layoutSubtreeIfNeeded()

        self.reselectIndexes(indexes as IndexSet)

//        NSTimer.schedule(delay: 0.1) { _ in
//            // - Come on Vojto, this code is shit and you know it!
//            // - But it works.
//            self.reselectIndexes(indexes)
//        }

    }

    // MARK: Public API
    // ------------------------------------------------------------------------

    open func viewAt(_ index: Int) -> NSView? {
        return tableView.view(atColumn: 0, row: index, makeIfNecessary: false)
    }

    open func indexForView(_ view: NKTableCellView) -> Int? {
        return items.index { $0.view == view }
    }
    

    // MARK: - UI Helpers
    // ------------------------------------------------------------------------

    func setPadding(_ padding: NKPadding) {
        if let padding = self.padding {
            self.scrollView.automaticallyAdjustsContentInsets = false
            self.scrollView.contentInsets = padding.edgeInsets
        } else {
            self.scrollView.automaticallyAdjustsContentInsets = true
        }
    }

    func applyEnableReordering(_ enable: Bool) {
        if enable {
            tableView.register(forDraggedTypes: ["public.data"])
        } else {
            tableView.unregisterDraggedTypes()
        }
    }

    // MARK: - Main data source methods
    // ------------------------------------------------------------------------

    
    
    
    @nonobjc open func numberOfRowsInTableView(_ tableView: NSTableView) -> Int {
        if isCustomMode {
            return self.numberOfRowsInCustomMode()
        } else {
            return items.count
        }
    }
    
    open func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        // Return the header view if that's the case
        if isCustomMode {
            let (section, row) = self.indexPathAtOuterRow(row)
            if row == 0 {
                return self.viewForHeader!(section)
            }

        }

        let item = self.itemAt(row)

        let identifier = String(describing: item.viewClass)
        var view = tableView.make(withIdentifier: identifier, owner: self) as! NKTableCellView?

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
    
    open func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let height = heightForRowAt(row)

        if height == 0 {
            return 1
        } else {
            return height
        }
    }

    func heightForRowAt(_ row: Int) -> CGFloat {
        if hiddenIndexes.contains(row) {
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
            return self.calcRowHeight!(row)
        } else {
            return 22.0
        }
    }



    // MARK: Accessing items
    // ------------------------------------------------------------------------

    open func itemAt(_ row: Int) -> NKTableItem {
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

        
        for i in 0 ..< self.numberOfSections!() {
            let count = self.numberOfRows!(i) + 1
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

    func itemForCustomModeAt(_ outerRow: Int) -> NKTableItem {
        // Find section

        let (section, row) = indexPathAtOuterRow(outerRow)

        if section == 0 {
            return NKTableItem()
        } else {
            return self.itemForRow!(section, row - 1)
        }
    }

    func indexPathAtOuterRow(_ row: Int) -> (Int, Int) {
        var totalRow = 0

        for i in 0 ..< cachedSections!.count {
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

    open var selectedRow: Int? {
        return tableView.selectedRow
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        handleSelectionChange(tableView.selectedRowIndexes as IndexSet)
    }

    open func selectRow(_ index: Int) {
        selectIndexes(NSIndexSet(index: index) as IndexSet)
    }

    open func selectIndexes(_ indexes: IndexSet) {
        tableView.selectRowIndexes(indexes as IndexSet, byExtendingSelection: false)

        handleSelectionChange(indexes)
    }

    open func reselectIndexes(_ proposedIndexes: IndexSet) {
        let indexes = indexesForReselection(proposedIndexes)

        selectIndexes(indexes)
    }

    func indexesForReselection(_ indexes: IndexSet) -> IndexSet {
        if indexes.count > 0 {
            var index = indexes.first

            var item: NKTableItem!

            while true {
                item = itemAt(index!)

                if item.selectable {
                    return IndexSet(integer: index!)
                } else {
                    if index! - 1 >= 0 {
                        index = index! - 1
                    } else {
                        return IndexSet()
                    }
                }
            }
        }

        return IndexSet()
    }

    open func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let item = self.itemAt(row)
        return item.selectable
    }

    func handleSelectionChange(_ indexes: IndexSet) {
        if indexes.count > 0 {
//            Log.w("Selection just changed to: \(indexes.firstIndex)")

            let item = self.itemAt(indexes.first!)
            if let view = item.view {
                self.makeViewSelected(view)
            }

            onSelectRow?(indexes.first!)
        } else {
//            Log.w("Deselected")

            self.resetSelectedView()

            onDeselectRow?()
        }
    }

    open func deselect() {
        fatalError("Deselect not implemented yet")
    }

    func makeViewSelected(_ view: NKTableCellView) {
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
    
    open func recalculateHeightForView(_ view: NKTableCellView) {
        let indexes = NSMutableIndexSet()
        
        self.tableView.enumerateAvailableRowViews { rowView, index in
            if view.isDescendant(of: rowView) {
                indexes.add(index)
            }
        }
        
        recalculateHeights(indexes as IndexSet)
    }
    
    open func recalculateAllHeights() {
        let indexes = NSIndexSet(indexesIn: NSMakeRange(0, tableView.numberOfRows)) as IndexSet
        recalculateHeights(indexes)
    }
    
    open func recalculateHeights(_ indexes: IndexSet) {
        let context = NSAnimationContext.current()
        
        NSAnimationContext.beginGrouping()
        context.duration = 0
        
        self.tableView.noteHeightOfRows(withIndexesChanged: indexes as IndexSet)
        
        NSAnimationContext.endGrouping()
    }
    
    // MARK: Reordering
    
    open func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        if !enableReordering {
            return nil
        }
        
        var canMove = true
        
        if let fun = self.canMoveItem {
            canMove = fun(row)
        }
        
        if canMove {
            let item = NSPasteboardItem()
            item.setString(String(row), forType: "public.data")
            return item
        } else {
            return nil
        }
        
    }
    
    open func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        var canMove = true

        if let contents = info.draggingPasteboard().string(forType: "public.data") {
            let index = Int(contents)
        
            if let fun = self.canDropItem {
                canMove = fun(index!, row)
            }
            
            if canMove && dropOperation == .above {
                return .move
            } else {
                return []
            }

        }

        return []
    }
    
    open func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        var oldIndexes = [Int]()
        info.enumerateDraggingItems(options: .concurrent, for: tableView, classes: [NSPasteboardItem.self], searchOptions: [:]) {
            if let index = Int(($0.0.item as! NSPasteboardItem).string(forType: "public.data")!) {
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
                self.moveItem(oldIndex + oldIndexOffset, toIndex: row - 1)
                oldIndexOffset -= 1
            } else {
//                tableView.moveRowAtIndex(oldIndex, toIndex: row + newIndexOffset)
                self.moveItem(oldIndex, toIndex: row + newIndexOffset)
                newIndexOffset += 1
            }
        }
        
        tableView.endUpdates()
        
        return true
    }
    
    func moveItem(_ atIndex: Int, toIndex: Int) {
        if let fun = self.moveItem {
            fun(atIndex, toIndex)
        }
    }

    open func toggleReordering() { // Doesn't do anything on Mac
    }

    // MARK: Hiding/showing rows
    // -----------------------------------------------------------------------

    open func hideRowAt(_ index: Int) {
        if hiddenIndexes.contains(index) {
            return
        }

        hiddenIndexes.add(index)

        if let view = itemAt(index).view {
            view.isHidden = true
        }

        recalculateAllHeights()
    }

    open func unhideRowAt(_ index: Int) {
        if !hiddenIndexes.contains(index) {
            return
        }

        hiddenIndexes.remove(index)

        if let view = itemAt(index).view {
            view.isHidden = false
        }
        
        recalculateAllHeights()
    }

    open func isRowHidden(_ index: Int) -> Bool {
        return hiddenIndexes.contains(index)
    }

    // MARK: Scrolling
    // -----------------------------------------------------------------------

    open func scrollToBottom() {
        let rows = tableView.numberOfRows
        tableView.scrollRowToVisible(rows - 1)
    }
}


class NKTableRowView: NSTableRowView {
    var isLast = false
    var drawSelection: ((_ rect: NSRect) -> ())?
    
    override func drawSelection(in dirtyRect: NSRect) {
        self.drawSelection?(self.bounds)
    }

    override func drawSeparator(in dirtyRect: NSRect) {
        if !isLast {
            super.drawSeparator(in: dirtyRect)
        }
    }
}
