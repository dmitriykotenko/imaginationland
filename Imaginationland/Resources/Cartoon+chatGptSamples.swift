// @ Dmitry Kotenko

import Foundation


extension Cartoon {

  static let chatGptSample1 = Cartoon(
    shots: [
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 10, y: 10)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 20, y: 20)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 30, y: 30)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 40, y: 40)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 50, y: 50)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 60, y: 60)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 70, y: 70)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 80, y: 80)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 90, y: 90)
            ))
          ]
        )
      ]),
      Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)),
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: 100, y: 100)
            ))
          ]
        )
      ])
    ],
    shotsPerSecond: 5
  )

  static let chatGptSample2 = Cartoon(
    shots: (0..<20).map { index in
      let endX = index * 50
      let endY = index * 100
      return Shot(hatches: [
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)), // Red color
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: endX, y: endY)
            ))
          ]
        )
      ])
    },
    shotsPerSecond: 10
  )

  static let chatGptSample3 = Cartoon(
    shots: (0..<20).map { index in
      // Object 1: Diagonal line from top-left to bottom-right
      let endX1 = index * 50
      let endY1 = index * 100

      // Object 2: Horizontal line across the top
      let startX2 = index * 50
      let endX2 = startX2 + 200

      // Object 3: Spline following a curve from bottom-left to top-right
      let startX3 = index * 30
      let endX3 = 1000 - index * 30
      let controlOffset = index * 10

      return Shot(hatches: [
        // Hatch for Object 1
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 0, blue: 0, alpha: 1.0)), // Red color
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 0),
              end: Point(x: endX1, y: endY1)
            ))
          ]
        ),

        // Hatch for Object 2
        Hatch(
          brush: .main,
          filling: .color(Color(red: 0, green: 255, blue: 0, alpha: 1.0)), // Green color
          segments: [
            .line(Hatch.Line(
              start: Point(x: startX2, y: 50),
              end: Point(x: endX2, y: 50)
            ))
          ]
        ),

        // Hatch for Object 3
        Hatch(
          brush: .main,
          filling: .color(Color(red: 0, green: 0, blue: 255, alpha: 1.0)), // Blue color
          segments: [
            .spline(Hatch.Spline(
              start: Point(x: startX3, y: 2000),
              end: Point(x: endX3, y: 0),
              startControlPoint: Point(x: startX3 + controlOffset, y: 1500),
              endControlPoint: Point(x: endX3 - controlOffset, y: 500)
            ))
          ]
        )
      ])
    },
    shotsPerSecond: 10
  )

  static let chatGptSample4 = Cartoon(
    shots: (0..<20).map { index in
      // Sun Disk: Rising from below the sea (y = 1800) to above the sea (y = 1500)
      let sunY = 1800 - index * 15

      // Sun Rays: Rays expand outward from the sun's center
      let rayLength = 100 + index * 10

      // Cloud Positions: Clouds moving slightly to the right each frame
      let cloudOffset1 = index * 15
      let cloudOffset2 = index * 10

      return Shot(hatches: [
        // Hatch for Sea Surface
        Hatch(
          brush: .main,
          filling: .color(Color(red: 0, green: 0, blue: 255, alpha: 1.0)), // Blue sea
          segments: [
            .line(Hatch.Line(
              start: Point(x: 0, y: 1600),
              end: Point(x: 1000, y: 1600)
            ))
          ]
        ),

        // Hatch for Sun Disk
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 204, blue: 0, alpha: 1.0)), // Yellow sun
          segments: [
            .line(Hatch.Line(
              start: Point(x: 500 - 50, y: sunY),
              end: Point(x: 500 + 50, y: sunY)
            ))
          ]
        ),

        // Hatch for Sun Rays (multiple rays emanating from the sun's center)
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 204, blue: 0, alpha: 0.5)), // Lighter yellow rays
          segments: [
            .line(Hatch.Line(
              start: Point(x: 500, y: sunY),
              end: Point(x: 500, y: sunY - rayLength)
            )),
            .line(Hatch.Line(
              start: Point(x: 500, y: sunY),
              end: Point(x: 500 + rayLength, y: sunY)
            )),
            .line(Hatch.Line(
              start: Point(x: 500, y: sunY),
              end: Point(x: 500 - rayLength, y: sunY)
            )),
            .line(Hatch.Line(
              start: Point(x: 500, y: sunY),
              end: Point(x: 500, y: sunY + rayLength)
            ))
          ]
        ),

        // Hatch for Cloud 1
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 255, blue: 255, alpha: 0.8)), // White cloud
          segments: [
            .line(Hatch.Line(
              start: Point(x: 200 + cloudOffset1, y: 1400),
              end: Point(x: 400 + cloudOffset1, y: 1400)
            ))
          ]
        ),

        // Hatch for Cloud 2
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 255, blue: 255, alpha: 0.8)), // Another white cloud
          segments: [
            .line(Hatch.Line(
              start: Point(x: 600 + cloudOffset2, y: 1300),
              end: Point(x: 800 + cloudOffset2, y: 1300)
            ))
          ]
        )
      ])
    },
    shotsPerSecond: 5
  )

  static let chatGptSample5 = Cartoon(
    shots: (0..<20).map { index in
      // Sun Disk: Rising from below the sea (y = 1800) to above the sea (y = 1500) and shifted right (x = 600)
      let sunCenterX = 600
      let sunY = 1800 - index * 15

      // Calculate points for the 12-sided polygon representing the sun disk
      let sunRadius = 50
      let sunDiskSegments: [Hatch.Segment] = (0..<12).map { i in
        let angle1 = Double(i) * (2 * .pi / 12)
        let angle2 = Double(i + 1) * (2 * .pi / 12)
        let startX = sunCenterX + Int(Double(sunRadius) * cos(angle1))
        let startY = sunY + Int(Double(sunRadius) * sin(angle1))
        let endX = sunCenterX + Int(Double(sunRadius) * cos(angle2))
        let endY = sunY + Int(Double(sunRadius) * sin(angle2))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: startX, y: startY),
          end: Point(x: endX, y: endY)
        ))
      }

      // Sun Rays: 7 rays distributed around the sun
      let rayLength = 100 + index * 10
      let sunRaySegments: [Hatch.Segment] = (0..<7).map { i in
        let angle = Double(i) * (2 * .pi / 7)
        let endX = sunCenterX + Int(Double(rayLength) * cos(angle))
        let endY = sunY + Int(Double(rayLength) * sin(angle))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: sunCenterX, y: sunY),
          end: Point(x: endX, y: endY)
        ))
      }

      // Cloud Positions
      let cloudOffset1 = index * 15
      let cloudOffset2 = index * 10

      // Sea Waves: A simple zig-zag wave pattern across the screen
      let waveSegments: [Hatch.Segment] = (0..<10).flatMap { i in
        let startX = i * 100
        let endX = startX + 50
        let yOffset = (i % 2 == 0 ? 0 : 10) // Alternating heights for wave peaks and troughs
        return [
          Hatch.Segment.line(Hatch.Line(
            start: Point(x: startX, y: 1600 + yOffset),
            end: Point(x: endX, y: 1600 - yOffset)
          )),
          Hatch.Segment.line(Hatch.Line(
            start: Point(x: endX, y: 1600 - yOffset),
            end: Point(x: endX + 50, y: 1600 + yOffset)
          ))
        ]
      }

      return Shot(hatches: [
        // Hatch for Sea Surface with Waviness
        Hatch(
          brush: .main,
          filling: .color(Color(red: 0, green: 0, blue: 255, alpha: 1.0)), // Blue sea
          segments: waveSegments
        ),

        // Hatch for Sun Disk (12-sided polygon)
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 204, blue: 0, alpha: 1.0)), // Yellow sun
          segments: sunDiskSegments
        ),

        // Hatch for Sun Rays (7 uniformly distributed rays)
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 204, blue: 0, alpha: 0.5)), // Lighter yellow rays
          segments: sunRaySegments
        ),

        // Hatch for Cloud 1
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 255, blue: 255, alpha: 0.8)), // White cloud
          segments: [
            .line(Hatch.Line(
              start: Point(x: 200 + cloudOffset1, y: 1400),
              end: Point(x: 400 + cloudOffset1, y: 1400)
            ))
          ]
        ),

        // Hatch for Cloud 2
        Hatch(
          brush: .main,
          filling: .color(Color(red: 255, green: 255, blue: 255, alpha: 0.8)), // Another white cloud
          segments: [
            .line(Hatch.Line(
              start: Point(x: 600 + cloudOffset2, y: 1300),
              end: Point(x: 800 + cloudOffset2, y: 1300)
            ))
          ]
        )
      ])
    },
    shotsPerSecond: 5
  )

  static let screenWidth = 1000
  static let screenHeight = 2000

  static let chatGptSample6 = Cartoon(
    shots: (0..<20).map { index in
      // Sun Disk: Rising more quickly (y = 1800 to y = 1200) and shifted right (x = 600)
      let sunCenterX = 600
      let sunY = 1800 - index * 30

      // Sun Disk as a 12-sided polygon
      let sunRadius = 50
      let sunDiskSegments: [Hatch.Segment] = (0..<12).map { i in
        let angle1 = Double(i) * (2 * .pi / 12)
        let angle2 = Double(i + 1) * (2 * .pi / 12)
        let startX = sunCenterX + Int(Double(sunRadius) * cos(angle1))
        let startY = sunY + Int(Double(sunRadius) * sin(angle1))
        let endX = sunCenterX + Int(Double(sunRadius) * cos(angle2))
        let endY = sunY + Int(Double(sunRadius) * sin(angle2))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: startX, y: startY),
          end: Point(x: endX, y: endY)
        ))
      }

      // Sun Rays: Extending each ray to the edges of the screen
      let sunRaySegments: [Hatch.Segment] = (0..<7).map { i in
        let angle = Double(i) * (2 * .pi / 7)
        let rayEndX = sunCenterX + Int(Double(max(screenWidth, screenHeight)) * cos(angle))
        let rayEndY = sunY + Int(Double(max(screenWidth, screenHeight)) * sin(angle))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: sunCenterX, y: sunY),
          end: Point(x: rayEndX, y: rayEndY)
        ))
      }

      // Sea Waves: 5 horizontal wavy lines
      let waveSegments: [Hatch.Segment] = (0..<5).flatMap { j in
        (0..<10).flatMap { i in
          let startX = i * 100
          let endX = startX + 50
          let baseY = 1650 + j * 30
          let yOffset = (i % 2 == 0 ? 10 : -10) // Alternating heights for wave peaks and troughs
          return [
            Hatch.Segment.line(Hatch.Line(
              start: Point(x: startX, y: baseY + yOffset),
              end: Point(x: endX, y: baseY - yOffset)
            )),
            Hatch.Segment.line(Hatch.Line(
              start: Point(x: endX, y: baseY - yOffset),
              end: Point(x: endX + 50, y: baseY + yOffset)
            ))
          ]
        }
      }

      // Cloud Positions: Clouds moving slightly to the right
      let cloudOffset1 = index * 15
      let cloudOffset2 = index * 10

      return Shot(hatches: [
        // Hatch for Sea Surface with multiple wavy lines
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 0, green: 0, blue: 255, alpha: 1.0)), // Blue sea
          segments: waveSegments
        ),

        // Hatch for Sun Disk (12-sided polygon)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 204, blue: 0, alpha: 1.0)), // Yellow sun
          segments: sunDiskSegments
        ),

        // Hatch for Sun Rays (extended to screen bounds)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 204, blue: 0, alpha: 0.5)), // Lighter yellow rays
          segments: sunRaySegments
        ),

        // Hatch for Cloud 1
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 255, blue: 255, alpha: 0.8)), // White cloud
          segments: [
            Hatch.Segment.line(Hatch.Line(
              start: Point(x: 200 + cloudOffset1, y: 1400),
              end: Point(x: 400 + cloudOffset1, y: 1400)
            ))
          ]
        ),

        // Hatch for Cloud 2
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 255, blue: 255, alpha: 0.8)), // Another white cloud
          segments: [
            Hatch.Segment.line(Hatch.Line(
              start: Point(x: 600 + cloudOffset2, y: 1300),
              end: Point(x: 800 + cloudOffset2, y: 1300)
            ))
          ]
        )
      ])
    },
    shotsPerSecond: 5
  )

  static let chatGptSample7 = Cartoon(
    shots: (0..<60).map { index in
      // Sun Disk: Rising from y = 1800 to y = 1200, shifted right (x = 600)
      let sunCenterX = 600
      let sunY = 1800 - index * 30

      // Outer Sun Disk as a 12-sided polygon
      let sunOuterRadius = 50
      let sunOuterDiskSegments: [Hatch.Segment] = (0..<12).map { i in
        let angle1 = Double(i) * (2 * .pi / 12)
        let angle2 = Double(i + 1) * (2 * .pi / 12)
        let startX = sunCenterX + Int(Double(sunOuterRadius) * cos(angle1))
        let startY = sunY + Int(Double(sunOuterRadius) * sin(angle1))
        let endX = sunCenterX + Int(Double(sunOuterRadius) * cos(angle2))
        let endY = sunY + Int(Double(sunOuterRadius) * sin(angle2))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: startX, y: startY),
          end: Point(x: endX, y: endY)
        ))
      }

      // Inner Sun Disk as a 12-sided polygon for opacity effect
      let sunInnerRadius = 40
      let sunInnerDiskSegments: [Hatch.Segment] = (0..<12).map { i in
        let angle1 = Double(i) * (2 * .pi / 12)
        let angle2 = Double(i + 1) * (2 * .pi / 12)
        let startX = sunCenterX + Int(Double(sunInnerRadius) * cos(angle1))
        let startY = sunY + Int(Double(sunInnerRadius) * sin(angle1))
        let endX = sunCenterX + Int(Double(sunInnerRadius) * cos(angle2))
        let endY = sunY + Int(Double(sunInnerRadius) * sin(angle2))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: startX, y: startY),
          end: Point(x: endX, y: endY)
        ))
      }

      // Rotating Sun Rays: Slightly rotating clockwise each frame
      let rotationAngle = Double(index) * (2 * .pi / 60)
      let sunRaySegments: [Hatch.Segment] = (0..<7).map { i in
        let angle = Double(i) * (2 * .pi / 7) + rotationAngle
        let rayEndX = sunCenterX + Int(Double(max(screenWidth, screenHeight)) * cos(angle))
        let rayEndY = sunY + Int(Double(max(screenWidth, screenHeight)) * sin(angle))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: sunCenterX, y: sunY),
          end: Point(x: rayEndX, y: rayEndY)
        ))
      }

      // Sea Waves: Filling up to the bottom of the screen with wavy lines
      let waveSegments: [Hatch.Segment] = (0..<30).flatMap { j in
        (0..<10).flatMap { i in
          let startX = i * 100
          let endX = startX + 50
          let baseY = 1650 + j * 30
          let yOffset = (i % 2 == 0 ? 10 : -10) // Alternating heights for wave peaks and troughs
          return [
            Hatch.Segment.line(Hatch.Line(
              start: Point(x: startX, y: baseY + yOffset),
              end: Point(x: endX, y: baseY - yOffset)
            )),
            Hatch.Segment.line(Hatch.Line(
              start: Point(x: endX, y: baseY - yOffset),
              end: Point(x: endX + 50, y: baseY + yOffset)
            ))
          ]
        }
      }

      // Natural Clouds: Two clouds, each with 2-3 horizontal lines stacked
      let cloudOffset1 = index * 15
      let cloudOffset2 = index * 10

      let cloudSegments1: [Hatch.Segment] = (0..<3).map { j in
        let baseY = 1400 + j * 10
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: 200 + cloudOffset1, y: baseY),
          end: Point(x: 400 + cloudOffset1, y: baseY)
        ))
      }

      let cloudSegments2: [Hatch.Segment] = (0..<3).map { j in
        let baseY = 1300 + j * 10
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: 600 + cloudOffset2, y: baseY),
          end: Point(x: 800 + cloudOffset2, y: baseY)
        ))
      }

      return Shot(hatches: [
        // Hatch for Sea Surface
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 0, green: 0, blue: 255, alpha: 1.0)), // Blue sea
          segments: waveSegments
        ),

        // Hatch for Sun Outer Disk (12-sided polygon)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 204, blue: 0, alpha: 1.0)), // Yellow sun
          segments: sunOuterDiskSegments
        ),

        // Hatch for Sun Inner Disk (12-sided polygon for opacity)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 204, blue: 0, alpha: 1.0)), // Inner yellow sun
          segments: sunInnerDiskSegments
        ),

        // Hatch for Sun Rays (slightly rotating clockwise)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 204, blue: 0, alpha: 0.5)), // Lighter yellow rays
          segments: sunRaySegments
        ),

        // Hatch for Cloud 1 (stacked lines)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 255, blue: 255, alpha: 0.8)), // White cloud
          segments: cloudSegments1
        ),

        // Hatch for Cloud 2 (stacked lines)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(Color(red: 255, green: 255, blue: 255, alpha: 0.8)), // Another white cloud
          segments: cloudSegments2
        )
      ])
    },
    shotsPerSecond: 5
  )

  static let chatGptSample8 = Cartoon(
    shots: (0..<300).map { index in
      // Sun Disk: Rising from y = 1800 to y = 1200, shifted right (x = 600)
      let sunCenterX = 600
      let sunY = 1500 - index * 6
      let horizonY = 1300  // Horizon line

      // Outer Sun Disk as a 12-sided polygon
      let sunOuterRadius = 50
      let sunOuterDiskSegments: [Hatch.Segment] = (0..<12).map { i in
        let angle1 = Double(i) * (2 * .pi / 12)
        let angle2 = Double(i + 1) * (2 * .pi / 12)
        let startX = sunCenterX + Int(Double(sunOuterRadius) * cos(angle1))
        let startY = sunY + Int(Double(sunOuterRadius) * sin(angle1))
        let endX = sunCenterX + Int(Double(sunOuterRadius) * cos(angle2))
        let endY = sunY + Int(Double(sunOuterRadius) * sin(angle2))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: startX, y: startY),
          end: Point(x: endX, y: endY)
        ))
      }

      // Inner Sun Disk as a 12-sided polygon for opacity effect
      let sunInnerRadius = 20
      let sunInnerDiskSegments: [Hatch.Segment] = (0..<12).map { i in
        let angle1 = Double(i) * (2 * .pi / 12)
        let angle2 = Double(i + 1) * (2 * .pi / 12)
        let startX = sunCenterX + Int(Double(sunInnerRadius) * cos(angle1))
        let startY = sunY + Int(Double(sunInnerRadius) * sin(angle1))
        let endX = sunCenterX + Int(Double(sunInnerRadius) * cos(angle2))
        let endY = sunY + Int(Double(sunInnerRadius) * sin(angle2))
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: startX, y: startY),
          end: Point(x: endX, y: endY)
        ))
      }

      // Rotating Sun Rays: Slightly rotating clockwise each frame
      let rotationAngle = Double(index) * (2 * .pi / 300)
      let sunRaysCount = 11
      let sunRaySegments: [Hatch.Segment] = (0..<sunRaysCount).compactMap { i in
        let angle = Double(i) * (2 * .pi / Double(sunRaysCount)) + rotationAngle
        let rayDirectionY = sin(angle)

        // Only display rays pointing upward or sideways when sun is below horizon
        if sunY < horizonY || rayDirectionY <= 0 {
          let rayEndX = sunCenterX + Int(Double(max(screenWidth, screenHeight)) * cos(angle))
          let rayEndY = sunY + Int(Double(max(screenWidth, screenHeight)) * rayDirectionY)
          return Hatch.Segment.line(Hatch.Line(
            start: Point(x: sunCenterX, y: sunY),
            end: Point(x: rayEndX, y: rayEndY)
          ))
        }
        return nil
      }

      let seaY = 1350

      // Sea Waves: Filling up to the bottom of the screen with wavy lines
      let waveSegments: [Hatch.Segment] = (0..<30).flatMap { j in
        (0..<10).flatMap { i in
          let startX = i * 100
          let endX = startX + 50
          let baseY = seaY + j * 30
          let yOffset = (i % 2 == 0 ? 10 : -10) // Alternating heights for wave peaks and troughs
          return [
            Hatch.Segment.line(Hatch.Line(
              start: Point(x: startX, y: baseY + yOffset),
              end: Point(x: endX, y: baseY - yOffset)
            )),
            Hatch.Segment.line(Hatch.Line(
              start: Point(x: endX, y: baseY - yOffset),
              end: Point(x: endX + 50, y: baseY + yOffset)
            ))
          ]
        }
      }

      // Natural Clouds: Two clouds, each with 2-3 horizontal lines stacked
      let cloudOffset1 = index * 15
      let cloudOffset2 = index * 10

      let cloudSegments1: [Hatch.Segment] = (0..<5).map { j in
        let baseY = 1100 + j * 20
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: 0 + Int.random(in: 0...25) + cloudOffset1, y: baseY),
          end: Point(x: 200 + Int.random(in: 0...25) + cloudOffset1, y: baseY)
        ))
      }

      let cloudSegments2: [Hatch.Segment] = (0..<3).map { j in
        let baseY = 1000 + j * 10
        return Hatch.Segment.line(Hatch.Line(
          start: Point(x: 300 + Int.random(in: 0...40) + cloudOffset2, y: baseY),
          end: Point(x: 600 + Int.random(in: 0...40) + cloudOffset2, y: baseY)
        ))
      }

      let relativeDuration = Double(index) / 60.0
      let isSunFullyVisible = sunY + sunOuterRadius <= seaY

      let sunDiskColor1 = Color(red: 255, green: 100, blue: 0, alpha: 1.0)
      let sunDiskColor2 = Color(red: 255, green: 204, blue: 0, alpha: 1.0)
      let sunDiskColor = sunDiskColor2.mixed(with: sunDiskColor1, selfPortion: relativeDuration)

      let sunRayColor1 = Color(red: 255, green: 100, blue: 0, alpha: 0.5)
      let sunRayColor2 = Color(red: 255, green: 204, blue: 0, alpha: 0.5)
      let sunRayColor = sunRayColor2.mixed(with: sunRayColor1, selfPortion: relativeDuration)

      let seaColor1 = Color(red: 42, green: 50, blue: 66, alpha: 1.0)
      let seaColor2 = Color(red: 0, green: 215, blue: 230, alpha: 1.0)
      let seaColor = isSunFullyVisible ? seaColor2 : seaColor1

      let cloudColor = Color(red: 255, green: 255, blue: 255, alpha: 0.8)

      let sunHatches = [
        // Outer Sun Disk (12-sided polygon)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(sunDiskColor), // Yellow sun
          segments: sunOuterDiskSegments
        ),

        // Inner Sun Disk (12-sided polygon for opacity)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(sunDiskColor), // Inner yellow sun
          segments: sunInnerDiskSegments
        ),

        // Sun Rays (conditionally visible based on position)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(sunRayColor), // Lighter yellow rays
          segments: sunRaySegments
        )
      ]

      return Shot(
        hatches:
          (isSunFullyVisible ? [] : sunHatches) + [

        // Sea Surface (drawn later to cover the sun when partially visible)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(seaColor), // Blue sea
          segments: waveSegments
        ),
        ] +
        (isSunFullyVisible ? sunHatches : [])
        + [
        // Cloud 1 (stacked lines)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(cloudColor), // White cloud
          segments: cloudSegments1
        ),

        // Cloud 2 (stacked lines)
        Hatch(
          brush: Brush.main,
          filling: Filling.color(cloudColor), // Another white cloud
          segments: cloudSegments2
        )
      ])
    },
    shotsPerSecond: 25
  )

  // This code includes the sea-covering effect on the sun, selective visibility of downward rays, and clouds in a layered style.

  // This cartoonAnimation now includes a dual-layered sun disk, extended rays with rotation, sea waves tiling down to the screen bottom, and more natural clouds.

}
