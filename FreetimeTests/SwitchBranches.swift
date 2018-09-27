//
//  SwitchBranches.swift
//  FreetimeTests
//
//  Created by B_Litwin on 9/24/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import XCTest
@testable import Freetime
import Foundation
import IGListKit
import StyledTextKit

class SwitchBranches: XCTestCase {
    
    func test2() {
        
        let models = MarkdownModels(testContent,
                                    owner: "githawkapp",
                                    repo: "githawk",
                                    width: 320,
                                    viewerCanUpdate: false,
                                    contentSizeCategory: UIContentSizeCategory.preferred,
                                    isRoot: false)
        
//        let styledText = StyledText(text: "AA")
//        let string = StyledTextString(styledTexts: [styledText])
//        let model = StyledTextRenderer(string: string, contentSizeCategory: UIContentSizeCategory.preferred)

        let viewController = TestViewController(emptyErrorMessage: "")
        viewController.models = models
        viewController.loadViewIfNeeded()
        viewController.update(animated: true)
        viewController.update(animated: true)
    }



    class TestViewController: BaseListViewController<NSString>,
    BaseListViewControllerDataSource {

        var models: [ListDiffable] = []

        func headModels(listAdapter: ListAdapter) -> [ListDiffable] {
            return []
        }

        func models(listAdapter: ListAdapter) -> [ListDiffable] {
            return models
        }

        func sectionController(model: Any, listAdapter: ListAdapter) -> ListSectionController {
            return RepositoryReadmeSectionController()
        }

        func emptySectionController(listAdapter: ListAdapter) -> ListSectionController {
            return RepositoryReadmeSectionController()
        }
    }
    
    
    let testContent = "# Source: [Wikipedia](https://en.wikipedia.org)\n" +
    "# Source: [Wikipedia](https://en.wikipedia.org)\n"
    
    
    
    override func setUp() {
        super.setUp()
        
    }
    
    class RepositoryOverviewTestSubclass: RepositoryOverviewViewController {
        let content: String
        let mockRepo: RepositoryDetails
        
        init(content: String) {
            self.content = content
            let githubclient = newGithubClient()
            let repoDetails = RepositoryDetails(owner: "githawkapp", name: "githawk", defaultBranch: "master", hasIssuesEnabled: true)
            self.mockRepo = repoDetails
            super.init(client: githubclient, repo: repoDetails)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func fetch(page: NSString?) {
            
            let models = MarkdownModels(
                content,
                owner: mockRepo.owner,
                repo: mockRepo.name,
                width: 320,
                viewerCanUpdate: false,
                contentSizeCategory: UIContentSizeCategory.preferred,
                isRoot: false,
                branch: "master"
            )
            
            let model = RepositoryReadmeModel(models: models)
            
            self.readme = model
            
            self.update(animated: trueUnlessReduceMotionEnabled)
        }
        
        override func sectionController(model: Any, listAdapter: ListAdapter) -> ListSectionController {
            let readMESectionController = RepositoryReadmeSectionController()
            readMESectionController.inset = UIEdgeInsets.zero
            return readMESectionController
        }
    }
    
    func test() {
        let viewController = RepositoryOverviewTestSubclass(content: testContent)
        viewController.loadViewIfNeeded()
        viewController.fetch(page: nil)
    }
    
}



/*
 let content = "# The Algorithms - Python <!-- [![Build Status](https://travis-ci.org/TheAlgorithms/Python.svg)](https://travis-ci.org/TheAlgorithms/Python) -->\n\n### All algorithms implemented in Python (for education)\n\nThese are for demonstration purposes only. There are many implementations of sorts in the Python standard library that are much better for performance reasons.\n\n## Sort Algorithms\n\n\n### Bubble\n![alt text][bubble-image]\n\nFrom [Wikipedia][bubble-wiki]: Bubble sort, sometimes referred to as sinking sort, is a simple sorting algorithm that repeatedly steps through the list to be sorted, compares each pair of adjacent items and swaps them if they are in the wrong order. The pass through the list is repeated until no swaps are needed, which indicates that the list is sorted.\n\n__Properties__\n* Worst case performance\tO(n^2)\n* Best case performance\tO(n)\n* Average case performance\tO(n^2)\n\n###### View the algorithm in [action][bubble-toptal]\n\n\n\n### Insertion\n![alt text][insertion-image]\n\nFrom [Wikipedia][insertion-wiki]: Insertion sort is a simple sorting algorithm that builds the final sorted array (or list) one item at a time. It is much less efficient on large lists than more advanced algorithms such as quicksort, heapsort, or merge sort.\n\n__Properties__\n* Worst case performance\tO(n^2)\n* Best case performance\tO(n)\n* Average case performance\tO(n^2)\n\n###### View the algorithm in [action][insertion-toptal]\n\n\n### Merge\n![alt text][merge-image]\n\nFrom [Wikipedia][merge-wiki]: In computer science, merge sort (also commonly spelled mergesort) is an efficient, general-purpose, comparison-based sorting algorithm. Most implementations produce a stable sort, which means that the implementation preserves the input order of equal elements in the sorted output. Mergesort is a divide and conquer algorithm that was invented by John von Neumann in 1945.\n\n__Properties__\n* Worst case performance\tO(n log n)\n* Best case performance\tO(n)\n* Average case performance\tO(n)\n\n\n###### View the algorithm in [action][merge-toptal]\n\n### Quick\n![alt text][quick-image]\n\nFrom [Wikipedia][quick-wiki]: Quicksort (sometimes called partition-exchange sort) is an efficient sorting algorithm, serving as a systematic method for placing the elements of an array in order.\n\n__Properties__\n* Worst case performance\tO(n^2)\n* Best case performance\tO(n log n) or O(n) with three-way partition\n* Average case performance\tO(n log n)\n\n###### View the algorithm in [action][quick-toptal]\n\n### Selection\n![alt text][selection-image]\n\nFrom [Wikipedia][selection-wiki]: The algorithm divides the input list into two parts: the sublist of items already sorted, which is built up from left to right at the front (left) of the list, and the sublist of items remaining to be sorted that occupy the rest of the list. Initially, the sorted sublist is empty and the unsorted sublist is the entire input list. The algorithm proceeds by finding the smallest (or largest, depending on sorting order) element in the unsorted sublist, exchanging (swapping) it with the leftmost unsorted element (putting it in sorted order), and moving the sublist boundaries one element to the right.\n\n__Properties__\n* Worst case performance\tO(n^2)\n* Best case performance\tO(n^2)\n* Average case performance\tO(n^2)\n\n###### View the algorithm in [action][selection-toptal]\n\n### Shell\n![alt text][shell-image]\n\nFrom [Wikipedia][shell-wiki]:  Shellsort is a generalization of insertion sort that allows the exchange of items that are far apart.  The idea is to arrange the list of elements so that, starting anywhere, considering every nth element gives a sorted list.  Such a list is said to be h-sorted.  Equivalently, it can be thought of as h interleaved lists, each individually sorted.\n\n__Properties__\n* Worst case performance O(nlog2 2n)\n* Best case performance O(n log n)\n* Average case performance depends on gap sequence\n\n###### View the algorithm in [action][shell-toptal]\n\n### Time-Complexity Graphs\n\nComparing the complexity of sorting algorithms (Bubble Sort, Insertion Sort, Selection Sort)\n\n[Complexity Graphs](https://github.com/prateekiiest/Python/blob/master/sorts/sortinggraphs.png)\n\n----------------------------------------------------------------------------------\n\n## Search Algorithms\n\n### Linear\n![alt text][linear-image]\n\nFrom [Wikipedia][linear-wiki]: linear search or sequential search is a method for finding a target value within a list. It sequentially checks each element of the list for the target value until a match is found or until all the elements have been searched.\n  Linear search runs in at worst linear time and makes at most n comparisons, where n is the length of the list.\n\n__Properties__\n* Worst case performance\tO(n)\n* Best case performance\tO(1)\n* Average case performance\tO(n)\n* Worst case space complexity\tO(1) iterative\n\n### Binary\n![alt text][binary-image]\n\nFrom [Wikipedia][binary-wiki]: Binary search, also known as half-interval search or logarithmic search, is a search algorithm that finds the position of a target value within a sorted array. It compares the target value to the middle element of the array; if they are unequal, the half in which the target cannot lie is eliminated and the search continues on the remaining half until it is successful.\n\n__Properties__\n* Worst case performance\tO(log n)\n* Best case performance\tO(1)\n* Average case performance\tO(log n)\n* Worst case space complexity\tO(1) \n\n----------------------------------------------------------------------------------------------------------------------\n\n## Ciphers\n\n### Caesar\n![alt text][caesar]<br>\nIn cryptography, a **Caesar cipher**, also known as Caesar\'s cipher, the shift cipher, Caesar\'s code or Caesar shift, is one of the simplest and most widely known encryption techniques.<br>\nIt is **a type of substitution cipher** in which each letter in the plaintext is replaced by a letter some fixed number of positions down the alphabet. For example, with a left shift of 3, D would be replaced by A, E would become B, and so on. <br>\nThe method is named after **Julius Caesar**, who used it in his private correspondence.<br>\nThe encryption step performed by a Caesar cipher is often incorporated as part of more complex schemes, such as the Vigenère cipher, and still has modern application in the ROT13 system. As with all single-alphabet substitution ciphers, the Caesar cipher is easily broken and in modern practice offers essentially no communication security.\n###### Source: [Wikipedia](https://en.wikipedia.org/wiki/Caesar_cipher)\n\n### Vigenère\nThe **Vigenère cipher** is a method of encrypting alphabetic text by using a series of **interwoven Caesar ciphers** based on the letters of a keyword. It is **a form of polyalphabetic substitution**.<br>\nThe Vigenère cipher has been reinvented many times. The method was originally described by Giovan Battista Bellaso in his 1553 book La cifra del. Sig. Giovan Battista Bellaso; however, the scheme was later misattributed to Blaise de Vigenère in the 19th century, and is now widely known as the \"Vigenère cipher\".<br>\nThough the cipher is easy to understand and implement, for three centuries it resisted all attempts to break it; this earned it the description **le chiffre indéchiffrable**(French for \'the indecipherable cipher\'). \nMany people have tried to implement encryption schemes that are essentially Vigenère ciphers. Friedrich Kasiski was the first to publish a general method of deciphering a Vigenère cipher in 1863.\n###### Source: [Wikipedia](https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher)\n\n### Transposition\nIn cryptography, a **transposition cipher** is a method of encryption by which the positions held by units of plaintext (which are commonly characters or groups of characters) are shifted according to a regular system, so that the ciphertext constitutes a permutation of the plaintext. That is, the order of the units is changed (the plaintext is reordered).<br> \nMathematically a bijective function is used on the characters\' positions to encrypt and an inverse function to decrypt.\n###### Source: [Wikipedia](https://en.wikipedia.org/wiki/Transposition_cipher)\n\n[bubble-toptal]: https://www.toptal.com/developers/sorting-algorithms/bubble-sort\n[bubble-wiki]: https://en.wikipedia.org/wiki/Bubble_sort\n[bubble-image]: https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Bubblesort-edited-color.svg/220px-Bubblesort-edited-color.svg.png \"Bubble Sort\"\n\n[insertion-toptal]: https://www.toptal.com/developers/sorting-algorithms/insertion-sort\n[insertion-wiki]: https://en.wikipedia.org/wiki/Insertion_sort\n[insertion-image]: https://upload.wikimedia.org/wikipedia/commons/7/7e/Insertionsort-edited.png \"Insertion Sort\"\n\n[quick-toptal]: https://www.toptal.com/developers/sorting-algorithms/quick-sort\n[quick-wiki]: https://en.wikipedia.org/wiki/Quicksort\n[quick-image]: https://upload.wikimedia.org/wikipedia/commons/6/6a/Sorting_quicksort_anim.gif \"Quick Sort\"\n\n[merge-toptal]: https://www.toptal.com/developers/sorting-algorithms/merge-sort\n[merge-wiki]: https://en.wikipedia.org/wiki/Merge_sort\n[merge-image]: https://upload.wikimedia.org/wikipedia/commons/c/cc/Merge-sort-example-300px.gif \"Merge Sort\"\n\n[selection-toptal]: https://www.toptal.com/developers/sorting-algorithms/selection-sort\n[selection-wiki]: https://en.wikipedia.org/wiki/Selection_sort\n[selection-image]: https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Selection_sort_animation.gif/250px-Selection_sort_animation.gif \"Selection Sort Sort\"\n\n[shell-toptal]: https://www.toptal.com/developers/sorting-algorithms/shell-sort\n[shell-wiki]: https://en.wikipedia.org/wiki/Shellsort\n[shell-image]: https://upload.wikimedia.org/wikipedia/commons/d/d8/Sorting_shellsort_anim.gif \"Shell Sort\"\n\n[linear-wiki]: https://en.wikipedia.org/wiki/Linear_search\n[linear-image]: http://www.tutorialspoint.com/data_structures_algorithms/images/linear_search.gif\n\n[binary-wiki]: https://en.wikipedia.org/wiki/Binary_search_algorithm\n[binary-image]: https://upload.wikimedia.org/wikipedia/commons/f/f7/Binary_search_into_array.png\n\n\n[caesar]: https://upload.wikimedia.org/wikipedia/commons/4/4a/Caesar_cipher_left_shift_of_3.svg\n        "
*/
