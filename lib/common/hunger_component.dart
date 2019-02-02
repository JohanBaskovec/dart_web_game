class HungerComponent {
  int hunger;
  int increasePerSecond;
  int ownerId;

  HungerComponent(this.hunger, this.increasePerSecond);

  void update() {
    /*
    assert(ownerId != null);
    assert(world.solidObjects[ownerId] != null);
    hunger += increasePerSecond;
    if (hunger >= 100) {
      world.solidObjects[ownerId].alive = false;
    }
    */
  }

  @override
  String toString() {
    return 'HungerComponent{hunger: $hunger, increasePerSecond: $increasePerSecond, ownerId: $ownerId}';
  }
}