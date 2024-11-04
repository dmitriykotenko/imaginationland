// @ Dmitry Kotenko

import Foundation


class Cartoonist: UserActionsListener {

  struct Table {
    var cartoon: Cartoon = .init(shots: [.empty], shotsPerSecond: 5)

    var currentShotId: UUID

    var currentShot: Shot {
      cartoon.shots.first { $0.id == currentShotId }!
    }

    var currentShotIndex: Int {
      cartoon.shots.firstIndex { $0.id == currentShotId }!
    }

    var filling: Filling = .color(.default)
    var choosedColor: Color = .default
    var isPlaying: Bool = false

    var randomAnimationGeneration: RandomAnimationGeneration = .hidden

    var canvasViewSize: CGSize = .zero

    fileprivate var currentHatch: Hatch?
    fileprivate var undoedHatches: [UUID: [Hatch]] = [:]

    init(cartoon: Cartoon = 
          .init(shots: [.empty], shotsPerSecond: 5),
//          .chatGptSample8,
//            .sample2,
         currentShot: Shot? = nil,
         filling: Filling = .color(.default),
         choosedColor: Color = .default,
         isPlaying: Bool = false,
         canvasViewSize: CGSize = .zero,
         currentHatch: Hatch? = nil,
         undoedHatches: [UUID: [Hatch]] = [:]) {
      self.cartoon = cartoon
      self.currentShotId = currentShot?.id ?? cartoon.lastShot!.id
      self.filling = filling
      self.choosedColor = choosedColor
      self.isPlaying = isPlaying
      self.canvasViewSize = canvasViewSize
      self.currentHatch = currentHatch
      self.undoedHatches = undoedHatches
    }

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

    var canUndo: Bool { !isPlaying && currentShot.hatches.isNotEmpty }
    var canRedo: Bool { !isPlaying && (undoedHatches[currentShot.id]?.isNotEmpty == true) }

    var canAppendShot: Bool{ !isPlaying && cartoon.canHaveMoreShots }
    var canDuplicateShot: Bool{ !isPlaying && cartoon.canHaveMoreShots }
    var canAppendRandomAnimation: Bool{ !isPlaying }

    var canDeleteCurrentShot: Bool { !isPlaying && cartoon.shots.count > 1 }
    var canDeleteEverything: Bool { !isPlaying && cartoon.isNotEmpty }

    var canPlayCartoon: Bool { cartoon.shots.count > 1 && cartoon.hatches.isNotEmpty }

    func isCompatible(with cache: ShotsCache?) -> Bool {
      cache?.canvasSize == canvasFrame.size && cache?.cgSize == canvasViewSize 
    }
  }

  private(set) var table: Table = .init() {
    didSet {
//      print("Cartoonist did update table.")
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
//    print("UserAction ---> \(userAction)")

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

      resetUndoHistory(shotId: destinationShot.id)
    case .addHatchSegments(let segments, let destinationShot):
      if table.currentHatch == nil {
        table.currentHatch = .init(
          brush: .main,
          filling: table.filling,
          segments: segments
        )

        let hatchToAppend = table.currentHatch!

        table.cartoon.shots.updateElements(
          { $0.appending(hatch: hatchToAppend) },
          where: { $0.id == destinationShot.id }
        )
      } else {
        table.currentHatch!.segments.append(contentsOf: segments)

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

      resetUndoHistory(shotId: destinationShot.id)
    case .commitHatch:
      table.currentHatch = nil
    case .appendShot:
//      table.cartoon.shots.append(.random)
      table.cartoon.shots.append(.empty)
      table.currentShotId = table.cartoon.shots.last!.id
    case .duplicateShot(let shotId):
      let shotIndex = table.cartoon.shots.firstIndex { $0.id == shotId }!
      let newShot = table.cartoon.shots[shotIndex].duplicated

      table.cartoon.shots.insert(newShot, at: shotIndex + 1)
      table.currentShotId = newShot.id
    case .showAnimationGeneratorView:
      table.randomAnimationGeneration = .isPickingShotsCount(userText: "100")
    case .hideAnimationGeneratorView:
      table.randomAnimationGeneration = .hidden
    case .appendRandomAnimation(let shotsCount):
      table.randomAnimationGeneration = .isGenerating(shotsCount: shotsCount)

      Task {
        var newTable = table
        newTable.cartoon.shots = AnimationGenerator(
          canvasSize: table.canvasFrame.size,
          shotsCount: shotsCount
        ).generate()
        newTable.currentShotId = newTable.cartoon.shots.last!.id
        newTable.randomAnimationGeneration = .hidden

        DispatchQueue.main.async {
          self.table = newTable
        }
      }
    case .deleteShot(let shotId):
      let shotIndex = table.cartoon.shots.firstIndex { $0.id == table.currentShot.id }!

      if table.currentShot.id == shotId {
        table.currentShotId =
        if shotIndex == 0 { table.cartoon.shots[0].id }
        else { table.cartoon.shots[shotIndex - 1].id }
      }

      table.cartoon.shots.removeSafely { $0.id == shotId }
    case .deleteEverything:
      var newTable = table
      newTable.cartoon.shots = [.empty]
      newTable.currentShotId = newTable.cartoon.shots[0].id
      table = newTable
    case .startEditingOfShot(let shotId):
      table.currentShotId = shotId
    case .undoHatch:
      let shotIndex = table.cartoon.shots.firstIndex { $0.id == table.currentShot.id }!

      table.undoedHatches[table.currentShot.id] = (table.cartoon.shots[shotIndex].hatches.removeLastSafely()).asArray
        + (table.undoedHatches[table.currentShot.id] ?? [])
    case .redoHatch:
      let shotIndex = table.cartoon.shots.firstIndex { $0.id == table.currentShot.id }!

      let hatchToRedo = table.undoedHatches[table.currentShot.id]?.removeFirstSafely()
      table.cartoon.shots[shotIndex].hatches += hatchToRedo.asArray
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

  private func resetUndoHistory(shotId: UUID) {
    table.undoedHatches[shotId] = nil
  }
}


infix operator !


extension Cartoonist {

  static func ! (this: Cartoonist, action: UserAction) {
    this.process(userAction: action)
  }
}
