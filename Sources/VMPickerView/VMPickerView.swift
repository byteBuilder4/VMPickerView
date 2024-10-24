//
//  VMPickerView.swift
//  VMPickerViewDemo
//
//  Created by Vasi Margariti on 18/10/2024.
//

import UIKit

public class VMPickerView: UIView {
    
    
    // MARK: - Public Properties
    
    /// The height of each cell in the picker view.
    /// Default value is 40.
    public let cellHeight: CGFloat = 50
    
    /// Determines whether the picker view should apply dynamic appearance effects (such as scaling and color changes).
    /// If `true`, dynamic appearance changes are enabled based on the cell's position.
    /// Default value is `true`.
    public let enableDynamicAppearance: Bool = true
    
    /// Indicates whether the cells should be scaled as they move toward or away from the center of the picker view.
    /// If `true`, scaling is applied to the cells.
    /// Default value is `true`.
    public var isScaled: Bool = true
    
    /// The scale factor applied to the cells during dynamic appearance.
    /// A value between 0 and 1, where 0 means no scaling and 1 applies maximum scaling.
    /// Default value is 0.5. The value is clamped between 0 and 1.
    public var scaleFactor: CGFloat = 0.6 {
        didSet {
            self.scaleFactor = min(max(self.scaleFactor, 0), 1)
        }
    }
    
    /// The background color applied to the currently highlighted (selected) cell while unhighlighted cell is clear
    public var highlightedBackgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    
    /// The text color applied to the title label of the currently highlighted (selected) cell.
    public var highlightedTextColor = UIColor.white
    
    /// The text color applied to the title label of unhighlighted (non-selected) cells.
    public var unhighlightedTextColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    
    /// The minimum font size applied to the title label of the unhighlighted (non-selected) cells.
    public var minFontSize: CGFloat = 11
    
    /// The maximum font size applied to the title label of the highlighted (selected) cell.
    public var maxFontSize: CGFloat = 22
    
    /// The minimum font weight applied to the title label of the unhighlighted (non-selected) cells.
    public var minFontWeight: UIFont.Weight = UIFont.Weight.light
    
    /// The maximum font weight applied to the title label of the highlighted (selected) cell.
    public var maxFontWeight: UIFont.Weight = UIFont.Weight.black
    
    // delegate
    public weak var delegate: VMPickerViewDelegate?
    public weak var dataSource: VMPickerViewDataSource?
    
    
    
    // MARK: - Private Properties
    
    private var tableView: UITableView!
    
    private var currentSelectedItem: Int {
        let partialItem = self.tableView.contentOffset.y / self.cellHeight
        let baseItem = lroundf(Float(partialItem))
        return max(1, min(self.numberOfItems, baseItem))
    }
    private var numberOfItems: Int {
        return self.dataSource?.numberOfItemsInPickerView(self) ?? 0
    }
    

    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        print("")
    }
    
    
    
    
    
    
    
    // MARK: - Methods
    
    func updateVisibleCells() {
        guard let visibleIndexPaths = self.tableView.indexPathsForVisibleRows else { return }
        
        let centerY = self.tableView.bounds.size.height / 2 + self.tableView.contentOffset.y
        let maxDistance = self.tableView.bounds.size.height / 2
        
        for indexPath in visibleIndexPaths {
            guard let cell = self.tableView.cellForRow(at: indexPath) as? VMPickerViewCell else { continue }
            
            if !self.enableDynamicAppearance {
                cell.isPicked = (indexPath.row == self.currentSelectedItem) ? true : false
            } else {
                
                let cellCenterY = cell.center.y
                let distanceFromCenter = abs(cellCenterY - centerY)
                
                let influenceInCells: CGFloat = 1
                let normalizedDistance = min(distanceFromCenter / maxDistance, 1.0)
                let influencedDistance = min(distanceFromCenter / (cellHeight * influenceInCells), 1.0)
                
                cell.titleLabel.backgroundColor = self.highlightedBackgroundColor.withAlphaComponent(1 - influencedDistance)
                

                let fontSize = minFontSize + (maxFontSize - minFontSize) * (1 - influencedDistance)
                let fontWeightValue = minFontWeight + (maxFontWeight - minFontWeight) * (1 - influencedDistance)
                let fontWeight = UIFont.Weight(rawValue: fontWeightValue.rawValue)
                
                cell.titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
                
                cell.titleLabel.textColor = UIColor().interpolateColor(from: self.unhighlightedTextColor,
                                                                       to: self.highlightedTextColor,
                                                                       progress: 1 - influencedDistance)
                
                if isScaled {
                    let appliedScale = 1.0 - (self.scaleFactor * normalizedDistance)
                    cell.titleLabel.transform = CGAffineTransform(scaleX: appliedScale, y: appliedScale)
                }
                
            }
            
        }
    }
    
    /// Selects the specified item in the picker view.
    public func scrollTo(item: Int, animated: Bool = true) {
        let selectedIndexPath = IndexPath(row: item, section: 0)
        
        self.tableView.selectRow(at: selectedIndexPath, animated: animated, scrollPosition: .middle)
        self.delegate?.pickerView(pickerView: self, didSelectItem: item)
        
        self.updateVisibleCells()
    }
    
    
    
}
extension VMPickerView: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItems + 2 // dummy cells
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VMPickerViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        let originalIndex = indexPath.row - 1
        
        if originalIndex >= 0 && originalIndex < self.numberOfItems {
            if let title = self.dataSource?.pickerView(self, titleForItem: originalIndex) {
                cell.titleLabel.text = title
            } else {
                cell.titleLabel.text = ""
            }
        } else {
            cell.titleLabel.text = ""
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let numberOfRowsInPickerView = self.numberOfItems + 2
        
        if (indexPath as NSIndexPath).row == 0 {
            return (self.tableView.bounds.height / 2) + (self.cellHeight / 2)
        } else if numberOfRowsInPickerView > 0 && indexPath.row == numberOfRowsInPickerView - 1 {
            return (self.tableView.bounds.height / 2) + (self.cellHeight / 2)
        }
        
        return self.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let originalIndex = indexPath.row - 1
        
        if originalIndex >= 0 && originalIndex < self.numberOfItems {
            self.scrollTo(item: indexPath.row)
        }
        
    }
    
    
    
    
    // scroll view delegate //
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollTo(item: self.currentSelectedItem)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollTo(item: self.currentSelectedItem)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateVisibleCells()
    }
    
    
    
}
extension VMPickerView {
    func setup() {
        tableView = UITableView()
        tableView.decelerationRate = UIScrollView.DecelerationRate.fast
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(VMPickerViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        //-
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
