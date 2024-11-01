// @ Dmitry Kotenko

import Foundation


class Cartoonist: UserActionsListener {

  struct Table {
    var cartoon: Cartoon = .init(shots: [.empty], shotsPerSecond: 5)
    var filling: Filling = .color(.default)
    var choosedColor: Color = .default
    var isPlaying: Bool = false

    var canvasViewSize: CGSize = .zero

    private let canvasWidth = 1000

    private var canvasHeight: Int {
      if canvasViewSize.width == 0 {
        1
      } else {
        Int(CGFloat(canvasWidth) * (canvasViewSize.height / canvasViewSize.width))
      }
    }

    var canvasFrame: Rect {
      .init(
        origin: .zero,
        size: .init(
          width: canvasWidth,
          height: canvasHeight
        )
      )
    }

    fileprivate var currentHatch: Hatch?
    fileprivate var undoedHatches: [Hatch] = []

    var currentShot: Shot? { cartoon.lastShot }
    var canUndo: Bool { !isPlaying && currentShot?.hatches.isNotEmpty == true }
    var canRedo: Bool { !isPlaying && undoedHatches.isNotEmpty }
    
    var canAppendShot: Bool{ !isPlaying }
    var canDeleteLastShot: Bool { !isPlaying && cartoon.shots.count > 1 }
    var canPlayCartoon: Bool { cartoon.shots.count > 1 && cartoon.hatches.isNotEmpty }
  }

  private(set) var table: Table = .init() {
    didSet {
      print("Cartoonist did update table.")
      notifyTableListeners()
    }
  }

  private func notifyTableListeners() {
    tableListeners.forEach { $0(table) }
  }

  func listenForTable(_ listener: @escaping (Table) -> Void) {
    tableListeners.append(listener)
    listener(table)
  }

  private var tableListeners: [(Table) -> Void] = []

  func process(userAction: UserAction) {
    print("UserAction ---> \(userAction)")

    switch userAction {
    case .addHatchSegment(let segment, let destinationShot):
      if table.currentHatch == nil {
        table.currentHatch = .init(
          brush: .main,
          filling: table.filling,
          segments: [segment]
        )

        let hatchToAppend = table.currentHatch!

        table.cartoon.shots.updateElements(
          { $0.appending(hatch: hatchToAppend) },
          where: { $0.id == destinationShot.id }
        )
      } else {
        table.currentHatch!.segments.append(segment)

        let hatchToUpdate = table.currentHatch!

        table.cartoon.shots.updateElements(
          {
            var result = $0
            result.hatches = $0.hatches.dropLast() + [hatchToUpdate]
            return result
          },
          where: { $0.id == destinationShot.id }
        )
      }

      resetUndoHistory()
    case .commitHatch:
      table.currentHatch = nil
    case .appendShot:
      table.cartoon.shots.append(.empty)
    case .deleteLastShot:
      table.cartoon.shots.removeLastSafely()
    case .undoHatch:
      table.undoedHatches = (table.cartoon.lastShot?.hatches.removeLastSafely()).asArray + table.undoedHatches
    case .redoHatch:
      let hatchToRedo = table.undoedHatches.removeFirstSafely()
      table.cartoon.lastShot?.hatches += hatchToRedo.asArray
    case .enableFilling(let filling):
      table.filling = filling
      table.filling = filling

      if case .color(let color) = filling {
        table.choosedColor = color
      }
    case .play:
      table.isPlaying = true
    case .stopPlaying:
      table.isPlaying = false
    case .changeCanvasViewSize(let newSize):
      table.canvasViewSize = newSize
    }
  }

  private func resetUndoHistory() {
    table.undoedHatches = []
  }
}


infix operator !


extension Cartoonist {

  static func ! (this: Cartoonist, action: UserAction) {
    this.process(userAction: action)
  }
}
