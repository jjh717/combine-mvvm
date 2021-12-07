//
//  ReusableView.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import UIKit
 
public protocol ReusableView {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableView {}
extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}

extension UITableView {
    // register Cell
    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // register HeaderFooterView
    public func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // reusable Cell
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    // reusable HeaderFooterView
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ : T.Type) -> T {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue Header/Footer with identifier: \(T.defaultReuseIdentifier)")
        }
        return headerFooter
    }
}


extension UICollectionView {
    // register Cell
    public func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // register SupplementaryView
    public func register<T: UICollectionReusableView>(_: T.Type, ofKind kind: String = UICollectionView.elementKindSectionHeader) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // reusable Cell
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    // reusable SupplementaryView
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String = UICollectionView.elementKindSectionHeader, for indexPath: IndexPath) -> T {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.defaultReuseIdentifier)")
        }
        return supplementaryView
    }
}
