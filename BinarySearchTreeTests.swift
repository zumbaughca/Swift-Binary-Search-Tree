//
//  BinarySearchTreeTests.swift
//  
//
//  Created by Chuck Zumbaugh on 5/11/21.
//

class BinaryTreeTests: XCTestCase {
    var testTree: BinarySearchTree<Int>!
    /*
     * Example Tree:
     *             5
     *            /  \
     *           /    \
     *          3      7
     *         / \    / \
     *        2   4  6   8
     *       /            \
     *      1              9
     *
     * Array: [5, 3, 7, 2, 4, 6, 8, 1, 9]
     */
    
    override func setUp() {
        super.setUp()
        self.testTree = BinarySearchTree(array: [5, 3, 7, 2, 4, 6, 8, 1, 9])
    }
    
    func testTreeNodeInit() {
        let node = BinarySearchTree(value: 1)
        XCTAssertEqual(node.value, 1)
        XCTAssertNil(node.leftChild)
        XCTAssertNil(node.rightChild)
        XCTAssertNil(node.parent)
    }
    
    func testTreeInit() {
        let tree = BinarySearchTree(value: 1)
        XCTAssertEqual(tree.value, 1)
        XCTAssertNil(tree.leftChild)
        XCTAssertNil(tree.rightChild)
        XCTAssertNil(tree.parent)
    }
    
    func testTreeInitFromArray() {
        let array = [0, 1, 2, -1, -2, 15, 23, 12]
        let tree = BinarySearchTree(array: array)
        XCTAssertEqual(tree.value, 0)
        XCTAssertEqual(tree.leftChild?.value, -1)
        XCTAssertEqual(tree.rightChild?.value, 1)
        XCTAssertEqual(tree.leftChild?.leftChild?.value, -2)
        XCTAssertEqual(tree.rightChild?.rightChild?.value, 2)
        XCTAssertEqual(tree.rightChild?.rightChild?.rightChild?.value, 15)
        XCTAssertEqual(tree.rightChild?.rightChild?.rightChild?.rightChild?.value, 23)
        XCTAssertEqual(tree.rightChild?.rightChild?.rightChild?.leftChild?.value, 12)
    }
    
    func testInsert() {
        let tree = BinarySearchTree(value: 1)
        tree.insert(value: 2)
        tree.insert(value: 0)
        tree.insert(value: 2)
        XCTAssertEqual(tree.value, 1)
        XCTAssertEqual(tree.leftChild?.value, 0)
        XCTAssertEqual(tree.rightChild?.value, 2)
        XCTAssertEqual(tree.rightChild?.rightChild?.value, 2)
    }
    
    func testRemove() {
        let tree = BinarySearchTree(array: [0, -1, 1, -2, 2, -3, 3, 4, -4])
        XCTAssertEqual(tree.value, 0)
        tree.rightChild?.remove()
        tree.rightChild?.remove()
        tree.leftChild?.leftChild?.remove()
        XCTAssertNil(tree.search(for: 1))
        XCTAssertNil(tree.search(for: 2))
        XCTAssertNil(tree.search(for: -2))
        XCTAssertEqual(tree.leftChild?.leftChild?.value, -3)
    }
    
    func testRemoveWithValue() {
        let tree = BinarySearchTree(array: [5, 4, 6, 3.5, 7, 2, 8])
        tree.removeNodeWithValue(value: 3.5)
        XCTAssertNil(tree.search(for: 3.5))
        XCTAssertEqual(tree.leftChild?.leftChild?.value, 2)
        XCTAssertNil(tree.leftChild?.rightChild)
    }
    
    func testPreOrderTraversals() {
        var array = [Int]()
        func appendArray(_ value: Int) {
            array.append(value)
        }
        testTree.traversePreOrder(methodToExecute: appendArray(_:))
        XCTAssertEqual(array, [5, 3, 2, 1, 4, 7, 6, 8, 9])
    }
    
    func testInOrderTraversal() {
        var array = [Int]()
        func appendArray(_ value: Int) {
            array.append(value)
        }
        testTree.traverseInOrder(methodToExecute: appendArray(_:))
        XCTAssertEqual(array, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    }
    
    func testPostOrderTraversal() {
        var array = [Int]()
        func appendArray(_ value: Int) {
            array.append(value)
        }
        testTree.traversePostOrder(methodToExecute: appendArray(_:))
        XCTAssertEqual(array, [1, 2, 4, 3, 6, 9, 8, 7, 5])
    }
    
    func testPredescessor() {
        XCTAssertEqual(testTree.predecessor(), 4)
        XCTAssertEqual(testTree.predecessor(of: 8), 7)
        XCTAssertEqual(testTree.predecessor(of: 3), 2)
        XCTAssertEqual(testTree.predecessor(of: 9), 8)
        XCTAssertNil(testTree.predecessor(of: 1))
    }
    
    func testSuccessor() {
        XCTAssertEqual(testTree.successor(), 6)
        XCTAssertEqual(testTree.successor(of: 2), 3)
        XCTAssertEqual(testTree.successor(of: 1), 2)
        XCTAssertEqual(testTree.successor(of: 8), 9)
        XCTAssertNil(testTree.successor(of: 9))
    }
    
    func testHeight() {
        XCTAssertEqual(testTree.height(), 3)
        XCTAssertEqual(testTree.height(of: 1), 0)
        XCTAssertEqual(testTree.height(of: 7), 2)
        XCTAssertEqual(testTree.height(of: 6), 0)
    }
    
    func testDepth() {
        XCTAssertEqual(testTree.depth(), 0)
        XCTAssertEqual(testTree.depth(of: 1), 3)
        XCTAssertEqual(testTree.depth(of: 6), 2)
        XCTAssertEqual(testTree.depth(of: 4), 2)
        XCTAssertEqual(testTree.depth(of: 9), 3)
    }
}
