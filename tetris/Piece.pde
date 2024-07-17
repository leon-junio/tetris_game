public enum Piece {

  LSIMPLE(new PVector[]{
    new PVector(((WIDTH/2) - BORDER), BORDER),
    new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
    new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
    }, new short[]{46, 195, 54}, (byte)0),
    CUMBUCA(new PVector[]{
    new PVector(((WIDTH/2) - BORDER), BORDER),
    new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
    new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE * 2, BORDER - PIECE_SIZE),
     new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE * 2, BORDER),
    new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
    }, new short[]{46, 195, 54}, (byte)4),
    DIAGI(new PVector[]{
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER), BORDER ),
      new PVector(((WIDTH/2) - BORDER) + PIECE_SIZE, BORDER + PIECE_SIZE),
    }, new short[]{48, 156, 195}, (byte)0),
    DIAG(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER + PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER) + PIECE_SIZE, BORDER ),
      new PVector(((WIDTH/2) - BORDER) + PIECE_SIZE * 2, BORDER - PIECE_SIZE),
    }, new short[]{148, 56, 95}, (byte)0),
    ZLINE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER + PIECE_SIZE),
    }, new short[]{148, 56, 195}, (byte)0),
    SLINE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER + PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER - PIECE_SIZE),
    }, new short[]{237, 86, 162}, (byte)0),
    CUBE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER - PIECE_SIZE),
    }, new short[]{251, 210, 7}, (byte)-1),
    LINE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE * 2),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE * 3)
    }, new short[]{35, 204, 211}, (byte)1),
    TRIANGLE(new PVector[]{
      new PVector((WIDTH/2) - PIECE_SIZE - BORDER, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + 2 * PIECE_SIZE, BORDER)}, new short[]{235, 34, 15}, (byte)1),
    Y(new PVector[]{
      new PVector((WIDTH/2) - PIECE_SIZE - BORDER, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + 2 * PIECE_SIZE, BORDER)}, new short[]{235, 34, 15}, (byte)1),
    PLUS(new PVector[]{
      new PVector((WIDTH/2) - PIECE_SIZE - BORDER, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER + PIECE_SIZE),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + 2 * PIECE_SIZE, BORDER)}, new short[]{236, 223, 244}, (byte)1),
    LPIECE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE * 2),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
    }, new short[]{103, 197, 134}, (byte)1),
    LPIECEI(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE * 2),
      new PVector(((WIDTH/2) - BORDER) + PIECE_SIZE, BORDER ),
    }, new short[]{255, 155, 0}, (byte)1);

  private Piece(PVector[] body, short[] mainColor, byte rotationAnchor) {
    this.body = body;
    this.mainColor = mainColor;
    this.rotationAnchor = rotationAnchor;
  }

  private PVector[] body;
  private short[] mainColor;
  private byte rotationAnchor;

  public PVector[] getBody() {
    PVector[] newBody = new PVector[body.length];
    for (int i = 0; i< body.length; i++) {
      newBody[i] = new PVector(body[i].x, body[i].y);
    }
    return newBody;
  }

  public byte getRotationAnchor() {
    return this.rotationAnchor;
  }

  public void setBody(PVector[] positions) {
    this.body = positions;
  }

  public short[] getMainColor() {
    return mainColor;
  }
}
