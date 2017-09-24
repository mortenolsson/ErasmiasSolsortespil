//
//  GameScene.swift
//  ErasmiasSolsorteSpil
//
//  Created by Morten Olsson on 11/09/2017.
//
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

  var player: SKNode!
  private var touchDown = false

  override func didMove(to view: SKView) {
    player = childNode(withName: "player")
    let timer = Timer(timeInterval: 2.0, target: self, selector: #selector(spawnObstacle(timer:)), userInfo: nil, repeats: true)
    spawnObstacle(timer: timer)
    RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
  }

  func spawnObstacle(timer: Timer) {
    let rand = GKShuffledDistribution(lowestValue: 25, highestValue: Int(self.size.height - 25))
    let obstacle = SKSpriteNode(imageNamed: "cloud")
    obstacle.zPosition = player.zPosition - 1
    obstacle.xScale = 0.15
    obstacle.yScale = 0.15
    let y = CGFloat(rand.nextInt())
    obstacle.position = CGPoint(x: player.position.x + 600, y: y)
    addChild(obstacle)
  }


  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    if touchDown {
      player.physicsBody?.applyForce(CGVector(dx:0, dy:1000))
    }

    player.physicsBody?.velocity.dx = 120
  }

  override func didSimulatePhysics() {
    camera?.position = CGPoint(x: player.position.x+180, y: camera?.position.y ?? 0)
    if player.position.y < 1 {
      player.position.y = 1
      player.physicsBody?.velocity.dy = 0
    }
    if player.position.y > size.height {
      player.position.y = size.height
      player.physicsBody?.velocity.dy = 0
    }

    // rotate based on angle / speed
//    if let body = player.physicsBody {
//      if (body.velocity.speed() > 0.01) {
//        player.zRotation = body.velocity.angle()
//      }
//    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = true
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = false
  }
}

extension CGVector {
  func speed() -> CGFloat {
    return sqrt(dx*dx+dy*dy)
  }
  func angle() -> CGFloat {
    return atan2(dy, dx)
  }
}


