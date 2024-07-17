public class PieceObj {

  public PieceObj(Piece piece) {
    this.body = piece.getBody();
    this.remaining = (byte) this.body.length;
    this.mainColor = piece.getMainColor();
    this.rotationAnchor = piece.getRotationAnchor();
  }

  private PVector[] body;
  private short[] mainColor;
  private byte rotationAnchor;
  private byte remaining;

  public PVector[] getBody() {
    return this.body;
  }
  
  public byte getRemaining(){
    return this.remaining;
  }

  public short[] getMainColor() {
    return this.mainColor;
  }

  public byte getRotationAnchor() {
    return this.rotationAnchor;
  }

  public float getMaxPointX() {
    float max = tetris.MIN_VALUE;
    for (PVector pos : this.body) {
      if (pos.x > max) {
        max = pos.x;
      }
    }
    return max;
  }

  public float getMinPointX() {
    float min = tetris.MAX_VALUE;
    for (PVector pos : this.body) {
      if (pos.x < min) {
        min = pos.x;
      }
    }
    return min;
  }

  public float getMaxPointY() {
    float max = tetris.MIN_VALUE;
    for (PVector pos : this.body) {
      if (pos.y > max) {
        max = pos.y;
      }
    }
    return max;
  }

  public float getMinPointY() {
    float min = tetris.MAX_VALUE;
    for (PVector pos : this.body) {
      if (pos.y < min) {
        min = pos.y;
      }
    }
    return min;
  }

  public void setBody(PVector[] body) {
    this.body = body;
  }

  /**
  * Remove a small piece from the piece
  *
  * @param index The index of the small piece to remove
  */
  public void removeSmallPiece(int index) {
    if (index < body.length) {
      body[index] = null;
      remaining--;
    }
  }

  /**
  * Rotate the piece
  */
  public void rotatePiece() {
    var bkp = new PVector[body.length];
    for (int i = 0; i < body.length; i++) {
      bkp[i] = new PVector(body[i].x, body[i].y);
    }
    PVector anchor = this.rotationAnchor != -1 ? ACTUAL_PIECE.getBody()[this.rotationAnchor] : calculateCentralPoint();
    for (PVector pos : this.body) {
      if (rotationAnchor != -1 && pos != anchor) {
        PVector offset = PVector.sub(pos, anchor);
        offset.rotate(HALF_PI);
        pos.set(PVector.add(anchor, offset));
        pos.x = round(pos.x);
        pos.y = round(pos.y);
        if (checkIfRotateIsOutbound()) {
          this.body = bkp;
          return;
        }
      }
      // check if anchor is out of the game area
      if (anchor.x < BORDER || anchor.x > WIDTH - BORDER || anchor.y < BORDER || anchor.y > HEIGHT - BORDER) {
        this.body = bkp;
        return;
      }
    }
  }

  /**
  * Check if the piece is out of the game area
  *
  * @return boolean True if the piece is out of the game area
  */
  public boolean checkIfRotateIsOutbound() {
    return getMaxPointX() + PIECE_SIZE > WIDTH - BORDER || getMinPointX() < BORDER || getMaxPointY() > HEIGHT - BORDER || getMinPointY() < BORDER;
  }

  /**
  * Change the position of all body parts
  *
  * @param x The x-axis movement
  * @param y The y-axis movement
  */
  public void changeAllBodyPositions(int x, int y) {
    for (var pos : this.body) {
      if(pos != null){
        pos.x += x;
        pos.y += y;
      }
    }
  }

  /**
  * Change the position of a single body part
  *
  * @param x     The x-axis movement
  * @param y     The y-axis movement
  * @param index The index of the body part to move
  */
  public void changeOneBodyPosition(int x, int y, int index) {
    if (index < body.length) {
      var pos = body[index];
      if(pos != null){
        pos.x += x;
        pos.y += y;
      }
    }
  }

  /**
  * Calculate the central point of the piece based on the average of all points
  *
  * @return PVector The central point of the piece
  */
  public PVector calculateCentralPoint() {
    float sumX = 0;
    float sumY = 0;
    for (PVector pos : this.body) {
      sumX += pos.x;
      sumY += pos.y;
    }
    return new PVector(sumX / this.body.length, sumY / this.body.length);
  }

  /**
  * Delete the actual piece
  */
  public void delete() {
    for (int i = 0; i < body.length; i++) {
      body[i] = null;
    }
    body = null;
  }

  /**
  * Check if the piece is colliding with another piece
  *
  * @param piece     The piece to check the collision
  * @param movementX The x-axis movement
  * @param movementY The y-axis movement
  * @return boolean True if the piece is colliding with another piece
  */
  public boolean checkColisionWithPiece(PieceObj piece, int movementX, int movementY) {
    for (PVector pos : this.body) {
      for (PVector pos2 : piece.getBody()) {
        if (pos != null && pos2 != null && pos.x + movementX == pos2.x && pos.y + movementY == pos2.y) {
          return true;
        }
      }
    }
    return false;
  }

}