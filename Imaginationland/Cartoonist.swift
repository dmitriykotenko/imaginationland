// @ Dmitry Kotenko

import Foundation


class Cartoonist {

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

  func process(userAction: UserAction,
               isRedoing: Bool = false) {
//    print("UserAction ---> \(userAction)")
//    print("Comitted actions.count ---> \(table.userActions.count)")
//    print("Undoed actions.count ---> \(table.undoedActions.count)")

    var newTable = table

    if userAction.canBeUndoed {
      newTable.userActions.append(userAction)
      // Очищаем историю Undo при каждом новом существенном действии.
      if !isRedoing { newTable.undoedActions = [] }
    }

    switch userAction {
    case .addHatch(let segments, let destinationShot):
      newTable.currentHatch = .init(
        brush: .main,
        filling: newTable.filling,
        segments: segments
      )

      let hatchToAppend = newTable.currentHatch!

      newTable.cartoon.shots.updateElements(
        { $0.appending(hatch: hatchToAppend) },
        where: { $0.id == destinationShot.id }
      )

    case .addHatchSegments(let segments, let destinationShot):
      let (oldSegments, oldShot) = newTable.userActions.last!.asHatchAdding!
      newTable.userActions.removeLastSafely()
      newTable.userActions += [
        .addHatch(
          withSegments: oldSegments + segments,
          toShot: oldShot
        )
      ]

      newTable.currentHatch!.segments.append(contentsOf: segments)

      let hatchIndex = newTable.cartoon.shots[newTable.currentShotIndex].hatches.count - 1

      newTable.cartoon
        .shots[newTable.currentShotIndex]
        .hatches[hatchIndex]
        .segments
        .append(contentsOf: segments)
    case .insertShot(let shot, let desiredIndex):
      newTable.cartoon.shots.insert(shot, at: desiredIndex)
      newTable.currentShotId = shot.id
    case .showAnimationGeneratorView:
      newTable.randomAnimationGeneration = .isPickingShotsCount(userText: "50")
    case .hideAnimationGeneratorView:
      newTable.randomAnimationGeneration = .hidden
    case .generateRandomAnimation(let shotsCount):
      newTable.randomAnimationGeneration = .isGenerating(shotsCount: shotsCount)

      Task { [newTable] in
        var newerTable = newTable
        newerTable.cartoon.shots = AnimationGenerator(
          canvasSize: table.canvasFrame.size,
          shotsCount: shotsCount
        ).generate()
        newerTable.currentShotId = newerTable.cartoon.shots.last!.id
        newerTable.randomAnimationGeneration = .hidden

        DispatchQueue.main.async {
          self ! .replace(
            oldCartoon: newTable.cartoon,
            oldCurrentShotId: newTable.currentShotId,
            byNewCartoon: newerTable.cartoon
          )
        }
      }
    case .replace(let oldCartoon, let oldCurrentShotId, let newCartoon):
      newTable.cartoon = newCartoon
      newTable.currentShotId = newTable.cartoon.shots.last!.id
      newTable.randomAnimationGeneration = .hidden
    case .deleteShot(let shot, let shotIndex):
      newTable.cartoon.shots.remove(at: shotIndex)

      if newTable.currentShotId == shot.id {
        newTable.currentShotId =
        if shotIndex == 0 { newTable.cartoon.shots[0].id }
        else { newTable.cartoon.shots[shotIndex - 1].id }
      }
    case .clearTheOnlyShot(let shot):
      let newShot = Shot.empty
      newTable.cartoon.shots = [newShot]
      newTable.currentShotId = newShot.id
    case .deleteShots(let shots, let currentShotId):
      let shotIds = Set(shots.map(\.id))

      newTable.cartoon.shots = newTable.cartoon.shots.filter { !shotIds.contains($0.id) }
      if newTable.cartoon.shots.isEmpty { newTable.cartoon.shots = [.empty] }
      newTable.currentShotId = newTable.cartoon.shots[0].id
    case .go(let oldShotId, let newShotId):
      newTable.currentShotId = newShotId
    case .undoHatch:
      let shotIndex = newTable.cartoon.shots.firstIndex { $0.id == newTable.currentShot.id }!

      newTable.undoedHatches[newTable.currentShot.id] = (newTable.cartoon.shots[shotIndex].hatches.removeLastSafely()).asArray
        + (newTable.undoedHatches[table.currentShot.id] ?? [])
    case .redoHatch:
      let shotIndex = newTable.cartoon.shots.firstIndex { $0.id == newTable.currentShot.id }!

      let hatchToRedo = newTable.undoedHatches[newTable.currentShot.id]?.removeFirstSafely()
      newTable.cartoon.shots[shotIndex].hatches += hatchToRedo.asArray
    case .updateFilling(let oldFilling, let newFilling):
      newTable.filling = newFilling

      if case .color(let color) = newFilling {
        newTable.choosedColor = color
      }
    case .play:
      newTable.isPlaying = true
    case .stopPlaying:
      newTable.isPlaying = false
    case .changeCanvasViewSize(let newSize):
      newTable.canvasViewSize = newSize
    case .showHelp:
      newTable.isHelpShown = true
    case .hideHelp:
      UserDefaults.standard.isHelpShown = true
      newTable.isHelpShown = false
    case .undo:
      guard let actionToUndo = newTable.userActions.last else { return }
      undo(userAction: actionToUndo)
      return
    case .redo:
      guard let actionToRedo = table.undoedActions.first else { return }

      table.undoedActions = table.undoedActions.dropFirst().asArray
      process(userAction: actionToRedo, isRedoing: true)
      return
    }

    table = newTable
  }

  private func undo(userAction: UserAction) {
    var newTable = table
    newTable.userActions = newTable.userActions.dropLast()
    newTable.undoedActions = [userAction] + newTable.undoedActions

    switch userAction {
    case .addHatch(let segments, let shot):
      newTable.cartoon.shots.updateElements({ _ in shot }, where: { $0.id == shot.id })
    case .addHatchSegments(let segments, let shot):
      break
    case .insertShot(let shot, let desiredIndex):
      guard table.cartoon.shots.count > 1 else { break }

      newTable.cartoon.shots.remove(at: desiredIndex)
      newTable.currentShotId = newTable.cartoon.shots[desiredIndex - 1].id
    case .replace(let oldCartoon, let oldCurrentShotId, let byNewCartoon):
      newTable.cartoon = oldCartoon
      newTable.currentShotId = oldCurrentShotId
    case .deleteShot(let shot, let shotIndex):
      newTable.cartoon.shots.insert(shot, at: shotIndex)
      newTable.currentShotId = shot.id
    case .clearTheOnlyShot(let shot):
      newTable.cartoon.shots = [shot]
      newTable.currentShotId = shot.id
    case .deleteShots(let shots, let currentShotId):
      newTable.cartoon.shots = shots
      newTable.currentShotId = currentShotId
    case .go(let oldShotId, let newShotId):
      newTable.currentShotId = oldShotId
    case .updateFilling(let oldFilling, let newFilling):
      newTable.filling = oldFilling
    case .undo, .redo, .undoHatch, .redoHatch, .play, .stopPlaying, .changeCanvasViewSize:
      break
    case .showAnimationGeneratorView, .hideAnimationGeneratorView, .generateRandomAnimation:
      break
    case .showHelp, .hideHelp:
      break
    }

    table = newTable
  }
}


infix operator !


extension Cartoonist {

  static func ! (this: Cartoonist, action: UserAction) {
    this.process(userAction: action)
  }
}
