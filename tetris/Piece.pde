public enum Piece {

  LSIMPLE(new PVector[]{
    new PVector(((WIDTH/2) - BORDER), BORDER),
    new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
    new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
    }),
    ZLINE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER + PIECE_SIZE),
    }),
    SLINE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER + PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER - PIECE_SIZE),
    }),
    CUBE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER - PIECE_SIZE),
    }),
    LINE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE * 2),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE * 3)
    }),
    TRIANGLE(new PVector[]{
      new PVector((WIDTH/2) - PIECE_SIZE - BORDER, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + 2 * PIECE_SIZE, BORDER)}),
    PLUS(new PVector[]{
      new PVector((WIDTH/2) - PIECE_SIZE - BORDER, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + PIECE_SIZE, BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - PIECE_SIZE - BORDER) + 2 * PIECE_SIZE, BORDER)}),
    LPIECE(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE * 2),
      new PVector(((WIDTH/2) - BORDER) - PIECE_SIZE, BORDER ),
    }),
    LPIECEI(new PVector[]{
      new PVector(((WIDTH/2) - BORDER), BORDER),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE),
      new PVector(((WIDTH/2) - BORDER), BORDER - PIECE_SIZE * 2),
      new PVector(((WIDTH/2) - BORDER) + PIECE_SIZE, BORDER ),
    });

  private Piece(PVector[] body) {
    this.body = body;
  }

  private PVector[] body;

  public PVector[] getBody() {
    PVector[] newBody = new PVector[body.length];
    for (int i = 0; i< body.length; i++) {
      newBody[i] = new PVector(body[i].x, body[i].y);
    }
    return newBody;
  }
}
