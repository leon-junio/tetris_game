/**
 *
 * Tetris Game
 * @author Leon Jr Martins
 *
 */

import java.util.Random;
import java.util.List;

//public
public static final byte PIECE_SIZE= 20, NEXT_PIECE_SIZE = 8, FPS = 30, BORDER = 10;
public static final short WIDTH = 280, HEIGHT = 400; // W and H of game window (just the game frame)
//private
private static final byte[] BG_COLOR = {0, 0, 0};
private static final short MIN_VALUE = -9999, MAX_VALUE = +9999, TEXT_NEXT_PIECE_Y = HEIGHT/2;
private static byte DIFFICULT = 1, TIME_TO_UPDATE_Y = 0;
private boolean hitGround = false, running = false, gameOver = false;
private static final Random randomPiecePicker = new Random();
// SIMPLE PIECE EXAMPLE
private static PieceObj ACTUAL_PIECE, NEXT_PIECE;
// collections is a bad idea
// change it to a plain matrix of piece bodies may create one just for colors
private static final List<PieceObj> ACTUAL_PIECES = new ArrayList<>();
private static PFont FONT_GAME;

void setup() {
  size(600, 400); // WINDOW SIZE (These values are different from WIDTH and HEIGHT)
  frameRate(FPS * DIFFICULT);
  FONT_GAME =  createFont("Impact", 18);
  running = true;
  ACTUAL_PIECE = new PieceObj(Piece.DIAGI);
  NEXT_PIECE = new PieceObj(Piece.DIAG);
}

// RENDERS

void draw() {
  background(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2]);
  drawText();
  if (running) {
    drawBorders();
    TIME_TO_UPDATE_Y++;
    drawPiece(ACTUAL_PIECE);
    drawNextPiece(NEXT_PIECE);
    drawMatrixPieces();
    checkGameStatus();
  }
}

// draw text and utils
void drawText() {
  fill(30, 100, 189);
  textFont(FONT_GAME);
  text("Tetris Processing Game", 345 , BORDER + 35);
  if (gameOver) {
    // TODO: game over logic
    drawGameOver();
  }
}

/**
 * Draw the game over screen
 */
void drawGameOver() {
  fill(255, 255, 255);
  textFont(FONT_GAME);
  text("Game Over", (WIDTH), HEIGHT/2);
  text("Press space to restart", (WIDTH)-35, (HEIGHT/2)+40);
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
    if (pos!=null) {
      var colors = piece.getMainColor();
      stroke(255, 255, 255);
      fill(colors[0], colors[1], colors[2]);
      rect(pos.x, pos.y, PIECE_SIZE, PIECE_SIZE);
    }
  }
}

// draw any piece in game
void drawNextPiece(PieceObj piece) {
  fill(30, 100, 189);
  textFont(FONT_GAME);
  text("Next tetris block piece: ", 355 , TEXT_NEXT_PIECE_Y);
  for (PVector pos : piece.getBody()) {
    if (pos!=null) {
      var colors = piece.getMainColor();
      stroke(255, 255, 255);
      fill(colors[0], colors[1], colors[2]);
      rect(pos.x + WIDTH + 30, pos.y + TEXT_NEXT_PIECE_Y + 75, PIECE_SIZE, PIECE_SIZE);
    }
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
    ACTUAL_PIECE = NEXT_PIECE;
    NEXT_PIECE = takeRandomPiece();
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

/**
 * Restart the game (reset snake, food, score and move interval)
 */
void restartGame() {
  ACTUAL_PIECE = new PieceObj(Piece.DIAGI);
  NEXT_PIECE = new PieceObj(Piece.DIAG);
  ACTUAL_PIECES.clear();
  hitGround = false;
  gameOver = false;
  running = true;
  TIME_TO_UPDATE_Y = 0;
  frameRate(FPS * DIFFICULT);
}

// Automatic piece movement
void updateMovement() {
  if (!checkColisionWithGround())
    updatePieceY((byte)PIECE_SIZE);
  else
    hitGround = true;
}

void updatePieceX(byte movement) {
  ACTUAL_PIECE.changeAllBodyPositions(movement, 0);
}

void updatePieceY(byte movement) {
  ACTUAL_PIECE.changeAllBodyPositions(0, movement);
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
    case ' ':
      if(gameOver)
        restartGame();
    }
  }
}

void keyReleased() {
  if (!hitGround) {
    switch(key) {
    case 'r':
      ACTUAL_PIECE.rotatePiece();
      break;
    }
  }
}
