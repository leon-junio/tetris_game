public class PieceObj {

  public PieceObj(Piece piece) {
    this.body = piece.getBody();
    this.mainColor = piece.getMainColor();
    this.rotationAnchor = piece.getRotationAnchor();
  }

  private PVector[] body;
  private short[] mainColor;
  private byte rotationAnchor;

  public PVector[] getBody() {
    return this.body;
  }

  public short[] getMainColor() {
    return this.mainColor;
  }
  
  public byte getRotationAnchor() {
    return this.rotationAnchor;
  }
}
