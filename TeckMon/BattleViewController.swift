//
//  BattleViewController.swift
//  TeckMon
//
//  Created by 丸井一輝 on 2021/05/13.
//
//if number == 2{} else if number == 1{} else{}

import UIKit

class BattleViewController: UIViewController {
    
    var userDefaults = UserDefaults.standard
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    @IBOutlet var playerTPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    @IBOutlet var enemy1NameLabel: UILabel!
    @IBOutlet var enemy1ImageView: UIImageView!
    @IBOutlet var enemy1HPLabel: UILabel!
    @IBOutlet var enemy1MPLabel: UILabel!
    @IBOutlet var enemy2NameLabel: UILabel!
    @IBOutlet var enemy2ImageView: UIImageView!
    @IBOutlet var enemy2HPLabel: UILabel!
    @IBOutlet var enemy2MPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var playerHP = 100
    var playerMP = 0
    var playerTP = 0
    var enemyHP = 200
    var enemyMP = 0
    var enemy1HP = 2000
    var enemy1MP = 0
    var enemy2HP = 800
    var enemy2MP = 0
    

    var player: Character!
    var enemy: Character!
    var enemy1: Character!
    var enemy2: Character!
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        enemy1 = techMonManager.enemy1
        enemy2 = techMonManager.enemy2

        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(playerHP) / 100"
        playerMPLabel.text = "\(playerMP) / 20"
        playerTPLabel.text = "\(playerTP) / 100"
        
        let number = Int.random(in: 0...2)
        userDefaults.set(number, forKey: "monsterNo")
        // let number:[Int] = userDefaults.int(forKey: "monsterNo") as! [Int]
        
        if number == 2 {
        enemyNameLabel.text = "ドラゴン"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemyHP) / 200"
        enemyMPLabel.text = "\(enemyMP) / 35"
            
        } else if number == 1{
        enemy1NameLabel.text = "鬼スライム"
        enemy1ImageView.image = UIImage(named: "sraim.png")
        enemy1HPLabel.text = "\(enemy1HP) / 2000"
        enemy1MPLabel.text = "\(enemy1MP) / 35"
        
        } else {
        enemy2NameLabel.text = "タイタン"
        enemy2ImageView.image = UIImage(named: "titan.png")
        enemy2HPLabel.text = "\(enemy2HP) / 800"
        enemy2MPLabel.text = "\(enemy2MP) / 50"
        }
        
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame() {
        
        playerMP += 1
        if playerMP >= 20 {
            isPlayerAttackAvailable = true
            playerMP = 20
        } else {
            isPlayerAttackAvailable = false
        }
        
        let numberInt = userDefaults.integer(forKey: "monsterNo")
        
        if numberInt == 2{
            enemyMP += 1
            if enemyMP >= 35 {
                
                enemyAttack()
                enemyMP = 0
            }
        }else if numberInt == 1{
            enemy1MP += 1
            if enemy1MP >= 35 {
                
                enemy1Attack()
                enemy1MP = 0
            }
        }else{
            enemy2MP += 1
            if enemy2MP >= 35 {
                
                enemy2Attack()
                enemy2MP = 0
            }
        }
        
        playerMPLabel.text = "\(playerMP) / 20"
        
        if numberInt == 2{
            enemyMPLabel.text = "\(enemyMP) / 35"
        } else if numberInt == 1{
            enemy1MPLabel.text = "\(enemy1MP) / 35"
        } else{
            enemy2MPLabel.text = "\(enemy2MP) / 50"
        }

        
        func updateUI(){
            
            let numberInt = userDefaults.integer(forKey: "monsterNo")
            
            if numberInt == 2{
                enemyHPLabel.text = "\(enemyHP) / 200"
                enemyMPLabel.text = "\(enemyMP) / 20"
                
            } else if numberInt == 1{
                enemy1HPLabel.text = "\(enemy1HP) / 2000"
                enemy1MPLabel.text = "\(enemy1MP) / 35"
            } else{
                enemy2HPLabel.text = "\(enemy2HP) / 800"
                enemy2MPLabel.text = "\(enemy2MP) / 50"
            }
        }
        
    
    }
    
    func enemyAttack() {
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 20
        
        if playerHP <= 0{
            playerHPLabel.text = "0 / 100"
        }else{
            playerHPLabel.text = "\(playerHP) / 100"
        }
        
        judgeBattle()
    }
    
    func enemy1Attack() {
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 30
        
        if playerHP <= 0{
            playerHPLabel.text = "0 / 100"
        }else{
            playerHPLabel.text = "\(playerHP) / 100"
        }
        
        judgeBattle()
    }
    
    func enemy2Attack() {
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 40
        
        if playerHP <= 0{
            playerHPLabel.text = "0 / 100"
        }else{
            playerHPLabel.text = "\(playerHP) / 100"
        }
        
        judgeBattle()
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        } else {
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北…"
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func judgeBattle() {
        
        let numberInt = userDefaults.integer(forKey: "monsterNo")
        if numberInt == 2{
            if playerHP <= 0 {
                finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
            } else if enemyHP <= 0{
                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            }
        } else if numberInt == 1{
            if playerHP <= 0 {
                finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
            } else if enemy1HP <= 0{
                finishBattle(vanishImageView: enemy1ImageView, isPlayerWin: true)
            }
        } else{
            if playerHP <= 0 {
                finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
            } else if enemy2HP <= 0{
                finishBattle(vanishImageView: enemy2ImageView, isPlayerWin: true)
            }
        }
    }
    
    
    @IBAction func attackAction() {
        
        if isPlayerAttackAvailable {
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            playerTP += 10
            playerTPLabel.text = "\(playerTP) / 100"
            
            if playerTP >= 100 {
                playerTP = 100
            }
            playerMP = 0
            
            let numberInt = userDefaults.integer(forKey: "monsterNo")
            if numberInt == 2{
                enemyHP -= 30
                //enemy1HP -= 30
                //enemy2HP -= 30
                playerMP = 0
                
                enemyHPLabel.text = "\(enemyHP) / 200"
                playerMPLabel.text = "\(playerMP) / 35"
                
                if enemyHP <= 0 {
                    finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
                }
                
                enemy.currentHP -= player.attackPoint
                
            } else if numberInt == 1{
                //enemyHP -= 30
                enemy1HP -= 30
                //enemy2HP -= 30
                playerMP = 0
                
                //enemyHPLabel.text = "\(enemyHP) / 200"
                enemy1HPLabel.text = "\(enemy1HP) / 2000"
                //enemy2HPLabel.text = "\(enemyHP) / 800"
                playerMPLabel.text = "\(playerMP) / 35"
                
                if enemy1HP <= 0 {
                    finishBattle(vanishImageView: enemy1ImageView, isPlayerWin: true)
                }
                
                enemy1HP -= player.attackPoint
            } else{
                //enemyHP -= 30
                //enemy1HP -= 30
                enemy2HP -= 30
                playerMP = 0
                
                //enemyHPLabel.text = "\(enemyHP) / 200"
                //enemy1HPLabel.text = "\(enemyHP) / 2000"
                enemy2HPLabel.text = "\(enemy2HP) / 800"
                playerMPLabel.text = "\(playerMP) / 50"
                
                if enemy2HP <= 0 {
                    finishBattle(vanishImageView: enemy2ImageView, isPlayerWin: true)
                }
                
                enemy2.currentHP -= player.attackPoint
            }
            
            
            
            judgeBattle()
        }
    }
    
    @IBAction func tameruAction() {
        if isPlayerAttackAvailable {
            techMonManager.playSE(fileName: "SE_charge")
            
            playerTP += 40
            playerTPLabel.text = "\(playerTP) / 100"
            if playerTP >= 100{
                playerTP = 100
            }
            player.currentMP = 0
        }
    }
    
    @IBAction func fireAction() {
        
        if isPlayerAttackAvailable && playerTP >= 40 {
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            playerTP -= 40
            playerTPLabel.text = "\(playerTP) / 100"
            if playerTP <= 0 {
                playerTP = 0
            }
            playerMP = 0
            
            let numberInt = userDefaults.integer(forKey: "monsterNo")
            if numberInt == 2{
                enemyHP -= 50
            } else if numberInt == 1{
                enemy1HP -= 100
            } else{
                enemy2HP -= 100
            }
            
            judgeBattle()
        }
    }
    
    @IBAction func healAction() {
        techMonManager.playSE(fileName: "SE_magic")
        
        if playerTP >= 40 {
            
            playerHP += 20
            playerTP -= 40
            playerTPLabel.text = "\(playerTP) / 100"
            if playerTP < 0 {
                playerTP = 0
            }
            
            if playerHP >= 100{
                playerHPLabel.text = "100 / 100"
            } else {
            playerHPLabel.text = "\(playerHP) / 100"
            }
        }
        
        
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
