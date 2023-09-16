public enum Piece {

  SIMPLE(new PVector[]{
    new PVector(WIDTH/2, BORDER),
    new PVector(WIDTH/2 * 2, BORDER),
    new PVector(WIDTH/2 * 3, BORDER),
    new PVector(WIDTH/2 * 2, BORDER - PIECE_SIZE),
    new PVector(WIDTH/2 * 2, BORDER - PIECE_SIZE * 2),
    new PVector(WIDTH/2 * 2, BORDER - PIECE_SIZE * 3),
    }),
    LINE(new PVector[]{
      new PVector(WIDTH/2, BORDER),
      new PVector(WIDTH/2, BORDER - PIECE_SIZE),
      new PVector(WIDTH/2, BORDER - PIECE_SIZE * 2),
      new PVector(WIDTH/2, BORDER - PIECE_SIZE * 3)
    }),
    TRIANGLE(new PVector[]{
      new PVector(WIDTH/2, BORDER),
      new PVector((WIDTH/2)+PIECE_SIZE, BORDER),
      new PVector((WIDTH/2)+PIECE_SIZE, BORDER - PIECE_SIZE),
      new PVector((WIDTH/2)+ 2 * PIECE_SIZE, BORDER)}),
    LPIECE(new PVector[]{
      new PVector(WIDTH/2, BORDER),
      new PVector(WIDTH/2 * 2, BORDER),
      new PVector(WIDTH/2 * 2, BORDER - PIECE_SIZE),
    });

  private Piece(PVector[] body) {
    this.body = body;
  }

  private PVector[] body;

  public PVector[] getBody() {
    return body;
  }
}
