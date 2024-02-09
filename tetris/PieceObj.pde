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

  public void removeSmallPiece(int index) {
    if (index < body.length) {
      body[index] = null;
      remaining--;
    }
  }

  public void rotatePiece() {
    PVector anchor = this.rotationAnchor != -1 ? ACTUAL_PIECE.getBody()[this.rotationAnchor] : calculateCentralPoint();
    for (PVector pos : this.body) {
      if (rotationAnchor != -1 && pos != anchor) { // Exclude the rotation anchor
        PVector offset = PVector.sub(pos, anchor);
        offset.rotate(HALF_PI);
        pos.set(PVector.add(anchor, offset));
        // Round the coordinates to the nearest integer
        pos.x = round(pos.x);
        pos.y = round(pos.y);
      }
    }
  }

  public void changeAllBodyPositions(int x, int y) {
    for (var pos : this.body) {
      pos.x += x;
      pos.y += y;
    }
  }

  public void changeOneBodyPosition(int x, int y, int index) {
    if (index < body.length) {
      var pos = body[index];
      pos.x += x;
      pos.y += y;
    }
  }

  public PVector calculateCentralPoint() {
    float sumX = 0;
    float sumY = 0;
    for (PVector pos : this.body) {
      sumX += pos.x;
      sumY += pos.y;
    }
    float centerX = sumX / this.body.length;
    float centerY = sumY / this.body.length;
    return new PVector(centerX, centerY);
  }
}
