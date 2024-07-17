/**
 *
 * Tetris Game
 * @author Leon Jr Martins
 *
 */

import java.util.Random;
import java.util.List;

//public
public static final byte PIECE_SIZE= 20, NEXT_PIECE_SIZE = 8, FPS = 30, BORDER = 10; // BORDER CAN'T BE BIGGER THAN PIECE_SIZE
public static final short WIDTH = 280, HEIGHT = 400; // W and H of game window (just the game frame)
//private
private static final byte[] BG_COLOR = {0, 0, 0};
private static final short MIN_VALUE = -9999, MAX_VALUE = +9999, TEXT_NEXT_PIECE_Y = HEIGHT/2;
private static byte DIFFICULT = 1, TIME_TO_UPDATE_Y = 0;
private boolean hitGround = false, running = false, gameOver = false;
private static final Random randomPiecePicker = new Random();
private static PieceObj ACTUAL_PIECE, NEXT_PIECE;
//TODO: change actual pieces to a matrix of PVectors (x, y) hard to iterate over list
private static final List<PieceObj> ACTUAL_PIECES = new ArrayList<>();

private PVector[][] FIELD_MAP_PIECES = new PVector[HEIGHT / PIECE_SIZE - (BORDER*2 / PIECE_SIZE)][(WIDTH / PIECE_SIZE) - (BORDER*2 / PIECE_SIZE)];

private static PFont FONT_GAME;

void setup() {
  size(600, 400); // WINDOW SIZE (These values are different from WIDTH and HEIGHT)
  frameRate(FPS * DIFFICULT);
  FONT_GAME =  createFont("Impact", 18);
  running = true;
  ACTUAL_PIECE = takeRandomPiece();
  NEXT_PIECE = takeRandomPiece();
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
    insertIntoFieldMap(ACTUAL_PIECE);
    if(!gameOver){
      checkFieldMap();  
      ACTUAL_PIECE = NEXT_PIECE;
      NEXT_PIECE = takeRandomPiece();
    }
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
* Insert the piece into the field map (matrix of pieces)
* 
* @param piece The piece to insert
*/
void insertIntoFieldMap(PieceObj piece) {
  for (PVector pos : piece.getBody()) {
    if (pos!=null) {
      if(pos.y < BORDER) {
        gameOver = true;
        running = false;
        return;
      }
      // use z as a flag to know what is the index of the piece in the pieces list 
      pos.z = ACTUAL_PIECES.indexOf(piece);
      FIELD_MAP_PIECES[((int)pos.y - BORDER) / PIECE_SIZE][((int)pos.x - BORDER) / PIECE_SIZE] = pos;
    }
  }
}

/**
* Check if the user made a line into the field map and call the method to remove it
*/
void checkFieldMap() {
  for (int i = 0; i < FIELD_MAP_PIECES.length; i++) {
    boolean isLine = true;
    for (int j = 0; j < FIELD_MAP_PIECES[i].length; j++) {
      if (FIELD_MAP_PIECES[i][j] == null) {
        isLine = false;
        break;
      }
    }
    if (isLine) {
      removeLine(i);
    }
  }
}

/**
* Remove a line from the field map and move all the pieces above it down
* 
* @param line The line to remove
*/
void removeLine(int line) {
  // remove the pieces from the list and the field map
  for (int i = 0; i < FIELD_MAP_PIECES[line].length; i++) {
    var piece = ACTUAL_PIECES.get((int)FIELD_MAP_PIECES[line][i].z);
    FIELD_MAP_PIECES[line][i] = null;
    for (int j = 0; j < piece.getBody().length; j++) {
      if (piece.getBody()[j] != null && piece.getBody()[j].y == (line * PIECE_SIZE) + BORDER) {
        piece.removeSmallPiece(j);
      }
    }
  }
  // move all the pieces above the line down
  for (int i = line; i > 0; i--) {
    for (int j = 0; j < FIELD_MAP_PIECES[i].length; j++) {
      FIELD_MAP_PIECES[i][j] = FIELD_MAP_PIECES[i-1][j];
      if (FIELD_MAP_PIECES[i][j] != null) {
        FIELD_MAP_PIECES[i][j].y += PIECE_SIZE;
      }
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
  FIELD_MAP_PIECES = new PVector[HEIGHT / PIECE_SIZE - (BORDER*2 / PIECE_SIZE)][(WIDTH / PIECE_SIZE) - (BORDER*2 / PIECE_SIZE)];
  hitGround = false;
  gameOver = false;
  running = true;
  TIME_TO_UPDATE_Y = 0;
  frameRate(FPS * DIFFICULT);
  System.gc();
}

// Automatic piece movement
void updateMovement() {
  if(checkColisionWithRoof()){
    gameOver = true;
    running = false;
  }
  else if (!checkColisionWithGround() && !checkDownColisionWithPieces())
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
  return (ACTUAL_PIECE.getMaxPointY() >= HEIGHT - BORDER - PIECE_SIZE);
}

boolean checkColisionWithBorderLeft() {
  return (ACTUAL_PIECE.getMinPointX() <= BORDER);
}

boolean checkColisionWithBorderRight() {
  return ((ACTUAL_PIECE.getMaxPointX() + PIECE_SIZE) >= WIDTH - BORDER);
}

boolean checkDownColisionWithPieces() {
  for (var piece : ACTUAL_PIECES) {
    if(ACTUAL_PIECE.checkColisionWithPiece(piece, 0, PIECE_SIZE))
      return true;
  };
  return false;
}

boolean checkColisionWithRoof() {
  return !checkColisionWithGround() && checkDownColisionWithPieces() && ACTUAL_PIECE.getBody()[0].y <= BORDER;
}

boolean checkSideColisionWithPieces() {
  for (var piece : ACTUAL_PIECES) {
    if(ACTUAL_PIECE.checkColisionWithPiece(piece, PIECE_SIZE, 0) || ACTUAL_PIECE.checkColisionWithPiece(piece, -PIECE_SIZE, 0))
      return true;
  };
  return false;
}

// KEYBOARD AND CONTROLS

void keyPressed() {
  if (!hitGround) {
    switch(key) {
    case 'a':
      if (!checkColisionWithBorderLeft() && !checkSideColisionWithPieces())
        updatePieceX((byte)-(PIECE_SIZE));
      break;
    case 'd':
      if (!checkColisionWithBorderRight() && !checkSideColisionWithPieces())
        updatePieceX((byte)(PIECE_SIZE));
      break;
    case 's':
      if (!checkColisionWithGround() && !checkDownColisionWithPieces())
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
