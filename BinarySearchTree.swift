//
//  BinarySearchTree.swift
//  
//
//  Created by Chuck Zumbaugh on 5/11/21.
//

class BinarySearchTree<T: Comparable> {
    var value: T
    var parent: BinarySearchTree?
    var leftChild: BinarySearchTree?
    var rightChild: BinarySearchTree?
    
    var isRoot: Bool {
        return parent == nil
    }
    
    var isLeftChild: Bool {
        return parent?.leftChild === self
    }
    
    var isRightChild: Bool {
        return parent?.rightChild === self
    }
    
    var isLeaf: Bool {
        return leftChild == nil && rightChild == nil
    }
    
    var hasLeftChild: Bool {
        return self.leftChild != nil
    }
    
    var hasRightChild: Bool {
        return self.rightChild != nil
    }
    
    var hasChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }
    
    init(value: T, parent: BinarySearchTree?, leftChild: BinarySearchTree?, rightChild: BinarySearchTree?) {
        self.value = value
        self.parent = parent
        self.leftChild = leftChild
        self.rightChild = rightChild
    }
    
    convenience init(value: T) {
        self.init(value: value, parent: nil, leftChild: nil, rightChild: nil)
    }
}

extension BinarySearchTree {
    
    
    func search(for value: T) -> BinarySearchTree? {
        if value < self.value {
            return leftChild?.search(for: value)
        } else if value > self.value {
            return rightChild?.search(for: value)
        } else if self.value == value {
            return self
        } else {
            return nil
        }
    }
    
    convenience init(array: [T]) {
        self.init(value: array[0])
        for i in 1 ..< array.count {
            self.insert(value: array[i])
        }
    }
    
}

extension BinarySearchTree {
    func insert(value: T) {
        if value < self.value {
            if let left = self.leftChild {
                left.insert(value: value)
            } else {
                self.leftChild = BinarySearchTree(value: value)
                leftChild?.parent = self
            }
        } else {
            if let right = self.rightChild {
                right.insert(value: value)
            } else {
                rightChild = BinarySearchTree(value: value)
                rightChild?.parent = self
            }
        }
    }
}

extension BinarySearchTree {
    private func minimum() -> BinarySearchTree<T> {
        var node = self
        while let left = node.leftChild {
            node = left
        }
        return node
    }
    
    private func maximum() -> BinarySearchTree<T> {
        var node = self
        while let right = node.rightChild {
            node = right
        }
        return node
    }
    
    private func reconnectParentTo(node: BinarySearchTree<T>?) {
        guard node != nil else { return }
        if let parent = parent {
            if isLeftChild {
                parent.leftChild = node
            } else {
                parent.rightChild = node
            }
            node?.parent = parent
        }
    }
    
    func remove() -> BinarySearchTree? {
        let replacement: BinarySearchTree<T>?
        
        if let left = leftChild {
            if let right = rightChild {
                replacement = removeNodeWithBothChildren(left, right)
            } else {
                replacement = leftChild
            }
        } else if let right = rightChild {
            replacement = right
        } else {
            replacement = nil
        }

        reconnectParentTo(node: replacement)
        
        parent = nil
        leftChild = nil
        rightChild = nil
        
        return replacement
    }
    
    func removeNodeWithValue(value: T) -> BinarySearchTree? {
        let node = search(for: value)
        return node?.remove()
    }
    
    private func removeNodeWithBothChildren(_ leftChild: BinarySearchTree<T>, _ rightChild: BinarySearchTree<T>) -> BinarySearchTree<T> {
        let successor = rightChild.minimum()
        successor.remove()
        successor.leftChild = leftChild
        leftChild.parent = successor
        
        if rightChild !== successor {
            successor.rightChild = rightChild
            rightChild.parent = successor
        } else {
            successor.rightChild = nil
        }
        return successor
    }
}

//MARK: Height and depth of a node
extension BinarySearchTree {
    /*
     * The height is the distance from the node to the leaf.
     * If the node is a leaf node, it's height is zero
     * Otherwise traverse down the tree to the root and return the larger distance.
     */
    func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(leftChild?.height() ?? 0, rightChild?.height() ?? 0)
        }
    }
    
    func height(of value: T) -> Int? {
        return search(for: value)?.height()
    }
    
    
    /*
     * The depth is the distance from the current node to the root.
     * Start at the current node. While as long as it has a parent, traverse up the tree to the root.
     * Increment the count at each level.
     */
    func depth() -> Int {
        var node = self
        var count = 0
        while let parent = node.parent {
            count += 1
            node = parent
        }
        return count
    }
    
    func depth(of value: T) -> Int? {
        return search(for: value)?.depth()
    }

}

//MARK: Predecessor and successor
extension BinarySearchTree {
    /*
     * Search the tree for the value immediately preceeding the given node
     */
    func predecessor() -> T? {
        //If the node has a left branch, the predecessor is the maximum value in that branch.
        if let leftChild = leftChild {
            return leftChild.maximum().value
        } else {
            //Otherwise traverse up the tree to find the preceeding value
            var node = self
            while let parent = node.parent {
                if parent.value < self.value {
                    return parent.value
                }
                node = parent
            }
        }
        return nil
    }
    
    // Returns the predecessor of the provided value if it exists
    // Note this will be the first occurance of the value in the tree
    func predecessor(of value: T) -> T? {
        let searchNode = search(for: value)
        guard searchNode != nil else { return nil }
        return searchNode?.predecessor()
    }
    
    func successor() -> T? {
        // If the node has a right branch, follow its minimum value
        if let rightChild = rightChild {
            return rightChild.minimum().value
        } else {
            //Otherwise traverse up the tree to find the succeeding value
            var node = self
            while let parent = node.parent {
                if parent.value > self.value {
                    return parent.value
                }
                node = parent
            }
        }
        return nil
    }
    
    // Returns the successor of the provided value if it exists
    // Note this will be the first occurance of the value in the tree
    func successor(of value: T) -> T? {
        let searchNode = search(for: value)
        return searchNode?.successor()
    }
}

//MARK: Tree Traversals
extension BinarySearchTree {
    
    /*
     * In order traversal:
     * Visit left node
     * Visit root node
     * Visit right node
     */
    func traverseInOrder(methodToExecute: (T) -> ()) {
        leftChild?.traverseInOrder(methodToExecute: methodToExecute)
        methodToExecute(self.value)
        rightChild?.traverseInOrder(methodToExecute: methodToExecute)
    }
    
    /*
     * Pre-order traversal:
     * Visit the root node
     * Visit the left node
     * Visit the right node
     */
    func traversePreOrder(methodToExecute: (T) -> ()) {
        methodToExecute(self.value)
        leftChild?.traversePreOrder(methodToExecute: methodToExecute)
        rightChild?.traversePreOrder(methodToExecute: methodToExecute)
    }
    
    /*
     * Post-order traversal
     * Visit the left node
     * Visit the right node
     * Visit the root node
     */
    func traversePostOrder(methodToExecute: (T) -> ()) {
        leftChild?.traversePostOrder(methodToExecute: methodToExecute)
        rightChild?.traversePostOrder(methodToExecute: methodToExecute)
        methodToExecute(self.value)
    }
}

//MARK: Custom string convertible
extension BinarySearchTree: CustomStringConvertible {
    var description: String {
        var str = ""
        if let leftChild = leftChild {
            str += "(\(leftChild.description)) <-"
        }
        str += "\(self.value)"
        if let rightChild = rightChild {
            str += "-> (\(rightChild.description))"
        }
        
        return str
    }
    
    
}
