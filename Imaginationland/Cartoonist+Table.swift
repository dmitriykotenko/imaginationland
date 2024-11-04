// @ Dmitry Kotenko

import Foundation


extension Cartoonist {

  struct Table {
    var cartoon: Cartoon = .init(shots: [.empty], shotsPerSecond: 10)

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
    var isHelpShown: Bool = !UserDefaults.standard.isHelpShown

    var canvasViewSize: CGSize = .zero

    var currentHatch: Hatch?
    var undoedHatches: [UUID: [Hatch]] = [:]

    var userActions: [UserAction] = []
    var undoedActions: [UserAction] = []

    init(cartoon: Cartoon = .init(shots: [.empty], shotsPerSecond: 10),
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

    var canUndo: Bool { !isPlaying && userActions.isNotEmpty }
    var canRedo: Bool { !isPlaying && undoedActions.isNotEmpty }

    var canAppendShot: Bool{ !isPlaying && cartoon.canHaveMoreShots }
    var canDuplicateShot: Bool{ !isPlaying && cartoon.canHaveMoreShots }
    var canGenerateRandomAnimation: Bool{ !isPlaying }

    var canDeleteCurrentShot: Bool { !isPlaying && cartoon.isNotEmpty }
    var canDeleteEverything: Bool { !isPlaying && cartoon.isNotEmpty }

    var canRewind: Bool { currentShotIndex != 0 }
    var canFastForward: Bool { currentShotIndex != cartoon.shots.count - 1 }

    var canPlayCartoon: Bool { cartoon.shots.count > 1 && cartoon.hatches.isNotEmpty }

    func isCompatible(with cache: ShotsCache?) -> Bool {
      cache?.canvasSize == canvasFrame.size && cache?.cgSize == canvasViewSize 
    }
  }
}
