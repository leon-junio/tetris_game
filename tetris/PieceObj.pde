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
    PVector anchor = this.rotationAnchor != -1 ? ACTUAL_PIECE.getBody()[this.rotationAnchor] : calculateCentralPoint();
    for (PVector pos : this.body) {
      if (rotationAnchor != -1 && pos != anchor) { // Exclude the rotation anchor
        PVector offset = PVector.sub(pos, anchor);
        offset.rotate(HALF_PI);
        pos.set(PVector.add(anchor, offset));
        pos.x = round(pos.x);
        pos.y = round(pos.y);
      }
    }
  }

  /**
  * Change the position of all body parts
  *
  * @param x The x-axis movement
  * @param y The y-axis movement
  */
  public void changeAllBodyPositions(int x, int y) {
    for (var pos : this.body) {
      pos.x += x;
      pos.y += y;
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
      pos.x += x;
      pos.y += y;
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