//
//  TabView.swift
//  X-SwiftFormat
//
//  Created by Rui Aureliano on 27/03/2020.
//  Copyright © 2020 Rui Aureliano. All rights reserved.
//

import Cocoa

class TabView: NSTabView {

  weak var appDelegate: AppDelegate?
  var configuration: [String: Any] = ["version": 1]

  @IBOutlet weak var lineLengthCheck: NSButton!
  @IBOutlet weak var lineLengthField: NSTextField!
  @IBOutlet weak var lineLengthStepper: NSStepper!

  @IBOutlet weak var indentationCheck: NSButton!
  @IBOutlet weak var indentationPopup: NSPopUpButton!
  @IBOutlet weak var indentationField: NSTextField!
  @IBOutlet weak var indentationStepper: NSStepper!

  @IBOutlet weak var tabWidthCheck: NSButton!
  @IBOutlet weak var tabWidthField: NSTextField!
  @IBOutlet weak var tabWidthStepper: NSStepper!

  @IBOutlet weak var maximumBlankLinesCheck: NSButton!
  @IBOutlet weak var maximumBlankLinesField: NSTextField!
  @IBOutlet weak var maximumBlankLinesStepper: NSStepper!

  @IBOutlet weak var respectsExistingLineBreaksCheck: NSButton!
  @IBOutlet weak var respectsExistingLineBreaksSwitch: NSSwitch!

  @IBOutlet weak var lineBreakBeforeControlFlowKeywordsCheck: NSButton!
  @IBOutlet weak var lineBreakBeforeControlFlowKeywordsSwitch: NSSwitch!

  @IBOutlet weak var lineBreakBeforeEachArgumentCheck: NSButton!
  @IBOutlet weak var lineBreakBeforeEachArgumentSwitch: NSSwitch!

  @IBOutlet weak var lineBreakBeforeEachGenericRequirementCheck: NSButton!
  @IBOutlet weak var lineBreakBeforeEachGenericRequirementSwitch: NSSwitch!

  @IBOutlet weak var prioritizeKeepingFunctionOutputTogetherCheck: NSButton!
  @IBOutlet weak var prioritizeKeepingFunctionOutputTogetherSwitch: NSSwitch!

  @IBOutlet weak var indentConditionalCompilationBlocksCheck: NSButton!
  @IBOutlet weak var indentConditionalCompilationBlocksSwitch: NSSwitch!

  @IBOutlet weak var lineBreakAroundMultilineExpressionChainComponentsCheck: NSButton!
  @IBOutlet weak var lineBreakAroundMultilineExpressionChainComponentsSwitch: NSSwitch!

  @IBOutlet weak var helpBt: NSButton!
  @IBOutlet weak var resetBt: NSButton!
  @IBOutlet weak var previewBt: NSButton!
  @IBOutlet weak var exportBt: NSButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    /* NOT SUPORTED FOR 5.1 */
    prioritizeKeepingFunctionOutputTogetherCheck.alphaValue = 0.3
    prioritizeKeepingFunctionOutputTogetherSwitch.alphaValue = 0.3
    lineBreakAroundMultilineExpressionChainComponentsCheck.alphaValue = 0.3
    lineBreakAroundMultilineExpressionChainComponentsSwitch.alphaValue = 0.3

    loadConfiguration()
  }

  func loadConfiguration() {
    if let configuration = UserDefaults.loadConfiguration() {
      self.configuration = configuration
    }
    validateConfiguration()
  }

  func validateConfiguration() {
    if let lineLength = configuration["lineLength"] as? Int {
      lineLengthCheck.state = .on
      lineLengthField.isEnabled = true
      lineLengthStepper.isEnabled = true

      lineLengthField.stringValue = "\(lineLength)"
      lineLengthStepper.integerValue = lineLength
    } else {
      lineLengthCheck.state = .off
      lineLengthField.isEnabled = false
      lineLengthStepper.isEnabled = false
    }

    if let indentation = configuration["indentation"] as? [String: Any] {
      if let spaces = indentation["spaces"] as? Int {
        indentationCheck.state = .on
        indentationPopup.isEnabled = true
        indentationField.isEnabled = true
        indentationStepper.isEnabled = true

        indentationPopup.selectItem(at: 0)
        indentationField.stringValue = "\(spaces)"
        indentationStepper.integerValue = spaces
      } else if let tabs = indentation["tabs"] as? Int {
        indentationCheck.state = .on
        indentationPopup.isEnabled = true
        indentationField.isEnabled = true
        indentationStepper.isEnabled = true

        indentationPopup.selectItem(at: 1)
        indentationField.stringValue = "\(tabs)"
        indentationStepper.integerValue = tabs
      } else {
        indentationCheck.state = .off
        indentationPopup.isEnabled = false
        indentationField.isEnabled = false
        indentationStepper.isEnabled = false
      }
    } else {
      indentationCheck.state = .off
      indentationPopup.isEnabled = false
      indentationField.isEnabled = false
      indentationStepper.isEnabled = false
    }

    if let tabWidth = configuration["tabWidth"] as? Int {
      tabWidthCheck.state = .on
      tabWidthField.isEnabled = true
      tabWidthStepper.isEnabled = true

      tabWidthField.stringValue = "\(tabWidth)"
      tabWidthStepper.integerValue = tabWidth
    } else {
      tabWidthCheck.state = .off
      tabWidthField.isEnabled = false
      tabWidthStepper.isEnabled = false
    }

    if let tabWidth = configuration["maximumBlankLines"] as? Int {
      maximumBlankLinesCheck.state = .on
      maximumBlankLinesField.isEnabled = true
      maximumBlankLinesStepper.isEnabled = true

      maximumBlankLinesField.stringValue = "\(tabWidth)"
      maximumBlankLinesStepper.integerValue = tabWidth
    } else {
      maximumBlankLinesCheck.state = .off
      maximumBlankLinesField.isEnabled = false
      maximumBlankLinesStepper.isEnabled = false
    }

    if let respectsExistingLineBreaks = configuration["respectsExistingLineBreaks"] as? Bool {
      respectsExistingLineBreaksCheck.state = .on
      respectsExistingLineBreaksSwitch.state = (respectsExistingLineBreaks ? .on : .off)
      respectsExistingLineBreaksSwitch.isEnabled = true
    } else {
      respectsExistingLineBreaksCheck.state = .off
      respectsExistingLineBreaksSwitch.isEnabled = false
    }

    if let lineBreakBeforeControlFlowKeywords = configuration["lineBreakBeforeControlFlowKeywords"]
      as? Bool
    {
      lineBreakBeforeControlFlowKeywordsCheck.state = .on
      lineBreakBeforeControlFlowKeywordsSwitch.state =
        (lineBreakBeforeControlFlowKeywords ? .on : .off)
      lineBreakBeforeControlFlowKeywordsSwitch.isEnabled = true
    } else {
      lineBreakBeforeControlFlowKeywordsCheck.state = .off
      lineBreakBeforeControlFlowKeywordsSwitch.isEnabled = false
    }

    if let lineBreakBeforeEachArgument = configuration["lineBreakBeforeEachArgument"] as? Bool {
      lineBreakBeforeEachArgumentCheck.state = .on
      lineBreakBeforeEachArgumentSwitch.state = (lineBreakBeforeEachArgument ? .on : .off)
      lineBreakBeforeEachArgumentSwitch.isEnabled = true
    } else {
      lineBreakBeforeEachArgumentCheck.state = .off
      lineBreakBeforeEachArgumentSwitch.isEnabled = false
    }

    if let lineBreakBeforeEachGenericRequirement =
      configuration["lineBreakBeforeEachGenericRequirement"] as? Bool
    {
      lineBreakBeforeEachGenericRequirementCheck.state = .on
      lineBreakBeforeEachGenericRequirementSwitch.state =
        (lineBreakBeforeEachGenericRequirement ? .on : .off)
      lineBreakBeforeEachGenericRequirementSwitch.isEnabled = true
    } else {
      lineBreakBeforeEachGenericRequirementCheck.state = .off
      lineBreakBeforeEachGenericRequirementSwitch.isEnabled = false
    }

    if let prioritizeKeepingFunctionOutputTogether =
      configuration["prioritizeKeepingFunctionOutputTogether"] as? Bool
    {
      prioritizeKeepingFunctionOutputTogetherCheck.state = .on
      prioritizeKeepingFunctionOutputTogetherSwitch.state =
        (prioritizeKeepingFunctionOutputTogether ? .on : .off)
      prioritizeKeepingFunctionOutputTogetherSwitch.isEnabled = true
    } else {
      prioritizeKeepingFunctionOutputTogetherCheck.state = .off
      prioritizeKeepingFunctionOutputTogetherSwitch.isEnabled = false
    }

    if let indentConditionalCompilationBlocks = configuration["indentConditionalCompilationBlocks"]
      as? Bool
    {
      indentConditionalCompilationBlocksCheck.state = .on
      indentConditionalCompilationBlocksSwitch.state =
        (indentConditionalCompilationBlocks ? .on : .off)
      indentConditionalCompilationBlocksSwitch.isEnabled = true
    } else {
      indentConditionalCompilationBlocksCheck.state = .off
      indentConditionalCompilationBlocksSwitch.isEnabled = false
    }

    if let lineBreakAroundMultilineExpressionChainComponents =
      configuration["lineBreakAroundMultilineExpressionChainComponents"] as? Bool
    {
      lineBreakAroundMultilineExpressionChainComponentsCheck.state = .on
      lineBreakAroundMultilineExpressionChainComponentsSwitch.state =
        (lineBreakAroundMultilineExpressionChainComponents ? .on : .off)
      lineBreakAroundMultilineExpressionChainComponentsSwitch.isEnabled = true
    } else {
      lineBreakAroundMultilineExpressionChainComponentsCheck.state = .off
      lineBreakAroundMultilineExpressionChainComponentsSwitch.isEnabled = false
    }
    validateExport()
  }

  func updateConfiguration() {
    if lineLengthCheck.state == .on {
      configuration["lineLength"] = lineLengthStepper.integerValue
    } else {
      configuration.removeValue(forKey: "lineLength")
    }

    if indentationCheck.state == .on {
      if indentationPopup.selectedTag() == 0 {
        configuration["indentation"] = ["spaces": indentationStepper.integerValue]
      } else {
        configuration["indentation"] = ["tabs": indentationStepper.integerValue]
      }
    } else {
      configuration.removeValue(forKey: "indentation")
    }

    if tabWidthCheck.state == .on {
      configuration["tabWidth"] = tabWidthStepper.integerValue
    } else {
      configuration.removeValue(forKey: "tabWidth")
    }

    if maximumBlankLinesCheck.state == .on {
      configuration["maximumBlankLines"] = maximumBlankLinesStepper.integerValue
    } else {
      configuration.removeValue(forKey: "maximumBlankLines")
    }

    if respectsExistingLineBreaksCheck.state == .on {
      configuration["respectsExistingLineBreaks"] =
        (respectsExistingLineBreaksSwitch.state == .on ? true : false)
    } else {
      configuration.removeValue(forKey: "respectsExistingLineBreaks")
    }

    if lineBreakBeforeControlFlowKeywordsCheck.state == .on {
      configuration["lineBreakBeforeControlFlowKeywords"] =
        (lineBreakBeforeControlFlowKeywordsSwitch.state == .on ? true : false)
    } else {
      configuration.removeValue(forKey: "lineBreakBeforeControlFlowKeywords")
    }

    if lineBreakBeforeEachArgumentCheck.state == .on {
      configuration["lineBreakBeforeEachArgument"] =
        (lineBreakBeforeEachArgumentSwitch.state == .on ? true : false)
    } else {
      configuration.removeValue(forKey: "lineBreakBeforeEachArgument")
    }

    if lineBreakBeforeEachGenericRequirementCheck.state == .on {
      configuration["lineBreakBeforeEachGenericRequirement"] =
        (lineBreakBeforeEachGenericRequirementSwitch.state == .on ? true : false)
    } else {
      configuration.removeValue(forKey: "lineBreakBeforeEachGenericRequirement")
    }

    if prioritizeKeepingFunctionOutputTogetherCheck.state == .on {
      configuration["prioritizeKeepingFunctionOutputTogether"] =
        (prioritizeKeepingFunctionOutputTogetherSwitch.state == .on ? true : false)
    } else {
      configuration.removeValue(forKey: "prioritizeKeepingFunctionOutputTogether")
    }

    if indentConditionalCompilationBlocksCheck.state == .on {
      configuration["indentConditionalCompilationBlocks"] =
        (indentConditionalCompilationBlocksSwitch.state == .on ? true : false)
    } else {
      configuration.removeValue(forKey: "indentConditionalCompilationBlocks")
    }

    if lineBreakAroundMultilineExpressionChainComponentsCheck.state == .on {
      configuration["lineBreakAroundMultilineExpressionChainComponents"] =
        (lineBreakAroundMultilineExpressionChainComponentsSwitch.state == .on ? true : false)
    } else {
      configuration.removeValue(forKey: "lineBreakAroundMultilineExpressionChainComponents")
    }
    validateExport()
    saveUserDefaults()
  }

  func validateExport() {
    exportBt.isEnabled =
      (lineLengthCheck.state == .on || indentationCheck.state == .on || tabWidthCheck.state == .on
        || maximumBlankLinesCheck.state == .on || respectsExistingLineBreaksCheck.state == .on
        || lineBreakBeforeControlFlowKeywordsCheck.state == .on
        || lineBreakBeforeEachArgumentCheck.state == .on
        || lineBreakBeforeEachGenericRequirementCheck.state == .on
        || prioritizeKeepingFunctionOutputTogetherCheck.state == .on
        || indentConditionalCompilationBlocksCheck.state == .on
        || lineBreakAroundMultilineExpressionChainComponentsCheck.state == .on)
  }
  func saveUserDefaults() {
    _ = UserDefaults.saveConfiguration(configuration: configuration)

  }
}
