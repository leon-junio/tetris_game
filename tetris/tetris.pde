/**
 *
 * Tetris Game
 * @author Leon Jr Martins
 *
 */

import java.util.Random;
import java.util.List;

//public
public static final byte PIECE_SIZE= 20, NEXT_PIECE_SIZE = 8, FPS = 27, BORDER = 10; // BORDER CAN'T BE BIGGER THAN PIECE_SIZE
public static final short WIDTH = 280, HEIGHT = 400; // W and H of game window (just the game frame)

//private
private static final byte[] BG_COLOR = {0, 0, 0};
private static final short MIN_VALUE = -9999, MAX_VALUE = +9999, TEXT_NEXT_PIECE_Y = HEIGHT/2;
private static byte DIFFICULT = 1, TIME_TO_UPDATE_Y = 0;
private boolean hitGround = false, running = false, gameOver = false, isFirstPiece = true;
private static final Random randomPiecePicker = new Random();
private static PieceObj ACTUAL_PIECE, NEXT_PIECE;

// List of pieces in game
private static final List<PieceObj> ACTUAL_PIECES = new ArrayList<>();

private static final int MAX_LINES = (HEIGHT / PIECE_SIZE) - (BORDER*2 / PIECE_SIZE);
private static final int MAX_COLUMNS = (WIDTH / PIECE_SIZE) - (BORDER*2 / PIECE_SIZE);

// Field map (matrix of pieces) to check if the user made a line and remove it
private PVector[][] FIELD_MAP_PIECES = new PVector[MAX_LINES][MAX_COLUMNS];

private static PFont FONT_GAME;

void setup() {
  size(600, 400); // WINDOW SIZE (These values are different from WIDTH and HEIGHT)
  frameRate(FPS * DIFFICULT);
  FONT_GAME =  createFont("Impact", 22);
  running = true;
  ACTUAL_PIECE = takeRandomPiece();
  NEXT_PIECE = takeRandomPiece();
}

// RENDERS

void draw() {
  try{
    background(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2]);
    drawText();
    drawBorders();
    drawMatrixBorderLines();
    drawMatrixPieces();
    if (running) {
      TIME_TO_UPDATE_Y++;
      drawPiece(ACTUAL_PIECE);
      drawNextPiece(NEXT_PIECE);
      checkGameStatus();
    }
  }catch(Exception e){
    System.out.println("Error: " + e.getMessage());
    e.printStackTrace();
    System.exit(1);
  }
}

// draw text and utils
void drawText() {
  fill(229, 228, 226);
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
  text("Game Over", 390, HEIGHT/2);
  text("Press space to restart", 345, (HEIGHT/2)+40);
}

/**
 * Draw the borders of the game (4 rects - top, left, right, bottom)
 */
void drawBorders() {
  if(!gameOver)
    fill(229, 229, 224);
  else
    fill(255, 0, 0);
  noStroke();
  rect(0, 0, WIDTH, BORDER);
  rect(0, 0, BORDER, HEIGHT);
  rect(WIDTH-BORDER, 0, BORDER, HEIGHT);
  rect(0, HEIGHT-BORDER, WIDTH, BORDER);
}

/**
* Draw grid line inside the borders of field map
*/
void drawMatrixBorderLines(){
  for (int i = 1; i < MAX_COLUMNS; i++) {
      stroke(30, 30, 30);
      fill(0, 0, 0);
      line(PIECE_SIZE*i + BORDER, BORDER, PIECE_SIZE*i + BORDER, HEIGHT - BORDER - 1);
  }
  for (int i = 1; i < MAX_LINES; i++) {
      stroke(30, 30, 30);
      fill(0, 0, 0);
      line(BORDER, PIECE_SIZE*i + BORDER, WIDTH - BORDER - 1, PIECE_SIZE*i + BORDER);
  }
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
  return new PieceObj(Piece.selectedPiecesToDraw[randomPiecePicker.nextInt(isFirstPiece? Piece.selectedPiecesToDraw.length - Piece.specialPiecesOffset : Piece.selectedPiecesToDraw.length)]);
}

// check automatic features
void checkGameStatus() {
  if (hitGround) {
    ACTUAL_PIECES.add(ACTUAL_PIECE);
    insertIntoFieldMap(ACTUAL_PIECE);
    if(ACTUAL_PIECE.type == Piece.BOMB) {
      bombPiece(ACTUAL_PIECE);
    }
    if(!gameOver){
      checkFieldMap();  
      ACTUAL_PIECE = NEXT_PIECE;
      NEXT_PIECE = takeRandomPiece();
      isFirstPiece = false;
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
* Iteration over matrix of pieces and list of pieces
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
  isFirstPiece = true;
  ACTUAL_PIECE = takeRandomPiece();
  NEXT_PIECE = takeRandomPiece();
  ACTUAL_PIECES.clear();
  FIELD_MAP_PIECES = new PVector[MAX_LINES][MAX_COLUMNS];
  hitGround = false;
  gameOver = false;
  running = true;
  TIME_TO_UPDATE_Y = 0;
  frameRate(FPS * DIFFICULT);
  System.gc();
}

/**
* Update the movement of the piece
*/
void updateMovement() {
  if(checkColisionWithRoof()){
    hitGround = true; 
    running = false;
    gameOver = true;
  }
  else if (!checkColisionWithRoof() && !checkColisionWithGround() && !checkDownColisionWithPieces())
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

/**
 * Check if the piece has a colision with the ground
 * 
 * @return boolean
 */
boolean checkColisionWithGround() {
  return (ACTUAL_PIECE.getMaxPointY() >= HEIGHT - BORDER - PIECE_SIZE);
}

/**
 * Check if the piece has a colision with the left border
 * 
 * @return boolean
 */ 
boolean checkColisionWithBorderLeft() {
  return (ACTUAL_PIECE.getMinPointX() <= BORDER);
}

/**
 * Check if the piece has a colision with the right border
 * 
 * @return boolean
 */
boolean checkColisionWithBorderRight() {
  return ((ACTUAL_PIECE.getMaxPointX() + PIECE_SIZE) >= WIDTH - BORDER);
}

/**
 * Check if the piece has a colision with another piece in the game (using the Y axis)
 * 
 * @return boolean
 */
boolean checkDownColisionWithPieces() {
  for (var piece : ACTUAL_PIECES) {
    if(ACTUAL_PIECE.checkColisionWithPiece(piece, 0, PIECE_SIZE))
      return true;
  };
  return false;
}

/**
 * Check if the piece has a colision with the roof
 * 
 * @return boolean
 */
boolean checkColisionWithRoof() {
  return !checkColisionWithGround() && checkDownColisionWithPieces() && ACTUAL_PIECE.getMaxPointY() < BORDER;
}

/**
 * Check if the piece has a colision with another piece in the game (using the X axis)
 * 
 * @return boolean
 */
boolean checkSideColisionWithPieces() {
  for (var piece : ACTUAL_PIECES) {
    if(ACTUAL_PIECE.checkColisionWithPiece(piece, PIECE_SIZE, 0) || ACTUAL_PIECE.checkColisionWithPiece(piece, -PIECE_SIZE, 0))
      return true;
  };
  return false;
}

// SPECIAL PIECES LOGIC
/**
* remove nearest random pieces from 6 to 15
* bomb object have the ability to remove pieces from the game
* bomb instance will have the position of where begin to remove pieces
*/
/**
 * Remove peças próximas do ponto de impacto da bomba.
 */
void bombPiece(PieceObj bomb) {
  int centerX = (int) bomb.getBody()[0].x;
  int centerY = (int) bomb.getBody()[0].y;

  int centerCol = (centerX - BORDER) / PIECE_SIZE;
  int centerRow = (centerY - BORDER) / PIECE_SIZE;


  int radius = (int) random(2, 5);

  for (int i = -radius; i <= radius; i++) {
    for (int j = -radius; j <= radius; j++) {
      int r = centerRow + i;
      int c = centerCol + j;

      if (r >= 0 && r < MAX_LINES && c >= 0 && c < MAX_COLUMNS) {
        if (r < 0 || r >= FIELD_MAP_PIECES.length || c < 0 || c >= FIELD_MAP_PIECES[r].length) {
          continue;
        }
        PVector target = FIELD_MAP_PIECES[r][c];
        if (target != null) {
          int index = (int) target.z;
          if (index < 0 || index >= ACTUAL_PIECES.size()) {
            continue;
          }
          FIELD_MAP_PIECES[r][c] = null;

          PieceObj piece = ACTUAL_PIECES.get(index);
          for (int k = 0; k < piece.getBody().length; k++) {
            if (piece.getBody()[k] != null &&
                piece.getBody()[k].x == target.x &&
                piece.getBody()[k].y == target.y) {
              piece.removeSmallPiece(k);
              break;
            }
          }
        }
      }
    }
  }

  removePieceFromFieldMap(bomb);
  reorganizeField();
}

void reorganizeField() {
  for (int i = FIELD_MAP_PIECES.length - 2; i >= 0; i--) { // de baixo pra cima
    for (int j = 0; j < FIELD_MAP_PIECES[i].length; j++) {
      PVector current = FIELD_MAP_PIECES[i][j];
      if (current != null) {
        int below = i + 1;
        while (below < FIELD_MAP_PIECES.length && FIELD_MAP_PIECES[below][j] == null) {
          FIELD_MAP_PIECES[below][j] = current;
          FIELD_MAP_PIECES[below - 1][j] = null;
          current.y += PIECE_SIZE;
          below++;
        }
      }
    }
  }
}

void removePieceFromFieldMap(PieceObj piece) {
  if (piece == null) return;
  if (piece.remaining > 0){
    for (PVector pos : piece.getBody()) {
      if (pos != null) {
        FIELD_MAP_PIECES[((int)pos.y - BORDER) / PIECE_SIZE][((int)pos.x - BORDER) / PIECE_SIZE] = null;
      }
    }
  }
  ACTUAL_PIECES.remove(piece);
  piece = null;
}


// KEYBOARD AND CONTROLS

void keyPressed() {
  if (running && !gameOver && !hitGround) {
    switch(key) {
      case 'a':
        if (!hitGround && !checkColisionWithRoof() && !checkColisionWithBorderLeft() && !checkSideColisionWithPieces())
          updatePieceX((byte)-(PIECE_SIZE));
        break;
      case 'd':
        if (!hitGround && !checkColisionWithRoof() && !checkColisionWithBorderRight() && !checkSideColisionWithPieces())
          updatePieceX((byte)(PIECE_SIZE));
        break;
      case 's':
        if (!hitGround && !checkColisionWithRoof() && !checkColisionWithGround() && !checkDownColisionWithPieces())
          updatePieceY((byte)(PIECE_SIZE));
        break;
    }
    }else{
      switch(key) {
        case ' ':
          if(gameOver)
            restartGame();
            break;
      }
  }
}

void keyReleased() {
  if (running && !hitGround) {
    switch(key) {
    case 'r':
      ACTUAL_PIECE.rotatePiece();
      break;
    }
  }
}
