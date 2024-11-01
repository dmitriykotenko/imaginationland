// @ Dmitry Kotenko

import Foundation


class Cartoonist: UserActionsListener {

  struct Table {
    var cartoon: Cartoon = .init(shots: [.empty], shotsPerSecond: 5)
    var filling: Filling = .color(.basic)
    var isPlaying: Bool = false
    
    fileprivate var currentHatch: Hatch?
    fileprivate var undoedHatches: [Hatch] = []

    var currentShot: Shot? { cartoon.lastShot }
    var canUndo: Bool { currentShot?.hatches.isNotEmpty == true }
    var canRedo: Bool { undoedHatches.isNotEmpty }
    
    var canAppendShot: Bool{ true }
    var canDeleteLastShot: Bool { cartoon.shots.count > 1 }
    var canPlayCartoon: Bool { cartoon.shots.count > 1 && cartoon.hatches.isNotEmpty }
  }

  private(set) var table: Table = .init() {
    didSet {
      tableStreamContinuation.yield(table)
    }
  }

  var asyncTable: AsyncStream<Table> { tableStream }

  private let (tableStream, tableStreamContinuation) = AsyncStream.makeStream(of: Table.self)

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
    case .play:
      table.isPlaying = true
    case .stopPlaying:
      table.isPlaying = false
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
