//
//  GameScene.swift
//  ErasmiasSolsorteSpil
//
//  Created by Morten Olsson on 11/09/2017.
//
//

import SpriteKit
import GameplayKit

extension SKSpriteNode {
  func sizeTo(percent: Int, of screen: CGRect) {
    size.width = screen.width / 100 * CGFloat(percent)
    size.height = screen.height / 100 * CGFloat(percent)
  }
}

class GameScene: SKScene {

  let playerCategory: UInt32 = 1
  let enemyCategory: UInt32 = 2


  var player: SKSpriteNode!
  var currentHealth = 5
  var heartSprites = [SKNode]()
  private var touchDown = false

  override func didMove(to view: SKView) {
    player = childNode(withName: "player") as! SKSpriteNode
    player.sizeTo(percent: 20, of: frame)
    player.physicsBody?.categoryBitMask = playerCategory

    let timer = Timer(timeInterval: 2.0, target: self, selector: #selector(spawnObstacle(timer:)), userInfo: nil, repeats: true)
    let enemyTimer = Timer(timeInterval: 2.5, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
    spawnObstacle(timer: timer)
    RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    RunLoop.main.add(enemyTimer, forMode: RunLoopMode.commonModes)


//    if
//      let particlePath = Bundle.main.path(forResource: "MyParticle", ofType: "sks"),
//      let particle = NSKeyedUnarchiver.unarchiveObject(withFile: particlePath) as? SKEmitterNode {
//      particle.targetNode = self
//      player.addChild(particle)
//    }

    for i in 0...currentHealth {
      let heart = SKSpriteNode(imageNamed: "heart")
      heart.zPosition = 10
      heart.size.width = 25  // TODO: base on screen width
      heart.size.height = 25 // TODO: base on screen width
      camera?.addChild(heart)
      let cameraRightX = size.width / 2
      let cameraTopY = (size.height / 2)
      heart.position.x = cameraRightX - CGFloat(i * 40 + 25)
      heart.position.y = cameraTopY - 25
      heartSprites.append(heart)
    }
  }

  @objc func spawnObstacle(timer: Timer) {
    let rand = GKShuffledDistribution(lowestValue: 25, highestValue: Int(self.size.height - 25))
    let obstacle = SKSpriteNode(imageNamed: "cloud")
    obstacle.zPosition = player.zPosition - 1
    obstacle.xScale = 0.15
    obstacle.yScale = 0.15
    let y = CGFloat(rand.nextInt())
    obstacle.position = CGPoint(x: player.position.x + 600, y: y)
    addChild(obstacle)
  }

  @objc func spawnEnemy() {
    print("enemy spawn...")
    let rand = GKShuffledDistribution(lowestValue: 25, highestValue: Int(self.size.height - 25))
    let enemy = SKSpriteNode(imageNamed: "pig")
    enemy.zPosition = player.zPosition
    enemy.xScale = 0.25 // TODO: these should be absolutes based on screen size - or just absolutes
    enemy.yScale = 0.25


    let physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
    physicsBody.friction = 0
    enemy.physicsBody = physicsBody
    enemy.physicsBody?.velocity = CGVector(dx: -20, dy: 0)
    enemy.physicsBody?.affectedByGravity = false
    enemy.physicsBody?.categoryBitMask = enemyCategory

    let y = CGFloat(rand.nextInt())
    enemy.position = CGPoint(x: player.position.x + 600, y: y)
    addChild(enemy)
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

    guard let tap = touches.first else { return }
    let vector = CGVector(dx: tap.location(in: self).x - player.position.x, dy: tap.location(in: self).y - player.position.y)
    print("vector touched: \(vector)")
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = false
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    print("did beging contact")
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


