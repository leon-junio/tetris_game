/**
 *
 * Tetris Game
 * @author Leon Jr Martins
 *
 */

import java.util.Random;

//public
public static final byte PIECE_SIZE= 20, BORDER = 10;
public static final short WIDTH = 300, HEIGHT = 400;
//private
private static final byte[] BG_COLOR = {0, 0, 0};
private static byte FPS = 30, DIFFICULT = 5;
// SIMPLE PIECE EXAMPLE
private static PVector[] ACTUAL_PIECE = null;

void setup() {
  size(300, 400);
  frameRate(FPS);
  ACTUAL_PIECE = takeRandomPiece();
}

// RENDERS

void draw() {
  background(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2]);
  drawBorders();
  drawPiece();
  updateMovement();
}

/**
 * Draw the borders of the game (4 rects - top, left, right, bottom)
 */
void drawBorders() {
  fill(20, 100, 255);
  noStroke();
  rect(0, 0, WIDTH, BORDER);
  rect(0, 0, BORDER, HEIGHT);
  rect(WIDTH-BORDER, 0, BORDER, HEIGHT);
  rect(0, HEIGHT-BORDER, WIDTH, BORDER);
}

void drawPiece() {
  for (PVector pos : ACTUAL_PIECE) {
    stroke(255, 255, 255);
    fill(200, 50, 50);
    rect(pos.x, pos.y, PIECE_SIZE, PIECE_SIZE);
  }
}

// LOGIC

PVector[] takeRandomPiece() {
  Random r = new Random();
  var pieces = Piece.values();
  return pieces[r.nextInt(pieces.length)].getBody();
}

void updateMovement() {
  if (!checkColisionWithGround())
    updatePieceY((byte)1);
}

void updatePieceX(byte movement) {
  for (PVector pos : ACTUAL_PIECE) {
    pos.x += (movement * DIFFICULT);
  }
}

void updatePieceY(byte movement) {
  for (PVector pos : ACTUAL_PIECE) {
    pos.y += movement * DIFFICULT;
  }
}

void rotateAllPiece() {
  PVector centralPoint = calculateCentralPoint();
  for (PVector pos : ACTUAL_PIECE) {
    PVector offset = PVector.sub(pos, centralPoint);
    offset.rotate(HALF_PI);
    pos.set(PVector.add(centralPoint, offset));
  }
}

PVector calculateCentralPoint() {
  float sumX = 0;
  float sumY = 0;
  for (PVector pos : ACTUAL_PIECE) {
    sumX += pos.x;
    sumY += pos.y;
  }
  float centerX = sumX / ACTUAL_PIECE.length;
  float centerY = sumY / ACTUAL_PIECE.length;
  return new PVector(centerX, centerY);
}

boolean checkColisionWithGround() {
  return (ACTUAL_PIECE[0].y >= HEIGHT - BORDER - PIECE_SIZE);
}

boolean checkColisionWithBorderLeft() {
  return (ACTUAL_PIECE[0].x <= BORDER);
}

boolean checkColisionWithBorderRight() {
  return (getMaxPointX() + PIECE_SIZE >= WIDTH - BORDER);
}

float getMaxPointX() {
  float max = -1;
  for (PVector pos : ACTUAL_PIECE) {
    if (pos.x > max) {
      max = pos.x;
    }
  }
  return max;
}

void keyPressed() {
  switch(key) {
  case 'a':
    if (!checkColisionWithBorderLeft())
      updatePieceX((byte)-PIECE_SIZE);
    break;
  case 'd':
    if (!checkColisionWithBorderRight())
      updatePieceX(PIECE_SIZE);
    break;
  case 's':
    if (!checkColisionWithGround())
      updatePieceY(PIECE_SIZE);
    break;
  case 'r':
    rotateAllPiece();
    break;
  }
}
