class AgeComponent {
  int maxAge;
  int ageMinutes = 0;
  int ownerId;

  AgeComponent(this.maxAge);

  void update() {
    assert(ownerId != null);
    if (ageMinutes >= maxAge) {
      //world.solidObjects[ownerId].alive = false;
    }
  }
}
