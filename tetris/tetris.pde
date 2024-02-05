/**
 *
 * Tetris Game
 * @author Leon Jr Martins
 *
 */

import java.util.Random;
import java.util.List;

//public
public static final byte PIECE_SIZE= 20, FPS = 30, BORDER = 10;
public static final short WIDTH = 280, HEIGHT = 400; // W and H of game window (just the game frame)
//private
private static final byte[] BG_COLOR = {0, 0, 0};
private static final short MIN_VALUE = -9999, MAX_VALUE = +9999;
private static byte DIFFICULT = 1, TIME_TO_UPDATE_Y = 0;
private boolean hitGround = false, running = false, gameOver = false;
private static final Random randomPiecePicker = new Random();
// SIMPLE PIECE EXAMPLE
private static PieceObj ACTUAL_PIECE;
// collections is a bad idea
// change it to a plain matrix of piece bodies may create one just for colors
private static final List<PieceObj> ACTUAL_PIECES = new ArrayList<>();
private static PFont FONT_GAME;

void setup() {
  size(600, 400); // WINDOW SIZE (These values are different from WIDTH and HEIGHT)
  frameRate(FPS * DIFFICULT);
  FONT_GAME =  createFont("Impact", 18);
  running = true;
  ACTUAL_PIECE = new PieceObj(Piece.PLUS);
}

// RENDERS

void draw() {
  background(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2]);
  drawText();
  if (running) {
    drawBorders();
    TIME_TO_UPDATE_Y++;
    drawPiece(ACTUAL_PIECE);
    drawMatrixPieces();
    checkGameStatus();
  }
}

// draw text and utils
void drawText() {
  fill(30, 100, 189);
  textFont(FONT_GAME);
  text("Tetris Clone Game - Leon Junio", 325, BORDER + 15);
  if (gameOver) {
    // TODO: game over logic
  }
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

// draw the matrix pieces in game (That was not changed by game score logic)
void drawMatrixPieces() {
  for (var piece : ACTUAL_PIECES) {
    drawPiece(piece);
  }
}

// draw any piece in game
void drawPiece(PieceObj piece) {
  for (PVector pos : piece.getBody()) {
    var colors = piece.getMainColor();
    stroke(255, 255, 255);
    fill(colors[0], colors[1], colors[2]);
    rect(pos.x, pos.y, PIECE_SIZE, PIECE_SIZE);
  }
}

// LOGIC
PieceObj takeRandomPiece() {
  return new PieceObj(Piece.values()[randomPiecePicker.nextInt(Piece.values().length)]);
}

// check automatic features
void checkGameStatus() {
  if (hitGround) {
    ACTUAL_PIECES.add(ACTUAL_PIECE);
    ACTUAL_PIECE = takeRandomPiece();
    hitGround = false;
    TIME_TO_UPDATE_Y = 0;
  } else {
    if (TIME_TO_UPDATE_Y == 10) {
      // frameRate(FPS * DIFFICULT); Some way to change the game difficult
      updateMovement();
      TIME_TO_UPDATE_Y = 0;
    }
  }
}

// Automatic piece movement
void updateMovement() {
  if (!checkColisionWithGround())
    updatePieceY((byte)PIECE_SIZE);
  else
    hitGround = true;
}

void updatePieceX(byte movement) {
  for (PVector pos : ACTUAL_PIECE.getBody()) {
    pos.x += movement;
  }
}

void updatePieceY(byte movement) {
  for (PVector pos : ACTUAL_PIECE.getBody()) {
    pos.y += movement;
  }
}

void rotateAllPiece() {
  int rotationAnchor = ACTUAL_PIECE.getRotationAnchor();
  PVector anchor = ACTUAL_PIECE.getBody()[rotationAnchor];

  for (PVector pos : ACTUAL_PIECE.getBody()) {
    if (pos != anchor) { // Exclude the rotation anchor
      PVector offset = PVector.sub(pos, anchor);
      offset.rotate(HALF_PI);
      pos.set(PVector.add(anchor, offset));
      // Round the coordinates to the nearest integer
      pos.x = round(pos.x);
      pos.y = round(pos.y);
    }
  }
}

// COLISIONS AND PIECE 2D BODY

boolean checkColisionWithGround() {
  return (getMaxPointY() >= HEIGHT - BORDER - PIECE_SIZE);
}

boolean checkColisionWithBorderLeft() {
  return (getMinPointX() <= BORDER);
}

boolean checkColisionWithBorderRight() {
  return ((getMaxPointX() + PIECE_SIZE) >= WIDTH - BORDER);
}

float getMaxPointX() {
  float max = MIN_VALUE;
  for (PVector pos : ACTUAL_PIECE.getBody()) {
    if (pos.x > max) {
      max = pos.x;
    }
  }
  return max;
}

float getMinPointX() {
  float min = MAX_VALUE;
  for (PVector pos : ACTUAL_PIECE.getBody()) {
    if (pos.x < min) {
      min = pos.x;
    }
  }
  return min;
}

// Get max point of Y can be replaced with a simple minimal heap (lowest Y positions in an array)
float getMaxPointY() {
  float max = MIN_VALUE;
  for (PVector pos : ACTUAL_PIECE.getBody()) {
    if (pos.y > max) {
      max = pos.y;
    }
  }
  return max;
}

// KEYBOARD AND CONTROLS

void keyPressed() {
  if (!hitGround) {
    switch(key) {
    case 'a':
      if (!checkColisionWithBorderLeft())
        updatePieceX((byte)-(PIECE_SIZE));
      break;
    case 'd':
      if (!checkColisionWithBorderRight())
        updatePieceX((byte)(PIECE_SIZE));
      break;
    case 's':
      if (!checkColisionWithGround())
        updatePieceY((byte)(PIECE_SIZE));
      break;
    }
  }
}

void keyReleased() {
  if (!hitGround) {
    switch(key) {
    case 'r':
      rotateAllPiece();
      break;
    }
  }
}
