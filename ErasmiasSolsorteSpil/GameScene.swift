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
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    player.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 150))
  }
}










////
////  GameScene.swift
////  ErasmiasSolsorteSpil
////
////  Created by Morten Olsson on 11/09/2017.
////
////
//
//import SpriteKit
//import GameplayKit
//
//class GameScene: SKScene {
//
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//    
//    override func didMove(to view: SKView) {
//        
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
//    
//    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
//}
