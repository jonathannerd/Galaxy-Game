///////////////////////////////////////////////////////////////
//Jonathan Sherman
//11/8/2023
// Game where I shoot meters to get points and beat the final boss to win
///////////////////////////////////////////////////////////////
import processing.sound.*;
AudioSample shoot;
AudioSample song;
AudioSample explosionSound;
AudioSample shopSound;
AudioSample menuSound;
AudioSample dead;
AudioSample bossSound;
AudioSample finalBoss;
AudioSample playerShot;

//coordinent of ship
PVector ship, bos1, bos2, bos3;

//int for sound
int sound;

//booleans for controls
boolean w, a, s, d, up, down, left, right, space, leftRotate, rightRotate;

//important shop stuff
boolean game, died;
boolean options, shop, menu=true, loading=true;
boolean bossShot, shooting;
boolean shipBuy, shipBuy2, heartBuy, heartBuy1;

//arrays  for explosion, rocks and shots
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Shot> shots = new ArrayList<Shot>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<BossShot> bossShots = new ArrayList<BossShot>();

//array for sprites
PImage[] explosionSprites;

//background
int scroll;

//countdowns
int shotCooldown = 20;
int shotCooldownCounter = 0;
int bossShotCooldown = 30;
int bossShotCooldownCounter = 0;

//health and shop stuff
int bossHealth = 500, bossHealth1 = 1000, bossHealth3 = 5000;
int unlocked = color(255), unlocked1 = color(255), heartUnlocked = color(255), heartUnlocked1 = color(255), MsG = color(255, 0, 0);

//images
PImage ship1, BG, heart, meteor1, meteor2, meteor3, ship2, ship3, boss1, boss2, boss3, BG2;

//score and other variables to change size and money
int bossSize = 300;
int score=0, finalScore;
int heart1 = 30, heart2 = 30, heart3 = 30, heart4 = 30, heart5 = 30;
int hitPoints = 1, healthPoints = 3;
int numRocks = 5;
float random;
void setup() {
  fullScreen();
  ship = new PVector(width / 2, height / 2);
  bos1 = new PVector(width/2, -300);
  bos2 = new PVector(width / 2, -300);
  bos3 = new PVector(width / 2, -300);
  frameRate(60);
  explosionSprites = new PImage[]{
    loadImage("explosion1.png"),
    loadImage("explosion2.png"),
    loadImage("explosion3.png"),
    loadImage("explosion4.png"),
    loadImage("explosion5.png"),
  };
  shoot = new SoundFile(this, "Y2meta.app - Laser Gun Sound Effect (128 kbps).mp3");
  playerShot = new SoundFile(this, "gun (1) (1).mp3");
  explosionSound = new SoundFile(this, "meteor (1).mp3");
  song = new SoundFile(this, "Y2meta.app - Undertale OST_ 005 - Ruins (128 kbps).mp3");
  shopSound = new SoundFile(this, "Y2meta.app - Undertale OST_ 002 - Start Menu (320 kbps).mp3");
  menuSound = new SoundFile(this, "Y2meta.app - Undertale OST_ 004 - Fallen Down (320 kbps).mp3");
  bossSound = new SoundFile(this, "Y2meta.app - Undertale OST_ 009 - Enemy Approaching (320 kbps) (1).mp3");
  dead = new SoundFile(this, "Y2meta.app - Undertale OST_ 011 - Determination (320 kbps).mp3");
  finalBoss = new SoundFile(this, "Y2meta.app - Undertale OST_ 010 - Ghost Fight (128 kbps).mp3");
  boss1 = loadImage("boss1.png");
  boss2 = loadImage("boss2.png");
  boss3 = loadImage("boss3.png");
  ship1 = loadImage("ship1.png");
  ship2 = loadImage("ship2.png");
  ship3 = loadImage("ship3.png");
  meteor1 = loadImage("meteor1.png");
  meteor2 = loadImage("meteor2.png");
  meteor3 = loadImage("meteor3.png");
  BG = loadImage("space (2).jpg");
  BG2 = loadImage("space1.jpg");
  heart = loadImage("heart.png");
  heart.resize(50, 50);
  BG.resize(1920, 1080);
  BG2.resize(1920, 1080);
  meteor1.resize(300, 300);
  meteor2.resize(300, 300);
  meteor3.resize(300, 300);
  ship3.resize(150, 150);
  boss1.resize(300, 300);
  boss2.resize(300, 300);
  boss3.resize(300, 300);
  imageMode(CENTER);
  spawn();
}
//spaws rocks
void spawn() {
  for (int i = 0; i < numRocks; i++) {
    rocks.add(new Rock(random(0, width), random(-1500, -300), hitPoints));
  }
}
//calling stuff
void draw() {
  if (game== false && died == false&&menu==true)menu();
  if (options==true && died == false)options();
  if (shop == true && died == false)shop();
  if (game == true && died == false) {
    backgroundImage();
    updateRocks();
    redraw();
    controls();
    updateShots();
    increaseHealth();
    boss();
    updateBossShots();
    if (shooting == true)shoot();
  }
  if (healthPoints < 1)died();
}
//background
void backgroundImage() {
  scroll = frameCount*4 % BG2.height;
  for (int i = scroll; i > 0; i -= BG2.height) {
    copy(BG2, 0, 0, width, BG2.height, 0, i, width, BG2.height);
    copy(BG2, 0, 0, width, BG2.height, 0, i - BG2.height, width, BG2.height);
  }
}
//menu
void menu() {
  if (sound==0)menuSound.play();
  sound=1;
  image(BG, width/2, height/2);
  fill(255, 60);
  stroke(255, 50);
  strokeWeight(5);
  rect(width/2.8, height/2.2, 600, 100, 8);
  rect(width/2.8, height/1.57, 600, 100, 8);
  rect(width/2.8, height/1.2, 600, 100, 8);
  rect(width/4, 0, 1000, 450, 10);
  noStroke();
  strokeWeight(1);
  rect(width - 100, 0, 200, 40);
  fill(0);
  textSize(100);
  text("START", width/2.25, height/1.87);
  text("OPTIONS", width/2.39, height/1.1);
  text("SHOP", width/2.23, height/1.4);
  textSize(30);
  text("EXIT", width -70, 25);
  textSize(300);
  fill(255, 0, 0);
  text("SPACE", width/3.3, height/4.7);
  textSize(150);
  text("WARZONE", width/2.9, height/2.7);
  if (options == false) {
    if (mousePressed) {
      if (mouseX >= width/2.8 && mouseX <= width/2.8 + 600 && mouseY >= height/2.2 && mouseY <= height/2.2 + 100) {
        game = true;
        menuSound.stop();
        sound=0;
        menu = false;
      }
      if (mouseX <= width && mouseX >= width - 100 && mouseY >= 0 && mouseY <= 40&& game == false) {
        exit();
      }
      if (mouseX >= width/2.39 && mouseX <= width/2.39 + 600 && mouseY <= height/1.1 && mouseY >= height/1.1 - 100) {
        options = true;
      }
      if (mouseX >= width/2.39 && mouseX <= width/2.39 + 600 && mouseY <= height/1.4 && mouseY >= height/1.4 - 100) {
        menuSound.stop();
        sound=0;
        shop = true;
      }
    }
  }
}
//options
void options() {
  menu = false;
  image(BG, width/2, height/2);
  // text("The controlls for this game are space to shoot and w,a,s,d or arrow keys to move.",30,100); Put this in loading screen
  rectMode(CENTER);
  fill(MsG);
  rect(width/2, height/2, 500, 500, 10);
  rectMode(CORNER);
  textSize(150);
  fill(255);
  text("Do Not Press the Button", width/2-745, height/8);
  fill(0);
  text("ONLY", width/2-150, height/2-130);
  text("FOR", width/2-150, height/2+50);
  text("Ms.G", width/2-150, height/2+220);
  fill(255);
  textSize(30);
  text("It gives you $500.", width/2-100, height/1.3);
  text("Back", 10, 35);
  if (mousePressed) {
    if (mouseX >= 0 && mouseX <= 50 && mouseY <= 50 && mouseY >= 0) {
      options = false;
      menu = true;
    }
    if (mouseX >=width/2-250&&mouseX<=width/2+250&&mouseY>=height/2-250&&mouseY<=height/2+250) {
      finalScore = 500;
      MsG = color(0, 255, 0);
    }
  }
}
//shop
void shop() {
  if (sound==0)shopSound.play();
  sound=1;
  menu=false;
  fill(255);
  textSize(200);
  image(BG, width/2, height/2);
  text("GARAGE", width/3, height/5);

  strokeWeight(5);
  fill(255, 50);
  stroke(0, 255, 0);
  rect(width/5 - 150, height/2 - 150, 300, 300, 8);
  stroke(unlocked);
  rect(width/2 - 150, height/2 - 150, 300, 300, 8);
  stroke(unlocked1);
  rect(width/1.25 - 150, height/2 - 150, 300, 300, 8);

  rectMode(CENTER);
  stroke(heartUnlocked);
  rect(width/2 - 300, height/1.35+100, 200, 200, 5);
  stroke(heartUnlocked1);
  rect(width/2 + 300, height/1.35+100, 200, 200, 5);
  image(heart, width/2-300, height/1.35+100, 100, 100);
  image(heart, width/2+300, height/1.35+100, 100, 100);
  rectMode(CORNER);

  fill(255);
  strokeWeight(10);
  image(ship1, width/5, height/2, 250, 250);
  image(ship2, width/2, height/2, 250, 250);
  image(ship3, width/1.25, height/2, 250, 250);


  textSize(100);
  text("$"+finalScore, width-300, 100);
  textSize(70);
  text("$100", width/2-375, height-10);
  text("$150", width/2+230, height-10);
  text("Free", width/6, height/1.44);
  text("Unlocked", width/8, height/3);
  textSize(70);
  text("$75", width/2.15, height/1.44);
  if (shipBuy == true)text("Unlocked", width/2.22, height/3);
  else text("Locked", width/2.22, height/3);
  textSize(70);
  text("$175", width/1.3, height/1.44);
  if (shipBuy2 == true)text("Unlocked", width/1.35, height/3);
  else text("Locked", width/1.35, height/3);
  textSize(30);
  text("Back", 10, 35);
  if (mousePressed) {
    if (mouseX >= 0 && mouseX <= 50 && mouseY <= 50 && mouseY >= 0) {
      shopSound.stop();
      sound=0;
      shop = false;
      menu=true;
      if (unlocked == color(255, 0, 0))unlocked = color(255);
      if (unlocked1 == color(255, 0, 0))unlocked1 = color(255);
      if (heartUnlocked == color(255, 0, 0))heartUnlocked = color(255);
      if (heartUnlocked1 == color(255, 0, 0))heartUnlocked1 = color(255);
    }
    if (mouseX >= width/2-150&&mouseX<=width/2+150&&mouseY>= height/2-150&&mouseY<=height/2+150&&finalScore >=75 && shipBuy ==false) {
      shipBuy = true;
      unlocked = color(0, 255, 0);
      finalScore-=75;
    } else if (mouseX >= width/2-150&&mouseX<=width/2+150&&mouseY>= height/2-150&&mouseY<=height/2+150&& shipBuy == false)unlocked = color(255, 0, 0);

    if (mouseX >= width/1.25-150&&mouseX<=width/1.25+150&&mouseY>= height/2-150&&mouseY<=height/2+150&&finalScore >=175 && shipBuy2 == false) {
      shipBuy2 = true;
      unlocked1 = color(0, 255, 0);
      finalScore-=175;
    } else if (mouseX >= width/1.25-150&&mouseX<=width/1.25+150&&mouseY>= height/2-150&&mouseY<=height/2+150&& shipBuy2 == false)unlocked1 = color(255, 0, 0);

    if (mouseX>=width/2 - 400&&mouseX<=width/2-200&&mouseY>= height/1.35&&mouseY<=height/1.35+200 && finalScore >= 100&&heartBuy==false) {
      heartBuy = true;
      heartUnlocked = color(0, 255, 0);
      finalScore-=100;
      healthPoints++;
    } else if (mouseX>=width/2-400&&mouseX<=width/2-200&&mouseY>= height/1.35&&mouseY<=height/1.35+200&&heartBuy==false)heartUnlocked = color(255, 0, 0);

    if (mouseX>=width/2+200&&mouseX<=width/2+400&&mouseY>= height/1.35&&mouseY<=height/1.35+200 && finalScore >= 150 &&heartBuy1==false) {
      heartBuy1 = true;
      heartUnlocked1 = color(0, 255, 0);
      finalScore-=150;
      healthPoints++;
    } else if (mouseX>=width/2+200&&mouseX<=width/2+400&&mouseY>= height/1.35&&mouseY<=height/1.35+200&&heartBuy1==false)heartUnlocked1 = color(255, 0, 0);
  }
}
void redraw() {
  if (sound==0&&score==0) {
    song.play();
    sound = 1;
    bossSound.stop();
  }
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion explosion = explosions.get(i);
    explosion.update(3);
    explosion.display();
    if (explosion.isFinished()) {
      explosions.remove(i);
    }
  }
  pushMatrix();
  translate(ship.x, ship.y);
  if (leftRotate == true) {
    rotate(radians(-25));
  } else if (rightRotate == true) {
    rotate(radians(25));
  }
  if (shipBuy2 == true)image(ship3, 0, 0);
  else if (shipBuy == true)image(ship2, 0, 0);
  else image(ship1, 0, 0);
  popMatrix();
  textSize(50);
  text(score, 50, 50);
  if (heartBuy1 == true)image(heart, width - 270, 30, heart4, heart4);
  if (heartBuy == true)image(heart, width - 210, 30, heart5, heart5);
  image(heart, width - 30, 30, heart1, heart1);
  image(heart, width - 90, 30, heart2, heart2);
  image(heart, width - 150, 30, heart3, heart3);
}
//rocks
void updateRocks() {
  for (Rock rock : rocks) {
    rock.display();
    rock.update();

    for (int j = shots.size() - 1; j >= 0; j--) {
      Shot shot = shots.get(j);
      if (dist(rock.x, rock.y, shot.x, shot.y) < 150) {
        rock.reduceHealth();
        rock.setLastHitShot(shot);
        shots.remove(j);
      }
    }

    if (rock.y > height) {
      rock.reset();
    }

    if (rock.health <= 0 && !(score >= 100 && score <= 109)) {
      explosions.add(new Explosion(rock.x, rock.y, 300));
      explosionSound.play();
      rock.reset();
      score++;
    }

    if (rock.y - 150 <= ship.y && rock.y + 150 >= ship.y && rock.x - 150 <= ship.x + 40 && rock.x + 150 >= ship.x - 40) {
      explosions.add(new Explosion(rock.x, rock.y, 300));
      explosionSound.play();
      rock.reset();
      healthPoints -= 1;
      if (heart1 == 30 && heart2 == 30 && heart3 == 30 && heart4 == 30 && heart5 == 30) heart1 = 0;
      else if (heart2 == 30 && heart3 == 30&& heart4 == 30 && heart5 == 30) heart2 = 0;
      else if (heart3 == 30&& heart4 == 30 && heart5 == 30) heart3 = 0;
      else if (heart4 == 30 && heart5 == 30)heart4=0;
      else if (heart5 == 30)heart5=0;
    }
  }
}
//shots
void updateShots() {
  for (int i = shots.size() - 1; i >= 0; i--) {
    Shot shot = shots.get(i);
    shot.update();
    shot.display();

    if (shot.y < 0) {
      shots.remove(i);
    }
  }
  if (shotCooldownCounter > 0) {
    shotCooldownCounter--;
  }
  if (shipBuy2 == true)shotCooldown = 5;
  else if (shipBuy == true)shotCooldown = 10;
}
//shot counter
void shoot() {
  if (shotCooldownCounter <= 0) {
    shots.add(new Shot(ship.x, ship.y));
    shotCooldownCounter = shotCooldown;
    playerShot.play();
  }
}
//BOSS
void boss() {
  pushMatrix();
  translate(bos1.x, bos1.y);
  rotate(radians(180));
  if (score == 50) {
    rocks.clear();
    image(boss1, 0, 0, 300, 300);
    if (bos1.y < 200) bos1.y += 2;
    else bos1.x = lerp(ship.x, bos1.x, .97);
    song.stop();
    if (sound==1) {
      song.stop();
      bossSound.play();
      sound=2;
    }
  }
  popMatrix();
  pushMatrix();
  translate(bos2.x, bos2.y);
  rotate(radians(180));
  if (score == 100) {
    if (!(numRocks==3||numRocks==10))rocks.clear();
    if (!(numRocks == 10))numRocks = 3;
    if (numRocks == 3)spawn();
    numRocks = 10;
    image(boss2, 0, 0, 300, 300);
    if (bos2.y < 200)bos2.y += 2;
    else bos2.x = lerp(ship.x, bos2.x, .97);
    song.stop();
    if (sound==1) {
      song.stop();
      bossSound.play();
      sound=2;
    }
  }
  popMatrix();
  pushMatrix();
  translate(bos3.x, bos3.y);
  rotate(radians(180));
  if (score == 150) {
    rocks.clear();
    image(boss3, 0, 0, 300, 300);
    if (bos3.y < 200)bos3.y += 2;
    else bos3.x = lerp(ship.x, bos3.x, .97);
    song.stop();
    if (sound==1) {
      song.stop();
      finalBoss.play();
      sound=2;
    }
  }
  popMatrix();
  if ((score == 50) && bos1.y == 200) {
    if (bossShotCooldownCounter <= 0) {
      bossShots.add(new BossShot(bos1.x, bos1.y, true));
      shoot.play();
      bossShotCooldownCounter = bossShotCooldown;
    }
  }
  if (score == 100 && bos2.y == 200) {
    if (bossShotCooldownCounter <= 0) {
      bossShots.add(new BossShot(bos2.x, bos2.y, true));
      shoot.play();
      bossShotCooldownCounter = bossShotCooldown;
    }
  }
  if (score == 150 && bos3.y == 200) {
    if (bossShotCooldownCounter <= 0) {
      bossShots.add(new BossShot(bos3.x, bos3.y, true));
      shoot.play();
      bossShotCooldownCounter = bossShotCooldown;
    }
  }
  if (bossHealth <= 0) {
    song.play();
    bossHealth = 500;
    bossSound.stop();
    sound=0;
    score = 60;
    numRocks = 8;
    bos1.x = -600;
    spawn();
  }
  if (bossHealth1 <= 0) {
    bossHealth1 = 1000;
    song.play();
    rocks.clear();
    bossSound.stop();
    sound=0;
    score = 110;
    numRocks = 10;
    bos2.x = -600;
    spawn();
  }
  if (bossHealth3 <= 0) {
    finalBoss.stop();
    menu = false;
    game = false;
    rocks.clear();
    bossShots.clear();
    shots.clear();
    winningScreen();
  }
}
void winningScreen() {
  finalBoss.stop();
  background(0);
}
void updateBossShots() {
  if (score ==50 || score == 100 || score == 150) {
    for (int i = bossShots.size() - 1; i >= 0; i--) {
      BossShot bossShot = bossShots.get(i);
      bossShot.update();
      bossShot.display();

      // Remove boss shot if it goes out of bounds
      if (bossShot.y > height) {
        bossShots.remove(i);
      }

      // Check for collisions with the player
      if (score == 50 && dist(ship.x, ship.y, bossShot.x, bossShot.y) < 80) {
        bossShots.remove(i);
        healthPoints -= 1;
        if (heart1 == 30 && heart2 == 30 && heart3 == 30 && heart4 == 30 && heart5 == 30) heart1 = 0;
        else if (heart2 == 30 && heart3 == 30&& heart4 == 30 && heart5 == 30) heart2 = 0;
        else if (heart3 == 30&& heart4 == 30 && heart5 == 30) heart3 = 0;
        else if (heart4 == 30 && heart5 == 30)heart4=0;
        else if (heart5 == 30)heart5=0;
      } else if (score == 100 && dist(ship.x, ship.y, bossShot.x, bossShot.y) < 80) {
        bossShots.remove(i);
        healthPoints -= 1;
        if (heart1 == 30 && heart2 == 30 && heart3 == 30 && heart4 == 30 && heart5 == 30) heart1 = 0;
        else if (heart2 == 30 && heart3 == 30&& heart4 == 30 && heart5 == 30) heart2 = 0;
        else if (heart3 == 30&& heart4 == 30 && heart5 == 30) heart3 = 0;
        else if (heart4 == 30 && heart5 == 30)heart4=0;
        else if (heart5 == 30)heart5=0;
      } else if (score == 150 && dist(ship.x, ship.y, bossShot.x, bossShot.y) < 80) {
        bossShots.remove(i);
        healthPoints -= 1;
        if (heart1 == 30 && heart2 == 30 && heart3 == 30 && heart4 == 30 && heart5 == 30) heart1 = 0;
        else if (heart2 == 30 && heart3 == 30&& heart4 == 30 && heart5 == 30) heart2 = 0;
        else if (heart3 == 30&& heart4 == 30 && heart5 == 30) heart3 = 0;
        else if (heart4 == 30 && heart5 == 30)heart4=0;
        else if (heart5 == 30)heart5=0;
      }
      for (int j = shots.size() - 1; j >= 0; j--) {
        Shot shot = shots.get(j);
        if (dist(bos1.x, bos1.y, shot.x, shot.y) < 150) {
          tint(255, 0, 0, 150);
          image(boss1, bos1.x, bos1.y, 310, 310);
          tint(255, 255);
          if (shipBuy2 == true) bossHealth -= 30;  // Adjust the damage dealt by the player's shots
          else if (shipBuy == true)bossHealth -=20;
          else bossHealth -=10;
          shots.remove(j);
        } else if (dist(bos2.x, bos2.y, shot.x, shot.y) < 150) {
          tint(255, 0, 0, 150);
          image(boss2, bos2.x, bos2.y, 310, 310);
          tint(255, 255);
          if (shipBuy2 == true) bossHealth1 -= 30;  // Adjust the damage dealt by the player's shots
          else if (shipBuy == true)bossHealth1 -=20;
          else bossHealth1 -=10;
          shots.remove(j);
        } else if (dist(bos3.x, bos3.y, shot.x, shot.y) < 150) {
          tint(255, 0, 0, 150);
          image(boss3, bos3.x, bos3.y, 310, 310);
          tint(255, 255);
          if (shipBuy2 == true) bossHealth3 -= 30;  // Adjust the damage dealt by the player's shots
          else if (shipBuy == true)bossHealth3 -=20;
          else bossHealth3 -=10;
          shots.remove(j);
        }
      }
    }
  }

  // Decrement the boss shot cooldown counter
  bossShotCooldownCounter = max(0, bossShotCooldownCounter - 1);
}
//controls
void controls() {
  if (w && ship.y >= 50) {
    if (shipBuy2 ==true)ship.y-=16;
    else if (shipBuy == true)ship.y-=12;
    else ship.y -= 8;
  }
  if (up && ship.y >= 50) {
    if (shipBuy2 ==true)ship.y-=16;
    else if (shipBuy == true)ship.y-=12;
    else ship.y -= 8;
  }
  if (s && ship.y <= height - 50) {
    if (shipBuy2 ==true)ship.y+=16;
    else if (shipBuy == true)ship.y+=12;
    else ship.y += 8;
  }
  if (down && ship.y <= height - 50) {
    if (shipBuy2 ==true)ship.y+=16;
    else if (shipBuy == true)ship.y+=12;
    else ship.y += 8;
  }
  if (a && ship.x >= 50) {
    leftRotate = true;
    if (shipBuy2 ==true)ship.x-=16;
    else if (shipBuy == true)ship.x-=12;
    else ship.x -= 8;
  }
  if (left && ship.x >= 50) {
    leftRotate = true;
    if (shipBuy2 ==true)ship.x-=16;
    else if (shipBuy == true)ship.x-=12;
    else ship.x -= 8;
  }
  if (d && ship.x <= width - 50) {
    rightRotate = true;
    if (shipBuy2 ==true)ship.x+=16;
    else if (shipBuy == true)ship.x+=12;
    else ship.x += 8;
  }
  if (right && ship.x <= width - 50) {
    rightRotate = true;
    if (shipBuy2 ==true)ship.x+=16;
    else if (shipBuy == true)ship.x+=12;
    else ship.x += 8;
  }
}
//rock health
void increaseHealth() {
  if (score >= 15 && hitPoints == 1) {
    hitPoints = 2;
    updateRockHealth();
  }
  if (score >= 30 && hitPoints == 2) {
    hitPoints = 3;
    updateRockHealth();
  }
  if (score >= 45 && hitPoints == 3) {
    hitPoints = 4;
    updateRockHealth();
  }
  if (score >= 60 && hitPoints == 4) {
    hitPoints = 5;
    updateRockHealth();
  }
  if (score >= 100 && hitPoints == 5) {
    hitPoints = 10;
    updateRockHealth();
  }
}

void updateRockHealth() {
  for (Rock rock : rocks) {
    rock.health = hitPoints;
  }
}
//you died
void died() {
  image(BG, width/2, height/2);
  game = false;
  died = true;
  bossSound.stop();
  song.stop();
  if (sound==1)dead.play();
  sound=0;
  fill(255);
  textSize(200);
  text("You Died", width/3.2, height/4.7);
  textSize(100);
  text("Play Again", width/2.6, height/1.87);
  text("Menu", width/2.3, height/1.4);
  textSize(30);
  text("exit", width -70, 25);
  explosions.clear();
  if (mousePressed) {
    if (mouseX <= width && mouseX >= width - 100 && mouseY >= 0 && mouseY <= 40) {
      exit();
    }
    if (mouseX >= width/2.6 && mouseX <= width/2.6 + 230 && mouseY <= height/1.87 && mouseY >= height/1.87 - 100) {
      sound=0;
      dead.stop();
      hitPoints = 1;
      finalScore += score;
      score = 0;
      healthPoints = 3;
      heart1 =30;
      heart2=30;
      heart3=30;
      heart4=30;
      heart5=30;
      rocks.clear();
      bos1.y = -300;
      bos2.y = -300;
      bos3.y = -300;
      bos1.x = width/2;
      bos2.x = width/2;
      bos3.x = width/2;
      numRocks=5;
      spawn();
      game = true;
      died = false;
      shots.clear();
      bossShots.clear();
      ship.x=width/2;
      ship.y=height/2;
    }
    if (mouseX >= width/2.6 && mouseX <= width/2.6 + 230 && mouseY <= height/1.4 && mouseY >= height/1.4 - 100) {
      sound=0;
      dead.stop();
      hitPoints = 1;
      finalScore += score;
      score = 0;
      healthPoints = 3;
      heart1 =30;
      heart2=30;
      heart3=30;
      heart4=30;
      heart5=30;
      rocks.clear();
      bossHealth = 500;
      bossHealth1 = 1000;
      bos1.y = -300;
      bos2.y = -300;
      bos3.y = -300;
      bos1.x = width/2;
      bos2.x = width/2;
      bos3.x = width/2;
      numRocks=5;
      spawn();
      game = false;
      menu =true;
      died = false;
      shots.clear();
      bossShots.clear();
      ship.x=width/2;
      ship.y=height/2;
    }
  }
}
void keyPressed() {
  if (key == 'w') w = true;
  if (key == 'a') a = true;
  if (key == 's') s = true;
  if (key == 'd') d = true;
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
  if (key == ' ') {
    shooting = true;
  }
}

void keyReleased() {
  if (key == 'w') w = false;
  if (key == 'a') a = false;
  if (key == 's') s = false;
  leftRotate =false;
  if (key == 'd') d = false;
  rightRotate =false;
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
  if (keyCode == LEFT) left = false;
  leftRotate =false;
  if (keyCode == RIGHT) right = false;
  rightRotate =false;
  if (key == ' ') {
    shooting = false;
  }
}
//Clases for stuff because Matthew intimidated me :(
class Shot {
  float x, y;

  Shot(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    y -= 10;
  }

  void display() {
    fill(255);
    rect(x, y, 8, 30, 8);
  }
}

class Rock {
  float x, y;
  int health;
  int originalHealth;
  Shot lastHitShot;

  Rock(float x, float y, int health) {
    this.x = x;
    this.y = y;
    this.health = health;
    this.originalHealth = health;
  }

  void display() {
    fill(255);
    float size = 300;
    if (lastHitShot != null) {
      size -= 50;
    }
    tint(map(this.health, 1, 10, 255, 150));

    if (!(random==5)) {
      if (score < 51) {
        image(meteor2, x, y, size, size);
      }
      if (score >=50 &&score <101) {
        image(meteor3, x, y, size, size);
      }
      if (score > 100) {
        image(meteor1, x, y, size, size);
      }
    }
    tint(255, 255, 255);
  }

  void update() {
    if (score <= 10) y += 8;
    else if (score <= 20) y += 9;
    else if (score <= 30) y += 10;
    else if (score <= 40) y += 11;
    else if (score <= 50) y += 12;
    else if (score <= 60) y += 13;
    else if (score <= 70) y += 14;
    else if (score <= 80) y += 15;
    else if (score <= 90) y += 16;
    else if (score <= 100) y += 17;
    else if (score <= 110) y += 18;
    else if (score <= 120) y += 19;
    else if (score <= 130) y += 20;
    else if (score <= 140) y += 21;
    else if (score <= 150) y += 12;
  }

  void reduceHealth() {
    if (shipBuy2==true)health-=3;
    else if (shipBuy==true)health-=2;
    else health--;
  }

  void reset() {
    x = random(0, width);
    y = -300;
    health = hitPoints;
    lastHitShot = null;
  }

  void setLastHitShot(Shot shot) {
    lastHitShot = shot;
  }
}
class BossShot {
  float x, y;
  boolean isBossShot;

  BossShot(float x, float y, boolean isBossShot) {
    this.x = x;
    this.y = y;
    this.isBossShot = isBossShot;
  }

  void update() {
    if (isBossShot) {
      y += 15;
    } else {
      y -= 10;
    }
  }

  void display() {
    fill(255);
    if (score==50)rect(x, y, 15, 80, 8);
    else if (score==100)rect(x, y, 15, 80, 8);
    else if (score==150)rect(x, y, 15, 80, 8);
  }
}
class Explosion {
  float x, y;
  float size;
  int frames;
  int currentFrame = 0;

  Explosion(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.frames = explosionSprites.length;
  }

  void update(int frameInterval) {
    // Update the explosion animation frame with a frame interval
    if (currentFrame < frames) {
      if (frameCount % frameInterval == 0) {
        currentFrame++;
      }
    }
  }

  void display() {
    if (currentFrame < frames) {
      PImage explosionSprite = explosionSprites[currentFrame];
      image(explosionSprite, x, y, size, size);
    }
  }

  boolean isFinished() {
    return currentFrame >= frames;
  }
}
