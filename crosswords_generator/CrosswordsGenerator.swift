//
//  CrosswordsGenerator.swift
//  crosswords_generator
//
//  Created by Maxim Bilan on 9/11/15.
//  Copyright © 2015 Maxim Bilan. All rights reserved.
//

import Foundation

class CrosswordsGenerator {

	var columns: Int = 0
	var rows: Int = 0
	var grid: Array2D<String>?
	
	var maxLoops: Int = 0
	
	var availableWords: Array<String> = Array()
	var currentWordList: Array<String> = Array()
	
	init() {
	}
	
	init(columns: Int, rows: Int, maxLoops: Int = 2000, words: Array<String>) {
		self.columns = columns
		self.rows = rows
		self.maxLoops = maxLoops
		self.availableWords = words
		self.grid = Array2D(columns: columns, rows: rows, defaultValue: "-")
	}
	
	func generate() {
		
		//print(availableWords)
		
		availableWords.sortInPlace({$0.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > $1.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)})
		
		//print("---")
		//print(availableWords)
		
		for word in availableWords {
			if !currentWordList.contains(word) {
				fitAndAdd(word)
			}
		}
	}
	
	func suggestCoord(word: String) -> Array<Array<Int>> {
		
		var coordlist = Array<Array<Int>>()
		var glc = -1
		
		for letter in word.characters {
			glc += 1
			var rowc = 0
			for (var row: Int = 0; row < self.rows; ++row) {
				rowc += 1
				var colc = 0
				for (var column: Int = 0; column < self.columns; ++column) {
					colc += 1
					
					let cell = self.grid![row, column]
					if String(letter) == cell {
						if rowc - glc > 0 {
							if ((rowc - glc) + word.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) <= self.rows {
								coordlist.append([colc, rowc - glc, 1, colc + (rowc - glc), 0])
							}
						}
						
						if colc - glc > 0 {
							if ((colc - glc) + word.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) <= self.columns {
								coordlist.append([colc - glc, rowc, 0, rowc + (colc - glc), 0])
							}
						}
					}
				}
			}
			
		}
		
		let nCoordlist = sortCoordlist(coordlist, word: word)
		
		return nCoordlist
	}
	
	func sortCoordlist(coordlist: Array<Array<Int>>, word: String) -> Array<Array<Int>> {
		
		var nCoordlist = Array<Array<Int>>()
		
		for var coord in coordlist {
			let col = coord[0]
			let row = coord[1]
			let vertical = coord[2]
			coord[4] = checkFitScore(col, r: row, vertical: vertical, word: word)
			if coord[4] > 0 {
				nCoordlist.append(coord)
			}
		}
		
		nCoordlist.shuffleInPlace()
		nCoordlist.sortInPlace({$0[4] > $1[4]})
		
		return nCoordlist
	}
	
	func fitAndAdd(word: String) {
		var fit = false
		var count = 0
		var coordlist = suggestCoord(word)
		
		while !fit && count < maxLoops {
			
			if currentWordList.count == 0 {
				let vertical = 0
				let col = 1
				let row = 1
			}
			else {
			}
			
			count += 1
		}
	}
	
	func checkFitScore(c: Int, r: Int, vertical: Int, word: String) -> Int {
		
		if c < 1 || r < 1 || c >= self.columns || r >= self.rows {
			return 0
		}
		
		var col = c
		var row = r
		var count = 1
		var score = 1
		
		for letter in word.characters {
			let activeCell = getCell(col, row: row)
			if activeCell == "-" || activeCell == String(letter) {
				
				if activeCell == String(letter) {
					score += 1
				}
				
				if vertical == 0 {
					if activeCell != String(letter) {
						if !checkIfCellClear(col + 1, row: row) {
							return 0
						}
						
						if !checkIfCellClear(col - 1, row: row) {
							return 0
						}
					}
					
					if count == 1 {
						if checkIfCellClear(col, row: row - 1) {
							return 0
						}
					}
					
					if count == word.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
						if !checkIfCellClear(col, row: row + 1) {
							return 0
						}
					}
				}
				else {
					if activeCell != String(letter) {
						if !checkIfCellClear(col, row: row - 1) {
							return 0
						}
						
						if !checkIfCellClear(col, row: row + 1) {
							return 0
						}
					}
					
					if count == 1 {
						if checkIfCellClear(col - 1, row: row) {
							return 0
						}
					}
					
					if count == word.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
						if !checkIfCellClear(col + 1, row: row) {
							return 0
						}
					}
				}
				
				if vertical == 0 {
					row += 1
				}
				else {
					col += 1
				}

				count += 1
			}
			else {
				return 0
			}
		}
		
		return score
	}
	
	func setWord(col: Int, row: Int, vertical: Int, word: String, force: Bool = false) {
		
	}
	
	func setCell(col: Int, row: Int, value: String) {
		
	}
 
	func getCell(col: Int, row: Int) -> String{
		return grid![row-1, col-1]
	}
	
	func checkIfCellClear(col: Int, row: Int) -> Bool {
		let cell = getCell(col, row: row)
		return cell == "-" ? true : false
	}
	
}