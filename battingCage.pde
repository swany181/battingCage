
import saito.objloader.*;  //OBJLoaderを使うためのimport文
OBJModel model, batmodel;  //OBJ形式のモデルデータを格納する変数

int button1_x;  //バッティングボタンの位置や大きさを格納する変数
int button1_y;
int button_d;

int ball = -600;  //ボールの初期位置

int flag = 0;  //バットの状態
int bflag = 0;  //ボールの状態

int angle;  //ボールの飛ぶ方向を格納する変数
int theta;  //ボールの飛ぶ高さを格納する変数

int fast = 2;  //ボールのスピード(3種類)

int ztheta;  //バットのスウィング角度を格納する変数
int xtheta;

void setup() {
  size(400, 400, P3D);
  

  PFont font = createFont("MS Gothic", 12, true);
  textFont(font);

  model = new OBJModel(this, "machine.obj", POLYGON);  //バッティングマシーンの読み込み
  batmodel = new OBJModel(this, "bat.obj", POLYGON);  //バットの読み込み
  model.scale(20);  //モデルデータの拡大率を設定
  batmodel.scale(15);
  noStroke();
}

void draw() {
  background(100);

  lightSpecular(200, 200, 200);   //光源の鏡面反射成分を設定
  directionalLight(200, 200, 200, 1, 1, -1);  //平行光源の設定 

  pushMatrix();  //3Dとして置くもの
  rotateX(radians(0));  //tweakモードで視点(実際には物体)を変えるための回転命令
  rotateY(radians(0));
  rotateZ(radians(0));

  pushMatrix();  //ボール
  if (bflag%2==1) {  //ボールがバットに当たった状態
    if (fast==1)ball-=25;  //跳ね返されたボールの速さ
    else if (fast==2)ball-=20;
    else if (fast==3)ball-=15;
    translate(0, -50, 0);  //座標回転したときのズレの調整
    if (angle==1)rotateY(radians(44));  //ボールの飛ぶ方向の指定
    else if (angle==2)rotateY(radians(34));
    else if (angle==3)rotateY(radians(24));
    else if (angle==4)rotateY(radians(14));
    else if (angle==5)rotateY(radians(0));
    else if (angle==6)rotateY(radians(-15));
    else if (angle==7)rotateY(radians(-25));
    else if (angle==8)rotateY(radians(-35));
    else rotateY(radians(-45));
    rotateX(radians(theta));  //ボールの飛ぶ高さの指定
    if (ball<-2000) {  //ボールがある程度飛んだら元の状態に戻す
      if (fast==1)ball+=45;
      else if (fast==2)ball+=15;
      else if (fast==3)ball+=05;
      ball=-600;
      bflag++;
    }
  } else {  //ボールがバットに当たってない状態
    if (fast==1)ball+=45;
    else if (fast==2)ball+=15;
    else if (fast==3)ball+=5;
    if (ball>1000) {  //ボールがある程度進んだら元の位置に戻す
      ball=-600;
    }
  }
  translate(width/2, height/2, ball);  //球種:ストレート
  specular(255, 255, 255);  //光源の鏡面反射成分に対する反射色 
  sphere(5);  //ボールの描画
  popMatrix();

  pushMatrix();  //バッティングマシーン
  translate(width/2, height/2, -600);   //バッティングマシーンの位置
  model.draw();  //バッティングマシーンの描画
  popMatrix();

  pushMatrix();  //バット
  translate(149, 210, 155);  //バットの位置
  if (flag==1) {  //スウィング時
    ztheta+=16;
    xtheta+=12;
    rotateZ(radians(100 - abs(ztheta)));  //スウィング動作
    rotateX(radians(xtheta));
    if (ztheta==80)flag=0;  //元の状態に戻す
  } else {  //非スウィング時
    ztheta = -80;
    xtheta = -60;
    rotateZ(radians(20));  //バットの傾き
    rotateX(radians(-60));
  }
  batmodel.draw();  //バットの描画
  popMatrix();

  pushMatrix();  //ホームランの的
  noLights();  //光源をOFFにする
  translate(0, 0, -1500);  //的の奥行き調整
  ellipse(button1_x - 530, button1_y - 884, button_d/2, button_d/2);  //的の描画
  ellipse(button1_x + 230, button1_y - 884, button_d/2, button_d/2);
  popMatrix();

  pushMatrix();  //左右のフェンス
  noLights();  //光源をOFFにする
  strokeWeight(3);
  stroke(0, 255, 0);
  translate(340, 67, 79);  //右のフェンスの位置
  for (int i=0; i<=200; i+=10) {  //右のフェンスの描画
    line(0, i, 0, 0, i, 200);
    line(0, 0, i, 0, 200, i);
  }
  translate(-268, 0, 0);  //左のフェンスの位置
  for (int i=0; i<=200; i+=10) {  //左のフェンスの描画
    line(0, i, 0, 0, i, 200);
    line(0, 0, i, 0, 200, i);
  }
  noFill();
  stroke(255);
  rotateX(radians(90));  //バッターボックスの配置
  translate(8, -16, -224);
  rect(0, 0, 70, 200);  //左のバッターボックスの描画
  rect(170, 0, 74, 200);  //右のバッターボックスの描画
  fill(255);
  translate(91, 5, 0);  //ストライクゾーンの位置
  triangle(30, 30, 0, 80, 60, 79);  //ストライクゾーンの描画
  rect(0, 80, 60, 50);
  noStroke();
  popMatrix();
  popMatrix();

  pushMatrix();  //2Dとして貼り付けるもの
  noLights();  //光源をOFFにする
  textSize(12);
  fill(200); 
  rect(337, 337, button_d = 60, button_d);  //ボタンの枠の描画
  fill(255, 0, 0);
  ellipse(button1_x = 367, button1_y = 367, button_d, button_d);  //ボタンの描画
  fill(0, 255, 0);
  ellipse(button1_x = 367, button1_y - 158, button_d/2, button_d/2);  //超速ボタンの描画
  ellipse(button1_x = 367, button1_y - 209, button_d/2, button_d/2);  //速ボタンの描画
  ellipse(button1_x = 367, button1_y - 257, button_d/2, button_d/2);  //遅ボタンの描画
  fill(0, 0, 255);
  text("batting", 348, 371);  //各ボタンへのテキスト貼り付け
  text("遅", 360, 115);
  text("速", 361, 164);
  text("超速", 356, 214);
  fill(255, 0, 0);
  textSize(25);
  if (ball<-1500 && (angle==4 && theta==-25 || angle==6 && theta==-24))text("ホームラン！", width/3, height/3);  //ホームランイベント
  popMatrix();
}

void mousePressed() { 
  if (dist(mouseX, mouseY, button1_x, button1_y)< button_d/2) {  //battingボタン押下
    if (ball>100 && ball<200) {  //バットとボールの当たり判定
      if (ball<110)angle=1;  //タイミング判定
      else if (ball<120)angle=2;
      else if (ball<130)angle=3;
      else if (ball<145)angle=4;
      else if (ball<155)angle=5;
      else if (ball<170)angle=6;
      else if (ball<180)angle=7;
      else if (ball<190)angle=8;
      else angle=9;
      bflag++;  //バットとボールが当たったフラグを立てる
    }
    flag = 1;  //バットを振ったフラグを立てる
    theta = int(random(-70, -10));  //ボールの飛ぶ高さを決定
  } else if (dist(mouseX, mouseY, button1_x, button1_y-158)< button_d/4)fast = 1;  //各速さボタン押下
  else if (dist(mouseX, mouseY, button1_x, button1_y-209)< button_d/4)fast = 2;
  else if (dist(mouseX, mouseY, button1_x, button1_y-257)< button_d/4)fast = 3;
}
